import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../domain/session_manager/session_manager.dart';
import '../loans/loan_page.dart';

//import '../ui/pages_for_driver/main_page_for_drivers/contracts_page_for_drivers/map.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (BuildContext context, Widget? child) {
        return FutureBuilder<String>(
          future: getInitialRouteForLoggedInUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: ThemeData.light(useMaterial3: true),
                initialRoute: snapshot.data!,
                routes: {
                  // "/register_page": (context) => const RegisterPage(),
                  "/": (context) => const LoanPage(),// MyApp(), PrivacyPolicy(),//
                  // "/": (context) => const MainPage(),
                  // "welcome_page": (context) => const WelcomePage(),
                  // "/main_page_for_drivers": (context) =>  MainPageForDrivers(),
                  // "/contract": (context) => const ContractInfoPage(),
                  // "/contract_driver": (context) => const ContractInfoPageForDrivers(),
                  // "/add_device": (context) => const AddDevicePage(),
                  // "/add_device/choose": (context) => const DeviceChoosePage(),
                  // "/add_device/confirm": (context) => const ConfirmSignPage(),
                  // "/add_device/device_characteristics": (context) => const DeviceAddingCharacteristicsPage(),
                  // "/device": (context) => const DeviceConfirmInfoPage(),
                  //   "/map":(context)=>const MapInfo(),
                },
              );
            } else if (snapshot.hasError) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: ThemeData.light(useMaterial3: true),
                initialRoute: '/register_page',

                routes: {
                  "/register_page": (context) => const LoanPage(),
                },
                onUnknownRoute: (settings) {
                  final userRole = SessionManager.instance.getUserRole();

                  if (userRole == 'DRIVER') {
                    return MaterialPageRoute(
                      builder: (context) => const LoanPage(),
                    );
                  } else {
                    return MaterialPageRoute(
                      builder: (context) => const LoanPage(),
                    );
                  }
                },

              );
            }
            else {
              return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent,backgroundColor: Colors.white));
            }
          },
        );
      },
    );
  }
  //
  // Future<String> getInitialRouteForLoggedInUser() async {
  //   final userToken = await SessionManager.instance.readUserToken(); // Assuming you have a function to read the user token
  //
  //   if (userToken == null) {
  //     return '/login_page'; // User is not logged in, redirect to login page
  //   }
  //
  //   try {
  //     final userPermissions = await SessionManager.instance.getUserPermissions();
  //     print('User Permissions: $userPermissions');
  //
  //     if (userPermissions.contains('get_orders_for_expeditor')) {
  //       return '/main_page_for_drivers';
  //     } else {
  //       return '/';
  //     }
  //   } catch (e) {
  //     // Handle exceptions, e.g., network errors or failed permission retrieval
  //     print('Error: $e');
  //     return '/login_page';
  //   }
  // }


  Future<String> getInitialRouteForLoggedInUser() async {
    final userRole = await SessionManager.instance.getUserRole();
    final userToken = await SessionManager.instance.readUserToken(); // Assuming you have a function to read the user token
    final keyPair = await SessionManager.instance.readKeyPair(); // Read the stored private and public keys

    print('User Role: $userRole');

    if (userRole == 'ADMIN' || userRole == 'USER1' || userRole == 'USER2') {
      return '/';
    }
    else if (userRole == 'DRIVER') {
      return '/main_page_for_drivers';
    } else if(keyPair['private_key'] == null ) {
      return '/register_page';
    } else{
      return '/login_page';

    }

  }

}
