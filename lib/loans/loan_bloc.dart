import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../domain/session_manager/session_manager.dart';
import 'api_repository/loan_repository.dart';

import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';


abstract class LoanAction {
  const LoanAction();
}

abstract class LoanState {
  const LoanState();
}

class InitialLoanState implements LoanState {
  final bool isLoading;
  final Function? navigatorFunction;
  final String? error;

  const InitialLoanState.empty()
      : isLoading = false,
        navigatorFunction = null,
        error = null;

  InitialLoanState({
    required this.error,
    required this.isLoading,
    required this.navigatorFunction,
  });
}

class TryLoanAction implements LoanAction {
  final String email;
  final String password;
  final BuildContext context;

  TryLoanAction({
    required this.context,
    required this.email,
    required this.password,
  });
}

class LoanBloc extends Bloc<LoanAction, LoanState> {
  LoanBloc() : super(const InitialLoanState.empty()) {
    on<TryLoanAction>(
          (event, emit) async {
        emit(InitialLoanState(
          isLoading: true,
          navigatorFunction: null,
          error: null,
        ));
        final client = HttpClient();
        const host = '${SessionManager.serverURL}/api/v1/auth/authenticate';
        final url = Uri.parse(host);

        final parameters = {
          "email": event.email,
          'password': event.password,
        };

        final request = await client.postUrl(url);
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(parameters));

        final response = await request.close();
        print(response);

        final responseBody = await response.transform(utf8.decoder).join();

        final responseMap = jsonDecode(responseBody) as Map<String, dynamic>;
        print(responseMap);
        final data = responseMap['data'];

        if (data is Map<String, dynamic>) {
          final token = data['token'];
          await SessionManager.instance.writeUserToken(token);

          final userRole = data['user_info']['role'];
          // final roleName = userRole['name'] as String;

          // final permissions = userRole['permissions'] as List<dynamic>;

          if (response.statusCode.toString() == '200') {
            if (userRole == "USER1" || userRole == "ADMIN" || userRole == "USER2") {
              emit(InitialLoanState(
                isLoading: false,
                navigatorFunction: () =>
                    Navigator.of(event.context).pushNamed("/"),
                error: null,
              ));
            } else {
              emit(InitialLoanState(
                isLoading: false,
                navigatorFunction: () => Navigator.of(event.context)
                    .pushNamed("/main_page_for_drivers"),
                error: null,
              ));
            }
            print('Rustemnin user role $userRole');
          } else {
            emit(InitialLoanState(
              isLoading: false,
              navigatorFunction: null,
              error: "Incorrect email or password. Please try again",
            ));
          }
        } else {
          // Обработайте ситуацию, когда 'data' не является картой, как это было ожидаемо.
          // Например, можно установить значения по умолчанию или обработать ошибку.
          emit(InitialLoanState(
            isLoading: false,
            navigatorFunction: null,
            error: "Error parsing server response",
          ));
        }
      },
    );
  }
}

//
// @immutable
// abstract class LoanState {}
//
// class LoanInitial extends LoanState {}
//
// class LoanError extends LoanState {
//   final String errorMessage;
//
//   LoanError(this.errorMessage);
// }
//
// class LoanLoaded extends LoanState {
//   final List<dynamic> data;
//   LoanLoaded({required this.data});
//   @override
//   String toString() => 'NotificationLoaded(data: $data, )';
// }
//
// @immutable
// abstract class NotificationEvent {}
//
// class FetchNotifications extends NotificationEvent {}
//
// class LoanBloc extends Bloc<NotificationEvent, LoanState> {
//   final LoanRepository notificationRepository;
//
//   LoanBloc()
//       : notificationRepository = LoanRepository(),
//         super(LoanInitial()) {
//     on<FetchNotifications>((event, emit) async {
//       emit(LoanInitial());
//       try {
//         final data = await notificationRepository.getNotifications();
//         emit(LoanLoaded(
//           data: data,
//         ));
//       } catch (e) {
//         emit(LoanError(e.toString()));
//       }
//     });
//   }
// }
