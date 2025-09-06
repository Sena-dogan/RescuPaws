import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../firebase_options.dart';
import '../../../../utils/firebase_utils.dart';
import '../../../../utils/riverpod_extensions.dart';
import '../domain/login_ui_model.dart';

part 'login_logic.g.dart';

@riverpod
class LoginLogic extends _$LoginLogic {
  @override
  LoginUiModel build() {
    ref..cacheFor(const Duration(minutes: 10))..onDispose(() {
      state.numberController?.dispose();
      state.otpController?.dispose();
    });
    return LoginUiModel(
      numberController: TextEditingController(
        text: '+90',
      ),
      otpController: TextEditingController(),
    );
   
  }

  void setLogin({bool isLoading = false}) {
    state = state.copyWith(isLoading: isLoading, isLoggedIn: true);
  }

  void clear() {
    state = state.copyWith(error: null, isLoading: false);
  }

  void setVertificationId(String? vertificationId) {
    state = state.copyWith(vertificationId: vertificationId);
  }

  void setResendToken(int? resendToken) {
    debugPrint('Resend token: $resendToken');
    state = state.copyWith(resendToken: resendToken);
  }

  Future<bool> verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          final TextEditingController? controller = state.otpController;
          controller?.setText(credential.smsCode ?? '');
          state = state.copyWith(otpController: controller);
        },
        verificationFailed: (FirebaseAuthException e) {
          Logger().e(e.toString());
          setError(e.toString());
        },
        codeSent: (String vertificationId, int? resendToken) {
          Logger().i('Code sent: $vertificationId - $resendToken');
          setVertificationId(vertificationId);
          setResendToken(resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setVertificationId(verificationId);
        },
      );
      return true;
    } catch (e) {
      Logger().e(e.toString());
      setError(e.toString());
      return false;
    } finally {
      setLogin();
    }
  }

  Future<bool> verifySmsCode(String smsCode) async {
    if (state.vertificationId == null) {
      throw const FormatException('Verification id is required');
    }
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.vertificationId!,
        smsCode: smsCode,
      );
      setLogin(isLoading: true);
      await currentUser.linkWithCredential(credential);
      return true;
    } catch (e) {
      Logger().e(e.toString());
      setError(e.toString());
      return false;
    } finally {
      setLogin();
    }
  }

  Future<bool> resendSmsCode() async {
    if (state.resendToken == null) {
      throw const FormatException('Resend token is required');
    }
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: state.numberController?.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          final TextEditingController? controller = state.otpController;
          controller?.setText(credential.smsCode ?? '');
          state = state.copyWith(otpController: controller);
        },
        verificationFailed: (FirebaseAuthException e) {
          Logger().e(e.toString());
          setError(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          Logger().i('Code sent');
          setVertificationId(verificationId);
          setResendToken(resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setVertificationId(verificationId);
        },
        forceResendingToken: state.resendToken,
      );
      return true;
    } catch (e) {
      Logger().e(e.toString());
      setError(e.toString());
      return false;
    } finally {
      setLogin();
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final AuthCredential credential = await googleAuthCredential;
      setLogin(isLoading: true);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      if (e is PlatformException && e.code == 'sign_in_canceled') {
        // User cancelled the sign-in process
        return false;
      }

      Logger().e(e.toString());
      setError(e.toString());
      return false;
    } finally {
      setLogin();
    }
  }

  Future<bool> signInWithApple() async {
    debugPrint(
        'hello my name is apple. i am 7 years old. i like to eat apples');
    try {
      debugPrint(
          'AAAAAAAAAA my name is apple. i am 7 years old. i like to eat apples');

      final AppleAuthProvider appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('full_name');
      setLogin(isLoading: true);
      await FirebaseAuth.instance.signInWithProvider(appleProvider);
      return true;
    } catch (e) {
      Logger().e(e.toString());
      setError(e.toString());
      return false;
    } finally {
      setLogin();
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Check google sign in
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      }
      return true;
    } catch (e) {
      debugPrint('Error: $e');
      setError(e.toString());
      return false;
    }
  }

  Future<bool> removeUser() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final bool isGoogleSignedIn = await googleSignIn.isSignedIn();

      if (isGoogleSignedIn) {
        // Reauthenticate with Google credential
        await FirebaseAuth.instance.currentUser
            ?.reauthenticateWithCredential(await googleAuthCredential)
            .then((UserCredential value) async {
          await FirebaseAuth.instance.currentUser?.delete();
          await googleSignIn.disconnect();
          await googleSignIn.signOut();
        });
      } else {
        // Reauthenticate with provider
        final AppleAuthProvider appleProvider = AppleAuthProvider();
        await FirebaseAuth.instance.currentUser
            ?.reauthenticateWithProvider(appleProvider)
            .then((UserCredential value) async {
          await FirebaseAuth.instance.currentUser?.delete();
        });
      }
      return true;
    } catch (e) {
      debugPrint('Error: $e');
      setError(e.toString());
      return false;
    }
  }

  Future<AuthCredential> get googleAuthCredential async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      /// Check the os
      clientId: Platform.isIOS
          ? DefaultFirebaseOptions.currentPlatform.iosClientId
          : DefaultFirebaseOptions.currentPlatform.androidClientId,
      scopes: <String>[
        'email',
        'profile',
      ],
    ).signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return credential;
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void setLoggedIn(bool isLoggedIn) {
    state = state.copyWith(isLoggedIn: isLoggedIn);
  }

  void toggleObscure() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  Future<bool> forgotPassword() async {
    if (state.email == null || state.email!.isEmpty) {
      throw const FormatException('Lütfen email adresinizi giriniz.');
    }
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: state.email!)
        .then((void value) {
      Logger().i('Password reset email sent');
    }).catchError((Object e) {
      switch (e.toString()) {
        case 'user-not-found':
          throw const FormatException('Kullanıcı bulunamadı');
        case 'invalid-email':
          throw const FormatException('Geçersiz email adresi');
        default:
          throw const FormatException('Bir hata oluştu');
      }
    });
    return true;
  }

  void emailChanged(String value) {
    state = state.copyWith(email: value);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value);
  }

  Future<bool> signInWithEmailAndPassword() async {
    if (state.email == null || state.password == null) {
      throw const FormatException('Email and password are required');
    }
    try {
      setLogin(isLoading: true);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: state.email!,
        password: state.password!,
      )
          .then((UserCredential value) {
        Logger().i(value.user?.metadata);
      });
      return true;
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    } finally {
      setLogin();
    }
  }

  Future<bool> signUpWithEmailAndPassword() async {
    try {
      setLogin(isLoading: true);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: state.email!,
        password: state.password!,
      )
          .then((UserCredential value) async {
        // Log the ip address and other user details
        Logger().i(value.user?.metadata);
        await value.user?.sendEmailVerification();
      });
      return true;
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
  }

  void dispose() {
    state = const LoginUiModel();
  }

  void passwordConfirmChanged(String value) {
    state = state.copyWith(confirmPassword: value);
  }
}
