library asf_auth_web;

import 'dart:html' as html;

/// A Calculator.
class AsfAuthWeb {
  html.WindowBase? _loginPopup;

  AsfAuthWeb() {}

  authenticate() {
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
}
