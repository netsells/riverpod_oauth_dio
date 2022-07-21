import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth_dio/oauth_dio.dart';

class SecureTokenStorage extends OAuthStorage {
  SecureTokenStorage({
    required String name,
    required FlutterSecureStorage storage,
  })  : _name = name,
        _storage = storage;

  final FlutterSecureStorage _storage;

  final String _name;

  String get accessTokenKey => '${_name}_accessToken';
  String get refreshTokenKey => '${_name}_refreshToken';

  @override
  Future<OAuthToken> fetch() async {
    return OAuthToken(
      accessToken: await _storage.read(key: accessTokenKey),
      refreshToken: await _storage.read(key: refreshTokenKey),
    );
  }

  @override
  Future<OAuthToken> save(OAuthToken token) async {
    await _storage.write(key: accessTokenKey, value: token.accessToken);
    await _storage.write(key: refreshTokenKey, value: token.refreshToken);
    return token;
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }
}
