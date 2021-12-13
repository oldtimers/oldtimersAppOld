import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/utils/user_repository.dart';

import '../const.dart';

enum requestType { GET, POST, PUT, DELETE }

class ServerConnectionException implements Exception {}

class ServerConnector {
  static bool _isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  static Future<String> _handleAuthorization(
      AuthenticationBloc authBloc) async {
    String token = (authBloc.state as AuthenticationAuthenticated).authToken;
    try {
      if (_isTokenExpired(token)) {
        token = await UserRepository.refreshToken();
      }
    } catch (e) {
      authBloc.add(AuthenticationError());
      throw ServerConnectionException();
    }
    if (token == null) {
      authBloc.add(LostAuthentication());
      throw ServerConnectionException();
    }
    return token;
  }

  static Future makeRequest(
      String url, AuthenticationBloc authBloc, requestType type,
      {int statusCode = 200, body = Null}) async {
    String token = await _handleAuthorization(authBloc);
    var uri;
    if (kUseHTTPS) {
      uri = Uri.https(kServerUrl, url);
    } else {
      uri = Uri.http(kServerUrl, url);
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request;
    var response;
    switch (type) {
      case requestType.GET:
        request = http.get;
        response = await request(uri, headers: headers);
        break;
      case requestType.POST:
        request = http.post;
        response = await request(uri, headers: headers, body: body);
        break;
      case requestType.PUT:
        request = http.put;
        response = await request(uri, headers: headers, body: body);
        break;
      case requestType.DELETE:
        request = http.delete;
        response = await request(uri, headers: headers, body: body);
        break;
    }
    if (response.statusCode == statusCode) {
      return response;
    } else {
      print(response.body);
      print(json.decode(response.body));
      throw ServerConnectionException();
    }
  }
}
