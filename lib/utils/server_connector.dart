import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oldtimers_rally_app/authentication/authentication.dart';
import 'package:oldtimers_rally_app/model/authentication.dart';
import 'package:oldtimers_rally_app/utils/user_repository.dart';

import '../const.dart';

enum requestType { GET, POST, PUT, DELETE }

class ServerConnectionException implements Exception {}

class ServerConnector {
  static bool _isTokenExpired(String token) {
    return JwtDecoder.getRemainingTime(token).inSeconds < 3;
  }

  static Future<Authentication> _handleAuthorization(AuthenticationBloc authBloc) async {
    Authentication? authentication = (authBloc.state as AuthenticationAuthenticated).authentication;
    try {
      if (_isTokenExpired(authentication.access)) {
        authentication = await UserRepository.refreshToken();
      }
    } catch (e) {
      authBloc.add(AuthenticationError());
      throw ServerConnectionException();
    }
    if (authentication == null) {
      authBloc.add(LostAuthentication());
      throw ServerConnectionException();
    }
    return authentication;
  }

  static Future<http.Response> makeRequest(String url, AuthenticationBloc authBloc, requestType type, {Set<int> statusCode = const {200}, body = Null}) async {
    Authentication authentication = await _handleAuthorization(authBloc);
    var uri;
    if (kUseHTTPS) {
      uri = Uri.https(kServerUrl, url);
    } else {
      uri = Uri.http(kServerUrl, url);
    }
    Map<String, String> headers = {'Authorization': 'Bearer ${authentication.access}'};
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
    if (statusCode.contains(response.statusCode)) {
      return response;
    } else {
      log(response.body);
      log(json.decode(response.body));
      throw ServerConnectionException();
    }
  }
}
