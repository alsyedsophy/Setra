import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/errors/exceptions.dart';

class ExceptionsMapper {
  ExceptionsMapper._();

  static Exceptions handleFirebaseAuthException(FirebaseAuthException e) {
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

  static Exceptions handleFirebaseFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
      case 'network-request-failed':
      case 'deadline-exceeded':
        return NetworkException(
          message: e.message ?? 'لا يوجد اتصال بالإنترنت',
        );

      case 'permission-denied':
      case 'unauthenticated':
        return AuthException(
          message: e.message ?? 'ليس لديك صلاحية للقيام بهذا الإجراء',
        );

      case 'not-found':
        return ServerException(message: e.message ?? 'العنصر غير موجود');

      case 'failed-precondition':
        return ServerException(
          message: e.message ?? 'فشل الاستعلام — تحقق من فهارس Firestore',
        );

      case 'cancelled':
        return NetworkException(message: 'تم إلغاء الطلب');

      case 'already-exists':
        return ServerException(message: e.message ?? 'العنصر موجود بالفعل');

      case 'resource-exhausted':
        return ServerException(
          message: e.message ?? 'تم استهلاك الحد المسموح، حاول لاحقاً',
        );

      default:
        return ServerException(message: e.message ?? 'حدث خطأ في السيرفر');
    }
  }

  static Exceptions handleUnknowException(dynamic error) {
    if (error is Exceptions) return error;
    if (error is FirebaseAuthException) {
      return handleFirebaseAuthException(error);
    }
    if (error is FirebaseException) {
      return handleFirebaseFirestoreException(error);
    }
    return UnKnowException(message: error?.toString() ?? 'حدث خطأ غير متوقع');
  }
}
