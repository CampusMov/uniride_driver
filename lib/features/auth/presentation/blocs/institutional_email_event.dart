

import 'package:equatable/equatable.dart';

abstract class InstitutionalEmailEvent extends Equatable {
  const InstitutionalEmailEvent();

  @override
  List<Object> get props => [];
}

class EmailInputChanged extends InstitutionalEmailEvent {
  final String email;

  const EmailInputChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SendVerificationEmailRequested extends InstitutionalEmailEvent {
  const SendVerificationEmailRequested();
}