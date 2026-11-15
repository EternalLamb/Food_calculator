class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imagePath;
  final String yieldDescription;
  int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.yieldDescription,
    this.quantity = 0,
  });

  // Convertir un ProductModel a Map para guardarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imagePath': imagePath,
      'yieldDescription': yieldDescription,
      'quantity': quantity,
    };
  }

  // Crear un ProductModel desde un Map obtenido de SQLite
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      imagePath: map['imagePath'] as String? ?? '',
      yieldDescription: map['yieldDescription'] as String,
      quantity: map['quantity'] as int? ?? 0,
    );
  }
}
