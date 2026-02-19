import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/bloc/auth/auth_event.dart';
import 'package:gathering/bloc/auth/auth_state.dart';
import 'package:gathering/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.login(e.email, e.password);
      emit(_mapUser(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signup(e.name, e.email, e.password);
      emit(_mapUser(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleSignIn(
      GoogleSignInEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.googleLogin();
      emit(_mapUser(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
      LogoutEvent e, Emitter<AuthState> emit) async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent e, Emitter<AuthState> emit) async {
    final loggedIn = await _authService.isLoggedIn();
    if (!loggedIn) {
      emit(AuthUnauthenticated());
      return;
    }

    final user = await _authService.getLocalUser();
    if (user == null) {
      emit(AuthUnauthenticated());
      return;
    }

    print("user:::::::::::::::${user}");

    emit(AuthAuthenticated(
      userId: user['id']!,
      email: user['email']!,
      name: user['name']!,
      photoUrl: user['photoUrl'] ?? '',
      city: user['city'] ?? '',
      interest: user['interest'] ?? '',
    ));
  }

  AuthAuthenticated _mapUser(Map user) {
    return AuthAuthenticated(
      userId: user['id'],
      email: user['email'],
      name: user['name'] ?? '',
      photoUrl: user['photo_url'] ?? '',
      city: user['city'] ?? '',
      interest: user['interest'] ?? '',
    );
  }
}
