# riverpod_oauth_dio

![GitHub](https://img.shields.io/github/license/netsells/riverpod_oauth_dio)
[![Pub Version](https://img.shields.io/pub/v/riverpod_oauth_dio)](https://pub.dev/packages/riverpod_oauth_dio)
[![Style](https://img.shields.io/badge/style-netsells-%231d3d90)](https://pub.dev/packages/netsells_flutter_analysis)

Oven-ready OAuth 2.0 for [Riverpod](https://pub.dev/packages/riverpod) and [Dio](https://pub.dev/packages/dio).

## Features

- Easily create Dio instances with OAuth 2.0 interceptors built-in
- Out-of-the-box support for Client Credentials, Password and Refresh grant types
- Support for custom grant types
- Stores tokens securely using [FlutterSecureStorage](https://pub.dev/packages/flutter_secure_storage)

## Installation

```sh
flutter pub add riverpod_oauth_dio
```

## Usage

### Setup

#### Step 1: Configure your base Dio instance

You'll need a base instance of `Dio` which contains the global configuration options for your API such as the base URL. It's recommended to create this as a provider.

```dart
final baseDioProvider = Provider<Dio>(
    (_) {
        return Dio(BaseOptions(baseUrl: 'https://example.com'))
            ..interceptors.add(LogInterceptor());
    },
);
```

#### Step 2: Create an OAuth Provider

Using the `createOAuthProvider` method provided by this package, configure one or more OAuth providers.

```dart
final oAuthProvider = createOAuthProvider(
    tokenName: (_) => 'token', // If you have multiple OAuth providers, this needs to be unique for each one
    clientId: (ref) => ref.watch(clientIdProvider),
    clientSecret: (ref) => ref.watch(clientSecretProvider),
    secureStorage: (ref) => ref.watch(secureStorageProvider),
    dio: (ref) => ref.watch(baseDioProvider) // Use the [Dio] provider we created in Step 1,
    dependencies: [
        clientIdProvider,
        clientSecretProvider,
        secureStorageProvider,
        baseDioProvider,
    ],
);
```

#### Step 3: Create an authenticated Dio Provider

You can now use the OAuth provider we created in Step 2 to create an authenticated version of your base Dio instance.

```dart
final authenticatedDioProvider = createAuthenticatedDioProvider(
    baseDio: (ref) => ref.watch(baseDioProvider),
    oAuth: (ref) => ref.watch(oAuthProvider),
    dependencies: [
        baseDioProvider,
        oAuthProvider,
    ],
);
```

### Checking authentication status

You can then check the authentication status of an `OAuth` instance using the `isSignedIn` property:

```dart
final isSignedIn = await ref.watch(oAuthProvider).isSignedIn;
```

You could even create a provider for this in your app:

```dart
final signedInProvider = FutureProvider<bool>(
    (ref) => ref.watch(oAuthProvider).isSignedIn,
    dependencies: [oAuthProvider],
);
```

### Signing in

#### Step 1: Create a grant

There are a few grant types available out-of-the box, including `PasswordGrant`, `ClientCredentialsGrant`, and `RefreshTokenGrant`.

If needed, you can extend `OAuthGrantType` to create your own grant type. See the [documentation](https://pub.dev/packages/oauth_dio) for more details.

Here's an example using `PasswordGrant`:

```dart
final grant = PasswordGrant(username: 'email@example.com', password: 'password');
```

#### Step 2: Request and save a token

Using the grant you created above, call `requestTokenAndSave` on your `OAuth` instance:

```dart
await ref.read(oAuthProvider).requestTokenAndSave(grant); // This could throw a [DioError] which you'll need to handle.

ref.refresh(signedInProvider); // If you created a provider for the authentication state as above, this will refresh its status.
```

### Signing out

Simply call `signOut` on your `OAuth` instance:

```dart
await ref.read(oAuthProvider).signOut();
```
