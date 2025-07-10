class Category {
  final String id;
  final String name;
  final String? description;

  Category({required this.id, required this.name, this.description});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
  );
}
