import 'package:dartx/dartx.dart';
import 'package:riverpod_oauth_dio/riverpod_oauth_dio.dart';

extension OAuthX on OAuth {
  /// Returns `true` if the [OAuth] instance contains a token.
  Future<bool> get isSignedIn async {
    final token = await storage.fetch();
    return token?.accessToken != null && token!.accessToken!.isNotBlank;
  }

  /// Deletes any stored token.
  Future<void> signOut() => storage.clear();
}
