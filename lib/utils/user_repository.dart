import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

import '../const.dart';

class UserRepository {
  static Future<Tuple2<String, String>> login({
    @required String login,
    @required String password,
  }) async {
    final uri = Uri.http(kServerUrl, kTokenCreate);
    var body = json.encode({
      'username': login,
      'password': password,
    });

    print('Body: $body');
    print('URI: $uri');
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }

    var data = json.decode(response.body);
    var refresh = data['refresh'];
    var access = data['access'];
    return Tuple2(refresh, access);
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: "refresh");
    await storage.delete(key: "auth_key");
    return;
  }

  static Future<void> persistTokenAndRefresh(
      Tuple2<String, String> data) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "refresh", value: data.item1);
    await storage.write(key: "auth_key", value: data.item2);
    return;
  }

  Future<void> persistToken(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "auth_key", value: token);
    return;
  }

  static Future<String> getTokenAndVerify() async {
    const storage = FlutterSecureStorage();
    var auth = await storage.read(key: "auth_key");
    if (auth != null) {
      final uri = Uri.http(kServerUrl, kTokenVerify);
      var body = json.encode({
        'token': auth,
      });

      print('Body: $body');

      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode != 200) {
        var refresh = await storage.read(key: "refresh");
        if (refresh != null) {
          final uri = Uri.http(kServerUrl, kTokenRefresh);
          var body = json.encode({
            'refresh': refresh,
          });
          print('Body: $body');
          var response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $auth'
            },
            body: body,
          );
          if (response.statusCode != 200) {
            return null;
          }
          var data = json.decode(response.body);
          auth = data["access"];
          await storage.write(key: "auth_key", value: auth);
          return auth;
        } else {
          return null;
        }
      } else {
        return auth;
      }
    } else {
      return null;
    }
  }

  static Future<String> refreshToken() async {
    const storage = FlutterSecureStorage();
    String refresh = await storage.read(key: 'refresh');
    final uri = Uri.http(kServerUrl, kTokenRefresh);
    var body = json.encode({
      'refresh': refresh,
    });
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 200) {
      // throw ServerConnectionException();
      print("Could not refreshed JWT");
      // authBloc.add(LostAuthentication());
      return null;
    } else {
      print("Refreshed JWT");
      String access = json.decode(response.body)['access'];
      storage.write(key: 'auth_key', value: access);
      return access;
    }
  }
}
