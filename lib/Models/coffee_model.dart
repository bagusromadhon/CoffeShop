class Coffee {
  final int id;
  final String name;
  final int price;

  Coffee({required this.id, required this.name, required this.price});

  factory Coffee.fromJson(Map<String, dynamic> j) => Coffee(
        id: j['id'] ?? 0,
        name: j['name'] ?? 'Unknown',
        price: j['price'] ?? 0,
      );
}
