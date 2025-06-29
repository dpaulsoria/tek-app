import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Text('Bienvenido, tu token es:\n$token',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
