// lib/models/user.dart

class User {
  final String id;
  final String phone;
  final String nickname;
  final double balance;

  User({
    required this.id,
    required this.phone,
    required this.nickname,
    required this.balance,
  });

  /// Este factory es el que debe existir para parsear JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String,
      balance: json['balance'] as double,
    );
  }
}
