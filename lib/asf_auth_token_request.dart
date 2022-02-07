import 'asf_auth_service_config.dart';

class AsfAuthTokenRequest {
  String clientId;
  String redirectUrl;

  String? clientSecret;
  List<String>? scopes;
  String? issuer;
  String? discoveryUrl;
  bool allowInsecureConnections;
  bool preferEphemeralSession;
  AsfAuthTokenRequest({
    required this.clientId,
    required this.redirectUrl,
    this.clientSecret,
    this.scopes,
    this.issuer,
    this.discoveryUrl,
    this.allowInsecureConnections = false,
    this.preferEphemeralSession = false,
  });
}
