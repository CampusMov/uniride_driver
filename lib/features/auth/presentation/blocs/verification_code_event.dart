import 'package:equatable/equatable.dart';

abstract class VerificationCodeEvent extends Equatable {
  const VerificationCodeEvent();

  @override
  List<Object?> get props => [];
}

class CodeInputChanged extends VerificationCodeEvent {
  final String code;

  const CodeInputChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class SendVerificationCode extends VerificationCodeEvent {
  const SendVerificationCode();
}

class ResendVerificationEmail extends VerificationCodeEvent {
  const ResendVerificationEmail();
}

class LoadUserLocally extends VerificationCodeEvent {
  const LoadUserLocally();
}

class StartCountdown extends VerificationCodeEvent {
  const StartCountdown();
}

class CountdownTick extends VerificationCodeEvent {
  final int secondsLeft;

  const CountdownTick(this.secondsLeft);

  @override
  List<Object?> get props => [secondsLeft];
}

class HideErrorMessage extends VerificationCodeEvent {
  const HideErrorMessage();
}