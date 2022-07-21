import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_oauth_dio/riverpod_oauth_dio.dart';
import 'package:riverpod_oauth_dio/src/secure_token_storage.dart';

/// Creates a [Provider] that provides an instance of [OAuth],
/// configured with your credentials and storage.
///
/// The [tokenName] is used to reference the token in storage. Must be different
/// for each [OAuth] provider you create.
///
/// [tokenEndpoint] is the endpoint to use for token requests. By default this
/// is set to `'oauth/token'`.
///
/// [dio] should provide a [Dio] instance to use for token requests.
///
/// [secureStorage] can be used to provide a [SecureTokenStorage] instance.
/// Useful if you want to use a mock/fake version in tests.
// ignore: long-parameter-list
Provider<OAuth> createOAuthProvider({
  required String Function(Ref) tokenName,
  required String Function(Ref) clientId,
  required String Function(Ref) clientSecret,
  String Function(Ref) tokenEndpoint = _defaultTokenEndpoint,
  FlutterSecureStorage Function(Ref) secureStorage = _defaultStorage,
  required Dio Function(Ref) dio,
  String? name,
  List<ProviderOrFamily>? dependencies,
  Family<dynamic, dynamic, ProviderBase<dynamic>>? from,
  Object? argument,
}) {
  return Provider(
    (ref) {
      return OAuth(
        tokenUrl: tokenEndpoint(ref),
        clientId: clientId(ref),
        clientSecret: clientSecret(ref),
        storage: SecureTokenStorage(
          name: tokenName(ref),
          storage: secureStorage(ref),
        ),
        dio: dio(ref),
      );
    },
    name: name,
    dependencies: dependencies,
    from: from,
    argument: argument,
  );
}

String _defaultTokenEndpoint(Ref _) => 'oauth/token';
FlutterSecureStorage _defaultStorage(Ref _) => const FlutterSecureStorage();
