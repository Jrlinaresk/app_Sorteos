import 'package:sorteos_app/models/product.dart';

import 'participant.dart';

class Raffle {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String category; // para el filtro
  final String size;
  final String costLevel;
  final String status;
  final int maxParticipants;
  final List<Participant> participants;
  final List<Participant> winners;
  final DateTime? drawDate;
  final double itemPrice;
  final double ticketPrice;
  final String itemCondition;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Product> products;

  Raffle({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.category,
    required this.size,
    required this.costLevel,
    required this.status,
    required this.maxParticipants,
    required this.participants,
    required this.winners,
    this.drawDate,
    required this.itemPrice,
    required this.ticketPrice,
    required this.itemCondition,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
  });

  factory Raffle.fromJson(Map<String, dynamic> json) {
    // Helper to parse num → double
    double toDouble(dynamic n) {
      if (n is int) return n.toDouble();
      if (n is double) return n;
      return double.parse(n.toString());
    }

    return Raffle(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      size: json['size'] as String,
      costLevel: json['costLevel'] as String,
      status: json['status'] as String,
      maxParticipants: json['maxParticipants'] as int,
      participants:
          (json['participants'] as List<dynamic>)
              .map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList(),
      winners:
          (json['winners'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      drawDate:
          json['drawDate'] != null
              ? DateTime.parse(json['drawDate'] as String)
              : null,
      itemPrice: toDouble(json['itemPrice']),
      ticketPrice: toDouble(json['ticketPrice']),
      itemCondition: json['itemCondition'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      products:
          (json['products'] as List<dynamic>?)
              ?.map((p) => Product.fromJson(p as Map<String, dynamic>))
              .toList() ??
          <Product>[],
    );
  }
}
