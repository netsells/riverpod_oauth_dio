import 'package:dio/dio.dart';
import 'package:oauth_dio/oauth_dio.dart';

/// Grant type for Client Credentials
class ClientCredentialsGrant implements OAuthGrantType {
  const ClientCredentialsGrant();

  @override
  RequestOptions handle(RequestOptions request) {
    request.data = <String, String>{
      'grant_type': 'client_credentials',
    };

    return request;
  }
}
