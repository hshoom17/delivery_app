class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool available;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.available = true,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // Handle price conversion - Laravel returns decimal as string or number
    double parsePrice(dynamic priceValue) {
      if (priceValue == null) return 0.0;
      if (priceValue is double) return priceValue;
      if (priceValue is int) return priceValue.toDouble();
      if (priceValue is String) {
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    }

    // Handle available boolean
    bool parseAvailable(dynamic availableValue) {
      if (availableValue == null) return true;
      if (availableValue is bool) return availableValue;
      if (availableValue is int) return availableValue != 0;
      if (availableValue is String) {
        return availableValue.toLowerCase() == 'true' || availableValue == '1';
      }
      return true;
    }

    return MenuItem(
      id: (json['id'] ?? json['food_id'] ?? 0) as int,
      name: (json['name'] ?? json['food_name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: parsePrice(json['price']),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      available: parseAvailable(json['available']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'available': available,
    };
  }

  MenuItem copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? available,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      available: available ?? this.available,
    );
  }
}
