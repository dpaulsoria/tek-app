// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  late final String _baseUrl;
  AuthService() {
    _baseUrl = dotenv.env['API_BASE_URL']?.trim() ??
        (throw Exception('Falta API_BASE_URL en .env'));
  }
  Future<User> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }
    final Map<String, dynamic> data = jsonDecode(resp.body);
    return User.fromJson(data);
  }
}
