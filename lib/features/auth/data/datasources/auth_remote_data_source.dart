import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<UserModel> signInWithGoogle();
  Future<bool> checkEmailVerified();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user == null) return null;

      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw AuthException(message: 'User not found');

      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw AuthException(message: 'Failed to create user');

      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // يجب ان يتم التعريف اولا قبل اى شئ
  Future<void> _intializeGoogle() async {
    await _googleSignIn.initialize(serverClientId: '');
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await _intializeGoogle();
      final GoogleSignInAccount googleUser = await _googleSignIn
          .authenticate(); // فتح شاشة التسجيل
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication; // الحصول على معلومات المسنتخدم لعد التسجيل
      final scope = <String>['email', 'profile', 'openid'];
      final authClient = _googleSignIn.authorizationClient;
      var authorization = await authClient.authorizationForScopes(scope);
      if (authorization == null) {
        final authoriseResult = await authClient.authorizationForScopes(scope);
        if (authoriseResult!.accessToken.isEmpty) {
          throw AuthException(message: 'فشل الحصول على التفويض');
        }
        authorization = authoriseResult;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization.accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw AuthException(message: 'فشل تسجيل الدخول الى Firebase');
      }

      return UserModel(
        id: user.uid,
        name: user.displayName ?? googleUser.displayName ?? '',
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // ==================== Helper ====================
  Exceptions _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException(message: 'هذا المستخدم غير مسجل');
      case 'wrong-password':
      case 'invalid-credential':
        return AuthException(
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );

      case 'email-already-in-use':
        return AuthException(message: 'البريد الإلكتروني مستخدم بالفعل');

      case 'weak-password':
        return ValidationException(message: 'كلمة المرور ضعيفة جداً');

      case 'invalid-email':
        return ValidationException(message: 'البريد الإلكتروني غير صالح');

      case 'network-request-failed':
        return NetworkException(message: 'لا يوجد اتصال بالإنترنت');

      case 'too-many-requests':
        return AuthException(message: 'محاولات كثيرة جداً، حاول لاحقاً');

      default:
        return AuthException(message: e.message ?? 'حدث خطأ أثناء المصادقة');
    }
  }
}
