class Participant {
  final String id;
  final String phone;
  final String nickname;

  Participant({required this.id, required this.phone, required this.nickname});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] as String,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String,
    );
  }
}
