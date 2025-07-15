// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    category: json['category'] as String,
    images: (json['images'] as List<dynamic>).cast<String>(),
  );
}
