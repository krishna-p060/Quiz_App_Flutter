// lib/main.dart
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/start_quiz_screen.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/services/quiz_service.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AuthService(),
//       child: QuizApp(),
//     ),
//   );
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, QuizService>(
          create: (context) => QuizService(context.read<AuthService>()),
          update: (context, authService, previous) => QuizService(authService),
        ),
      ],
      child: QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.isAuthenticated) {
            return StartQuizScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}