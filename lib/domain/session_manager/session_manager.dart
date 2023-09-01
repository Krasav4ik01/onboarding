import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SessionManager {
  static final SessionManager instance = SessionManager._();
  SessionManager._();

  final secureStorage = const FlutterSecureStorage();

  static const serverURL = "https://developertestapi.site/zyn3Mv";

  Future<void> writeUserToken(String token) async {
    await secureStorage.write(key: 'user_token', value: token);
  }

  Future<String?> readUserToken() async {
    return secureStorage.read(key: 'user_token');
  }

  Future<void> storeKeyPair(String privateKey, String publicKey) async {
    await secureStorage.write(key: 'private_key', value: privateKey);
    await secureStorage.write(key: 'public_key', value: publicKey);
  }

  Future<Map<String, String?>> readKeyPair() async {
    return {
      'private_key': await secureStorage.read(key: 'private_key'),
      'public_key': await secureStorage.read(key: 'public_key')
    };
  }



  Future<void> handleLogin(String username, String password) async {
    // Здесь выполняется логика аутентификации пользователя

    // В случае успешной аутентификации, генерируем токен
    final token = generateToken();

    // Записываем токен в хранилище
    await writeUserToken(token);
  }

  Future<bool> checkLoginStatus() async {
    // Проверяем наличие токена в хранилище
    final token = await readUserToken();

    // Проверяем, истек ли срок действия токена
    final bool isTokenValid = checkTokenValidity(token);

    return token != null && isTokenValid ?? false;
  }

  String generateToken() {
    final expirationDate = DateTime.now().add(Duration(days: 7));

    final Map<String, dynamic> payload = {
      'exp': expirationDate.millisecondsSinceEpoch ~/ 1000, // Преобразуем в секунды
      // Добавьте другие поля, если необходимо
    };

    final base64Header = base64Url.encode(utf8.encode(json.encode({'alg': 'HS256', 'typ': 'JWT'})));
    final base64Payload = base64Url.encode(utf8.encode(json.encode(payload)));

    final signature = generateSignature(base64Header, base64Payload); // Генерируем подпись (signature)

    final token = '$base64Header.$base64Payload.$signature';
    print(expirationDate);

    return token;
  }

  String generateSignature(String base64Header, String base64Payload) {
    final secret = 'your_secret_key'; // Замените на ваш секретный ключ
    final encodedData = '$base64Header.$base64Payload';

    final hmacSha256 = Hmac(sha256, utf8.encode(secret));
    final signatureBytes = hmacSha256.convert(utf8.encode(encodedData)).bytes;

    final base64Signature = base64Url.encode(signatureBytes);

    return base64Signature;
  }

  bool checkTokenValidity(String? token) {
    // Проверка, истек ли срок действия токена
    if (token == null) {
      return false;
    }

    final expirationDate = DateTime.now().add(Duration(days: 7));

    return expirationDate.isAfter(DateTime.now());
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'user_token');
  }

  Future<void> handleSignOut() async {
    await deleteToken();

  }
  //For production+++++++++++++++++++++++
  Future<String?> getUserRole() async {
    final token = await readUserToken();
    if (token == null) {
      return 'null';
    }

    final url = Uri.parse('$serverURL/api/v1/users');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(response.body) as Map<String, dynamic>;
      final data = responseMap['data'] as List<dynamic>;
      if (data.isNotEmpty) {
        final firstUserData = data[0] as Map<String, dynamic>;
        final userRole = firstUserData['role'] as String?;
        print(userRole.runtimeType);
        print('' + userRole!);
        return userRole.toString();
      } else {
        throw Exception('User data is empty');
      }
    } else {
      throw Exception('Failed to get user role');
    }
  }

}
