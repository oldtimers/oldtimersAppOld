import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';
import 'package:oldtimers_rally_app/model/refresh.dart';
import 'package:tuple/tuple.dart';

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
    await storage.delete(key: "refresh");
    await storage.delete(key: "auth_key");
    return;
  }

  static Future<void> persistTokenAndRefresh(Tuple2<String, String> data) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "refresh", value: data.item1);
    await storage.write(key: "auth_key", value: data.item2);
    return;
  }

  Future<void> persistToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "auth_key", value: token);
    return;
  }

  static Future<Authentication?> retrieveAuthentication() async {
    final storage = FlutterSecureStorage();
    var auth = await storage.read(key: "auth_key");
    var refresh = await storage.read(key: "refresh");
    if (auth != null && JwtDecoder.getRemainingTime(auth).inSeconds > 3) {
      final Uri uri;
      if (kUseHTTPS) {
        uri = Uri.https(kServerUrl, kTokenVerify);
      } else {
        uri = Uri.http(kServerUrl, kTokenVerify);
      }
      var response = await http.get(uri, headers: {'Authorization': 'Bearer $auth'});
      if (response.statusCode != 200) {
        return null;
      } else {
        return Authentication(auth, refresh!, json.decode(utf8.decode(response.bodyBytes))['username']);
      }
    }
    if (refresh != null) {
      return refreshToken();
    } else {
      return null;
    }
  }

  static Future<Authentication?> refreshToken() async {
    final storage = FlutterSecureStorage();
    String? refresh = await storage.read(key: 'refresh');
    final Uri uri;
    if (kUseHTTPS) {
      uri = Uri.https(kServerUrl, kTokenRefresh);
    } else {
      uri = Uri.http(kServerUrl, kTokenRefresh);
    }
    if (refresh != null) {
      var body = Refresh(refresh);
      var response = await http.post(uri, body: jsonEncode(body.toJson()), headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        return null;
      } else {
        return Authentication.fromJson(jsonDecode(response.body));
      }
    }
    return null;
  }
}
