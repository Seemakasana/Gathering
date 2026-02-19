import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String city;
  final String interest;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.city,
    required this.interest,
  });

  @override
  List<Object> get props => [email, password, name, city, interest];
}

class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

