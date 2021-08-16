///Firebase Resource Invocations

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itarashop/api/env.dart';
import '../api/Client.dart';
import '../model/User.dart';
import 'err.dart';

class FirebaseResource {
  final Client _client = Client();
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Google Sign In
  Future<User?> googleSignIn() async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount!.authentication;

      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken,
      );

      fb.UserCredential result = await _auth.signInWithCredential(credential);
      // The info here from firebase returns an object with either fullname or diplayName

      User user = await _client.post(
        User.registerUserFromSocial(result.user!),
      );

      // returns user object from the API. Returns fullname but with firstName nad lastName being null.

      // save userId and tokens
      await user.saveId();

      return user;
    } catch (e) {
      await ShowErrors.showErrors(e.toString());
    }
  }

  Future<User> facebookSignIn() async {
    return User();
    // try {
    //   await FacebookAuth.instance.logOut();
    //   final AccessToken result = await FacebookAuth.instance.login();
    //   print('This is the result: ' + result.toString());
    //   bool isLoggedIn = result != null && !result.isExpired;
    //   print('This is the logged in state: $isLoggedIn');
    //   if (result != null && result.token != null) {
    //     print('This is the result: ' + result.toString());
    //     User user = await processFacebook(result);
    //     return user;
    //   } else {
    //     await ShowErrors.showErrors('Sign In provider failed to send token');
    //     return null;
    //   }
    // } on FacebookAuthException catch (e) {
    //   await ShowErrors.showErrors(e.message);
    //   return null;
    // }
  }

  // Future<User> processFacebook(AccessToken result) async {
  //   try {
  //     final facebookAuthCredential =
  //         fb.FacebookAuthProvider.credential(result.token);

  //     fb.UserCredential credential = await fb.FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential);

  //     User user = await _client.post(
  //       User.registerUserFromSocial(credential.user),
  //     );

  //     await user.saveId();

  //     return user;
  //   } on fb.FirebaseAuthException catch (e) {
  //     await ShowErrors.showErrors(e.message);
  //     return null;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<User?> twitterSignIn() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: Env.twitterApiKey,
      consumerSecret: Env.twitterSecretKey,
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        User? user =
            await _sendTokenAndSecretToServer(session.token, session.secret);
        return user;
        break;
      case TwitterLoginStatus.cancelledByUser:
        ShowErrors.showErrors('Authentication process was terminated by User');
        return null;
        // _showCancelMessage();
        break;
      case TwitterLoginStatus.error:
        // _showErrorMessage(result.error);
        ShowErrors.showErrors('Unable to complete authentication request');
        return null;
        break;
      default:
        return null;
        break;
    }
  }

  Future<User?> _sendTokenAndSecretToServer(String token, String secret) async {
    try {
      final twitterAuthCredential =
          fb.TwitterAuthProvider.credential(accessToken: token, secret: secret);

      fb.UserCredential result = await fb.FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential)
          .then((value) {
        return value;
      }).catchError((e) {
        throw e;
      });
      User user = await _client.post(
        User.registerUserFromSocial(result.user!),
      );

      await user.saveId();

      return user;
    } on fb.FirebaseAuthException catch (e) {
      await ShowErrors.showErrors(e.message!);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
