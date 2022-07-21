import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_oauth_dio/riverpod_oauth_dio.dart';

/// Creates a [Provider] that provides an authenticated [Dio]
/// using the provided [OAuth] instance.
///
/// ```dart
/// final clientOAuthProvider = createOAuthProvider(
///   // ...
/// );
///
/// final clientDioProvider = createAuthenticatedDioProvider(
///   baseDio: (ref) => ref.watch(baseDioProvider),
///   oAuth: (ref) => ref.watch(clientOAuthProvider),
/// );
/// ```
// ignore: long-parameter-list
Provider<Dio> createAuthenticatedDioProvider({
  required Dio Function(Ref) baseDio,
  required OAuth Function(Ref) oAuth,
  String? name,
  List<ProviderOrFamily>? dependencies,
  Family<dynamic, dynamic, ProviderBase<dynamic>>? from,
  Object? argument,
}) {
  return Provider(
    (ref) => baseDio(ref)
      ..interceptors.add(
        BearerInterceptor(oAuth(ref)),
      ),
    name: name,
    dependencies: dependencies,
    from: from,
    argument: argument,
  );
}
