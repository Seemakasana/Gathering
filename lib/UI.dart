import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/bloc/auth/auth_bloc.dart';
import 'package:gathering/bloc/auth/auth_state.dart';
import 'package:gathering/pages/AuthPages/login_page.dart';
import 'package:gathering/pages/UserMainPage/home_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        }
        if (state is AuthAuthenticated) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}