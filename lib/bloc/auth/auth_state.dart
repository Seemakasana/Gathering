import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String name;
  final String city;
  final String photoUrl;
  final String interest;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    required this.name,
    required this.city,
    required this.photoUrl,
    required this.interest,
  });

  @override
  List<Object> get props => [userId, email, name, photoUrl, interest];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

