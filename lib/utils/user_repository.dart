import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:oldtimers_rally_app/model/authentication.dart';
import 'package:oldtimers_rally_app/model/refresh.dart';

import '../const.dart';

class UserRepository {
  static Future<Authentication?> login({
    required String login,
    required String password,
  }) async {
    final Uri uri;
    if (kUseHTTPS) {
      uri = Uri.https(kServerUrl, kTokenCreate);
    } else {
      uri = Uri.http(kServerUrl, kTokenCreate);
    }
    var body = json.encode({
      'username': login,
      'password': password,
    });
    log(
      'Body: $body',
    );
    log('URI: $uri');
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 200) {
      log(response.body);
      return null;
    }

    var data = json.decode(utf8.decode(response.bodyBytes));
    return Authentication.fromJson(data);
  }

  static Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: "authentication");
  }

  static Future<void> persistAuthentication(Authentication authentication) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "authentication", value: jsonEncode(authentication.toJson()));
  }

  static Future<Authentication?> refreshToken() async {
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: "authentication");
    final Uri uri;
    if (kUseHTTPS) {
      uri = Uri.https(kServerUrl, kTokenRefresh);
    } else {
      uri = Uri.http(kServerUrl, kTokenRefresh);
    }
    if (data != null) {
      Authentication authentication = Authentication.fromJson(jsonDecode(data));
      var body = Refresh(authentication.refresh);
      var response = await http.post(uri, body: jsonEncode(body.toJson()), headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        return null;
      } else {
        await storage.write(key: "authentication", value: response.body);
        return Authentication.fromJson(jsonDecode(response.body));
      }
    }
    return null;
  }

  static Future<Authentication?> retrieveAuthentication() async {
    final storage = FlutterSecureStorage();
    var data = await storage.read(key: "authentication");
    if (data != null) {
      Authentication authentication = Authentication.fromJson(jsonDecode(data));
      if (authentication.expirationDate.compareTo(DateTime.now().add(const Duration(days: 1))) > 0) {
        return authentication;
      } else if (authentication.expirationDate.compareTo(DateTime.now().add(const Duration(minutes: 3))) > 0) {
        return refreshToken();
      }
    }
    return null;
  }
}
