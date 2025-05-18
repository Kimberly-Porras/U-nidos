import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterAccessCompleted extends RegisterState {}

class RegisterConfirmationCompleted extends RegisterState {}

class RegisterInterestsCompleted extends RegisterState {}

class RegisterProfileCompleted extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object> get props => [message];
}
