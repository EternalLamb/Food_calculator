class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final String yieldDescription;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.yieldDescription,
  });
}

final List<ProductModel> mockProducts = [
  ProductModel(
    id: '1',
    name: 'Arroz Grado 1 (1 kg)',
    price: 1350,
    category: 'Abarrotes',
    imageUrl: '',
    yieldDescription: 'Rinde aproximadamente 10 a 12 porciones.',
  ),
  ProductModel(
    id: '2',
    name: 'Bandeja Huevos (12 un)',
    price: 3400,
    category: 'Proteínas',
    imageUrl: '',
    yieldDescription: 'Ideal para desayunos y cenas.',
  ),
  ProductModel(
    id: '3',
    name: 'Fideos Tallarines (500 g)',
    price: 990,
    category: 'Abarrotes',
    imageUrl: '',
    yieldDescription: 'Rinde 4 a 5 porciones.',
  ),
];
