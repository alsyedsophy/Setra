import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:setra/features/auth/domain/usecases/check_verification_email_use_case.dart';
import 'package:setra/features/auth/domain/usecases/send_email_verification_use_case.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _logInUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _signInWithGoogleUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;
  final LogoutUseCase _logOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthStateChangesUseCase _authStateChangesUseCase;
  final CheckVerificationEmailUseCase _checkVerificationEmailUseCase;
  final SendEmailVerificationUseCase
  _sendEmailVerificationUseCase; // 🔥 مضاف لإرسال رابط التفعيل

  StreamSubscription? _authSubscription;

  AuthCubit({
    required this._logInUseCase,
    required this._registerUseCase,
    required this._signInWithGoogleUseCase,
    required this._sendPasswordResetUseCase,
    required this._logOutUseCase,
    required this._getCurrentUserUseCase,
    required this._authStateChangesUseCase,
    required this._checkVerificationEmailUseCase,
    required this._sendEmailVerificationUseCase,
  }) : super(const AuthState()) {
    _listenToAuthChanges();
    checkCurrentUser();
  }

  AuthStatus _resolveAuthStatus(UserEntity user) {
    return user.isEmailVerified
        ? AuthStatus.authenticated
        : AuthStatus.unverified;
  }

  void _listenToAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = _authStateChangesUseCase().listen((user) {
      if (user != null) {
        emit(
          state.copyWith(
            status: _resolveAuthStatus(user),
            user: user,
            clearError: true,
          ),
        );
      } else {
        if (state.status != AuthStatus.failure) {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
              clearError: true,
            ),
          );
        }
      }
    });
  }

  Future<void> checkCurrentUser() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.message,
        ),
      ),
      (user) {
        if (user != null) {
          emit(
            state.copyWith(
              status: _resolveAuthStatus(user),
              user: user,
              clearError: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
              clearError: true,
            ),
          );
        }
      },
    );
  }

  Future<void> sendEmailVerification() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _sendEmailVerificationUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(status: AuthStatus.unverified, clearError: true)),
    );
  }

  Future<void> checkEmailVerified() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _checkVerificationEmailUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (isVerified) {
        if (isVerified) {
          checkCurrentUser();
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.unverified,
              errorMessage: "Not Confirme Email",
            ),
          );
        }
      },
    );
  }

  // ==================== Auth Methods ====================

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _logInUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: _resolveAuthStatus(user),
          user: user,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _registerUseCase(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: _resolveAuthStatus(user),
          user: user,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _signInWithGoogleUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: _resolveAuthStatus(user),
          user: user,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _sendPasswordResetUseCase(email: email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearError: true),
      ),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _logOutUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          clearError: true,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
