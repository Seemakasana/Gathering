
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/UI.dart';
import 'package:gathering/bloc/auth/auth_event.dart';
import 'package:gathering/bloc/event/event_bloc.dart';
import 'package:gathering/services/EventRepository.dart';
import 'package:gathering/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bloc/auth/auth_bloc.dart';
import 'constants/app_colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bkktmubyxaicjxzmxhib.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJra3RtdWJ5eGFpY2p4em14aGliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkyOTgzMTUsImV4cCI6MjA4NDg3NDMxNX0.Jfk2R-MxL5hq7iPo2tQaBebapZqmU6wtaJ7gwsUwhPM',
  );

  runApp( MultiBlocProvider(
      providers: [
        BlocProvider<EventBloc>(
          create: (_) => EventBloc(EventRepository()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthService()),
        ),
      ],child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthService())..add(CheckAuthEvent()),
      child: MaterialApp(
        title: 'Gathering',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            background: AppColors.background,
            surface: AppColors.surface,
          ),

          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          // ✅ Cursor + selection colors
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.accent,
            selectionColor: AppColors.accentLight,
            selectionHandleColor: AppColors.accent,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: RootPage()
      ),
    );
  }


}



