class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image; // Add the image attribute


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'] ?? 'Unknown', // Default value if null
      description: json['description'] ?? 'No Description', // Default value if null
      price: (json['price'] ?? 0.0).toDouble(), // Default value if null
      image: json['image'] ?? '', // Add image field with default value

    );
  }
}

