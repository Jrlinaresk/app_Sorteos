import 'dart:convert';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:http/http.dart' as http;
import 'package:sorteos_app/models/transferencia/create_transaction.dto.dart';
import 'package:sorteos_app/models/transferencia/transaction.dart';
import 'package:sorteos_app/models/user.dart';
import '../models/category.dart';
import '../models/raffle.dart';

const _prodApiBaseUrl = 'https://sorteoscuba.everom.net/api/v1';
const _devApiBaseUrl = 'http://192.168.1.19:8080/api/v1';

/// Permite sobreescribir la API en tiempo de ejecución de Flutter:
/// flutter run --dart-define=API_BASE_URL=http://ip-local:8080/api/v1
const baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: kReleaseMode ? _prodApiBaseUrl : _devApiBaseUrl,
);

class ApiService {
  Future<User> createUser(String phone, String nickname) async {
    final uri = Uri.parse('$baseUrl/users');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone': phone, 'nickname': nickname}),
    );
    if (resp.statusCode == 201) {
      return User.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    // si ya existe el usuario, tu controlador podría devolver 200; manejar ambos:
    if (resp.statusCode == 200) {
      return User.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje = map['message'] as String;

    throw Exception(soloMensaje);
  }

  Future<List<Category>> fetchCategories() async {
    final resp = await http.get(Uri.parse('$baseUrl/categories'));
    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body) as List;
      return data
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje = map['message'] as String;

    throw Exception(soloMensaje);
  }

  Future<List<Raffle>> fetchRaffles({String? categoryId}) async {
    final uri =
        categoryId != null
            ? Uri.parse('$baseUrl/raffles?category=$categoryId')
            : Uri.parse('$baseUrl/raffles');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body) as List;
      return data
          .map((e) => Raffle.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje = map['message'] as String;

    throw Exception(soloMensaje);
  }

  Future<Raffle> fetchRaffle(String id) async {
    final resp = await http.get(Uri.parse('$baseUrl/raffles/$id'));
    if (resp.statusCode == 200) {
      return Raffle.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to load raffle');
  }

  Future<void> participate(String raffleId, String userId) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/users/$userId/participations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'raffleId': raffleId}),
    );
    if (resp.statusCode != 201) {
      final Map<String, dynamic> map = json.decode(resp.body);
      final String soloMensaje = map['message'] as String;

      throw Exception(soloMensaje);
    }
  }

  Future<User> fetchUser(String id) async {
    final resp = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (resp.statusCode == 200) {
      return User.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje = map['message'] as String;

    throw Exception(soloMensaje);
  }

  Future<List<TransactionModel>> fetchUserTransactions(String userId) async {
    final uri = Uri.parse('$baseUrl/transactions/user/$userId');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List data = json.decode(resp.body) as List;
      return data.map((e) => TransactionModel.fromJson(e)).toList();
    }
    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje = map['message'] as String;

    throw Exception(soloMensaje);
  }

  Future<TransactionModel> createTransaction(CreateTransactionDto dto) async {
    final uri = Uri.parse('$baseUrl/transactions');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );
    if (resp.statusCode == 201) {
      return TransactionModel.fromJson(json.decode(resp.body));
    }
    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje = map['message'].split(':')[1];
    throw Exception(soloMensaje);
  }

  Future<User> login(String phone, String nickname) async {
    final uri = Uri.parse('$baseUrl/users/login');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone': phone.trim(), 'nickname': nickname.trim()}),
    );

    if (resp.statusCode == 201) {
      return User.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }

    final Map<String, dynamic> map = json.decode(resp.body);
    final String soloMensaje =
        map['message'] as String? ??
        'Error al hacer login (status ${resp.statusCode})';
    throw Exception(soloMensaje);
  }
}
