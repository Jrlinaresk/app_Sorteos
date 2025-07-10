import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorteos_app/models/user.dart';
import '../models/category.dart';
import '../models/raffle.dart';

const baseUrl = 'https://lgp6ch24-8080.use2.devtunnels.ms/api/v1';

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
    throw Exception('Failed to load categories');
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
    throw Exception('Failed to load raffles');
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
      throw Exception('Failed to participate');
    }
  }

  Future<User> fetchUser(String id) async {
    final resp = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (resp.statusCode == 200) {
      return User.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to load user');
  }
}
