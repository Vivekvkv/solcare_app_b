class Service {
  final int id;
  final String name;
  final String category;
  final double price;
  final int discount;
  final double rating;
  final int popularity; // 1-5 scale, 5 being most popular

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.discount = 0,
    required this.rating,
    required this.popularity,
  });
}
