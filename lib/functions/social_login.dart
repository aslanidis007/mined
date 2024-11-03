import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mined/constants/api/api_paths.dart';
import 'package:mined/services/auth_system.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constants/alert.dart';

class SocialLogin{
   static final AuthSystem socialAuth = AuthSystem();

  static googleSignIn(context) async {

    GoogleSignInAccount? user;
    if (Platform.isAndroid) {
      user = await ApiPaths.loginAndroid();
    } else {
      user = await ApiPaths.loginApple();
    }

    if (user == null) {
      // ignore: use_build_context_synchronously
    } else {
      // ignore: use_build_context_synchronously
      final token = await user.authentication;
      final List <String> fullName = user.displayName!.split(' ');
      final String firstName = fullName[0];
      final String lastName = fullName[1];

      socialAuth.signInUser(
        email: user.email,
        context: context,
        firstName: firstName,
        lastName: lastName,
        socialId: user.id.toString(),
        accessToken: token.toString(),
        signInType: 'social',
      );
    }
  }

  static appleSignIn(context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    
    if (credential.userIdentifier == null) {
      showMessage(message: "Sign in Failed", context: context);
    } else {

      if (credential.givenName == null || credential.familyName == null) {
        socialAuth.signInUser(
          email: credential.email,
          context: context,
          firstName: null,
          lastName: null,
          socialId: credential.userIdentifier.toString(),
          accessToken: credential.authorizationCode.toString(),
          signInType: 'social',
        );
      } else {
        socialAuth.signInUser(
          email: credential.email,
          context: context,
          firstName: credential.givenName,
          lastName: credential.familyName,
          socialId: credential.userIdentifier.toString(),
          accessToken: credential.authorizationCode.toString(),
          signInType: 'social',
        );
      }
    }
  }
}