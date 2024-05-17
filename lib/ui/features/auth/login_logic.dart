import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../data/getstore/get_store_helper.dart';
import '../../../data/network/auth/auth_repository.dart';
import '../../../di/components/service_locator.dart';
import '../../../models/token/token_request.dart';
import '../../../models/token/token_response.dart';
import '../../../utils/firebase_utils.dart';
import '../../../utils/riverpod_extensions.dart';
import 'login_ui_model.dart';

part 'login_logic.g.dart';

@riverpod
Future<TokenResponse?> fetchToken(FetchTokenRef ref) async {
  final GetStoreHelper getStoreHelper = getIt<GetStoreHelper>();

  final AuthRepository authRepository = ref.watch(getAuthRepositoryProvider);
  final TokenResponse getTokenResponse =
      await authRepository.getToken(TokenRequest()).then((TokenResponse value) {
    if (value.token != null) {
      getStoreHelper.saveToken(value.token!);
      ref.cacheFor(const Duration(days: 3));
    } else
      throw Exception('Token is null');
    return value;
  });
  return getTokenResponse;
}

@riverpod
class LoginLogic extends _$LoginLogic {
  @override
  LoginUiModel build() {
    ref.cacheFor(const Duration(minutes: 10));
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId: Platform.isIOS
                  //!TODO: Put this in an env file
                  ? '247383540944-p3ji8erp1cscvs4hov7prbahfbqtpbrp.apps.googleusercontent.com'
                  : null)
          .signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      setLogin(isLoading: true);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e, stackTrace) {
      Logger().e(e.toString());
      setError(e.toString());
      setLogin();
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
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      setLogin(isLoading: true);
      await FirebaseAuth.instance.signInWithCredential(credential);
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
      final GetStoreHelper getStoreHelper = getIt<GetStoreHelper>();
      getStoreHelper.clear();
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
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(await platformAuthCredential)
          .then((UserCredential value) async {
        await FirebaseAuth.instance.currentUser?.delete();
        if (await GoogleSignIn().isSignedIn()) {
          await GoogleSignIn().disconnect();
          await GoogleSignIn().signOut();
        }
        return true;
      });
      return true;
    } catch (e) {
      debugPrint('Error: $e');
      setError(e.toString());
      return false;
    }
  }

  Future<AuthCredential> get appleAuthCredential async {
    // Construct an `OAuthCredential` from the credential returned by the
    // request.
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
    return oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
  }

  Future<AuthCredential> get googleAuthCredential async {
    // Obtain the auth details from the request
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId: Platform.isIOS
                ? '247383540944-p3ji8erp1cscvs4hov7prbahfbqtpbrp.apps.googleusercontent.com'
                : null)
        .signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    return GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  }

  Future<AuthCredential> get platformAuthCredential async {
    // Look at the platform and decide which credentials to use
    final AuthCredential credential =
        Platform.isIOS ? await appleAuthCredential : await googleAuthCredential;
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
      await ref.read(fetchTokenProvider.future);
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
