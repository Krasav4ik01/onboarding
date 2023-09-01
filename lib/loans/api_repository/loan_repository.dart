import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/session_manager/session_manager.dart';


class LoanRepository {
  final String apiUrl = SessionManager.serverURL + '/api/v1/notifications';

  LoanRepository();

  Future<dynamic> getNotifications() async {
    final token = await SessionManager.instance.readUserToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception(
          'Failed to load notifications ${response.statusCode} ${response.body} ');
    }
  }
}