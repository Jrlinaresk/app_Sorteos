// lib/models/user.dart

class User {
  final String id;
  final String phone;
  final String nickname;
  final double balance;
  final String? address;
  final String? email;
  final bool emailVerified;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? secondLastName;
  final String profilePictureUrl;

  User({
    required this.id,
    required this.phone,
    required this.nickname,
    required this.balance,
    this.address,
    this.email,
    required this.emailVerified,
    this.firstName,
    this.middleName,
    this.lastName,
    this.secondLastName,
    required this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String,
      balance: (json['balance'] as num).toDouble(),
      address: json['address'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      secondLastName: json['secondLastName'] as String?,
      profilePictureUrl:
          json['profilePictureUrl'] as String? ??
          'https://i.imgur.com/vMppUMs.png',
    );
  }
}
