import 'package:equatable/equatable.dart';

abstract class VerifyEmailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailCounting extends VerifyEmailState {
  final int secondsLeft;

  VerifyEmailCounting(this.secondsLeft);
  @override
  List<Object?> get props => [secondsLeft];
}

class VerifyEmailFinished extends VerifyEmailState {}
