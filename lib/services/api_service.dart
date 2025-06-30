// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/cita.dart';

class ApiService {
  // static const String _baseUrl = 'https://tek-gr32.onrender.com/api';
  static const String _baseUrl = 'http://10.51.12.153:10000/api';

  Future<User> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    debugPrint('→ login() = ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }

    return User.fromJson(jsonDecode(resp.body));
  }


  Future<List<User>> getClients(String token) async {
    final uri = Uri.parse('$_baseUrl/clientes');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint('→ getClients() = ${resp.body}');
    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }

    final List<dynamic> data = jsonDecode(resp.body);
    return data.map((e) => User.fromClientJson(e)).toList();
  }

  Future<void> logout(String token) async {
    final uri = Uri.parse('$_baseUrl/logout');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint('→ logout() = ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }
  }

  Future<Cita> createAppointment({
    required String token,
    required DateTime date,
    required String timeArrival,
    required int clienteId,
    int? amountAttention,
    double? totalService,
    required String status,
  }) async {
    final uri = Uri.parse('$_baseUrl/citas');
    final body = {
      'date': date.toIso8601String().split('T').first,
      'time_arrival': timeArrival,
      'cliente_id': clienteId,
      'amount_attention': amountAttention,
      'total_service': totalService,
      'status': status,
    }..removeWhere((_, v) => v == null);

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    debugPrint('→ createAppointment() = ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }

    return Cita.fromJson(jsonDecode(resp.body));
  }
}
