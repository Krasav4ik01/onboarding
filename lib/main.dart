import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'application/application.dart';
import 'domain/session_manager/session_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // runApp(const Application());
  WidgetsFlutterBinding.ensureInitialized();

  // Проверяем статус входа пользователя
  final isUserLoggedIn = await SessionManager.instance.checkLoginStatus();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

// Объединение настроек для обеих платформ
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: Platform.isIOS ? initializationSettingsIOS : null,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Register the headless task function.
  runApp(Application());
}
