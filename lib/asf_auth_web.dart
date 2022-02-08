library asf_auth_web;

import 'dart:core';
import 'dart:html' as html;

import 'package:asf_auth_web/app_auth_web.dart';
import 'package:asf_auth_web/asf_auth_service_config.dart';
import 'package:flutter_appauth_platform_interface/flutter_appauth_platform_interface.dart';

import 'asf_auth_token_request.dart';
import 'asf_token_response.dart';

/// A Calculator.
class AsfAuthWeb {
  html.WindowBase? _loginPopup;
  final AppAuthWebPlugin _appAuthWebPlugin = AppAuthWebPlugin();

  AsfAuthWeb._privateConstructor();

  static final AsfAuthWeb instance = AsfAuthWeb._privateConstructor();

  factory AsfAuthWeb() {
    return instance;
  }

  authenticateAndListen(AsfAuthTokenRequest request) {
    html.window.onMessage.listen((event) {
      // The event contains the token which means the user is connected.
      if (event.data.toString().contains('code=')) {
        //_login(event.data);
        print(event.data);
        final currentUrl = Uri.base;
        final fragments = currentUrl.fragment.split('&');
        final _token = fragments
            .firstWhere((e) => e.startsWith('code='))
            .substring('code='.length);
        this._loginPopup?.close();
      }
    });
// https://login-dev.asfweb.it/fbce008c-b9ac-4aa3-928b-9fcaea28fa44/Account/Login?ReturnUrl=%2Ffbce008c-b9ac-4aa3-928b-9fcaea28fa44%2Fconnect%2Fauthorize%2Fcallback%3Fresponse_type%3Dcode%26client_id%3Dcardmanagermobileclient%26redirect_uri%3Dit.asf.cardmanager%253A%252Foauthredirect%26scope%3Dopenid%2520profile%2520roles%2520offline_access%2520cardmanager%2520asfappcore%26state%3D0966351392878V3684350SYB0%26code_challenge%3DrLTzyYq6dT6YocNYC1jw0QyOUm9eCtpNpotowkATUkw%26code_challenge_method%3DS256'
    final currentUri = Uri.base;
    final redirectUri = Uri(
      host: currentUri.host,
      scheme: currentUri.scheme,
      port: currentUri.port,
      path: '/',
    );
    final authUrl =
        'https://accounts.google.com/o/oauth2/auth/oauthchooseaccount?client_id=23550971769-mf7kqg1k1hnh4jkdl5ibj6oqob8ss92n.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2F&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform&code_challenge_method=S256&code_challenge=HXK2xezgLHvICVBLGvPhk5T8NEFxbVAmnof8XzJxDvc&flowName=GeneralOAuthFlow';

    // Keeping a reference to the popup window so you can close it after login is completed
    this._loginPopup = html.window
        .open(authUrl, "Google Auth", "width=800, height=900, scrollbars=yes");
  }

  Future<AsfTokenResponse?> authenticate(AsfAuthTokenRequest request) async {
    final response = await _appAuthWebPlugin.authorizeAndExchangeCode(
      AuthorizationTokenRequest(request.clientId, request.redirectUrl,
          issuer: request.issuer,
          serviceConfiguration: AuthorizationServiceConfiguration(
            request.authorizationEndpoint,
            request.tokenEndpoint,
          ),
          scopes: request.scopes,
          preferEphemeralSession: false,
          additionalParameters: {"port": "8080"}),
    );

    if (response != null) {
      final asfTokenResponse = AsfTokenResponse(
          response.accessToken,
          response.refreshToken,
          response.accessTokenExpirationDateTime,
          response.idToken,
          response.tokenType,
          response.tokenAdditionalParameters);
      return asfTokenResponse;
    }
    return null;
  }

  Future<AsfTokenResponse?> refresh(
      String refreshToken, AsfAuthTokenRequest request) async {
    try {
      if (refreshToken == '') {
        throw Exception('Refresh token can\'t be empty');
      }

      final TokenResponse? response = await _appAuthWebPlugin.token(
        TokenRequest(
          request.clientId,
          request.redirectUrl,
          discoveryUrl: request.discoveryUrl,
          refreshToken: refreshToken,
          scopes: request.scopes,
          additionalParameters: request.parameter,
        ),
      );
      if (response != null) {
        final refreshTokenResponse = AsfTokenResponse(
          response.accessToken,
          response.refreshToken,
          response.accessTokenExpirationDateTime,
          response.idToken,
          response.tokenType,
          response.tokenAdditionalParameters,
        );
        return refreshTokenResponse;
      } else {
        throw Exception('Refresh token request failed');
      }
    } catch (e) {
      throw Exception('Refresh token request failed');
    }
  }
}
