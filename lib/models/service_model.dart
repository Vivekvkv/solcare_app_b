class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final double price;
  final String image;
  final String category;
  final String duration;
  final double popularity;
  final int discount; // Added discount property

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.image,
    required this.category,
    required this.duration,
    required this.popularity,
    this.discount = 0, // Default to 0 if not provided
  });
  
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    double? price,
    String? image,
    String? category,
    String? duration,
    double? popularity,
    int? discount,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      popularity: popularity ?? this.popularity,
      discount: discount ?? this.discount,
    );
  }

  // Add this factory method to parse JSON from API
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String? ?? 'Professional service',
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
      duration: json['duration'] as String? ?? '1 hour',
      popularity: (json['popularity'] as num).toDouble(),
      discount: (json['discount'] as num? ?? 0).toInt(), // Changed from toDouble() to toInt()
    );
  }
}
