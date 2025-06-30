// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() async {
  debugPrint('→ Iniciando main()');
  WidgetsFlutterBinding.ensureInitialized();
  // DEBUG: ver directorio de trabajo actual y existencia de .env
  runApp(const MyApp());
  debugPrint('→ runApp ha sido llamado');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peluqueria Anita',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
