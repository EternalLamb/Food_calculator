class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imagePath; // Ruta local en assets/images/
  final String yieldDescription;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.yieldDescription,
  });
}

final List<ProductModel> mockProducts = [
  // --- ABARROTES ---
  ProductModel(
    id: '1',
    name: 'Arroz Grado 1 (1 kg)',
    price: 1350,
    category: 'Abarrotes',
    imagePath: 'assets/images/arroz.jpg',
    yieldDescription: 'Rinde aproximadamente 10 a 12 porciones de almuerzo.',
  ),
  ProductModel(
    id: '2',
    name: 'Fideos Tallarines (500 g)',
    price: 990,
    category: 'Abarrotes',
    imagePath: 'assets/images/fideos.png',
    yieldDescription: 'Rinde 4 a 5 porciones abundantes para la semana.',
  ),
  ProductModel(
    id: '3',
    name: 'Lentejas (1 kg)',
    price: 1890,
    category: 'Abarrotes',
    imagePath: 'assets/images/lentejas.png',
    yieldDescription: 'Legumbre nutritiva que rinde 8 a 10 porciones.',
  ),
  ProductModel(
    id: '4',
    name: 'Avena Soplada (500 g)',
    price: 1400,
    category: 'Abarrotes',
    imagePath: 'assets/images/avena.png',
    yieldDescription: 'Desayuno rápido y saciante para 2 semanas.',
  ),
  ProductModel(
    id: '5',
    name: 'Aceite Vegetal (1 Litro)',
    price: 2200,
    category: 'Abarrotes',
    imagePath: 'assets/images/aceite.png',
    yieldDescription: 'Insumo básico de cocina que dura más de un mes.',
  ),
  ProductModel(
    id: '6',
    name: 'Sal de Mesa (1 kg)',
    price: 550,
    category: 'Abarrotes',
    imagePath: 'assets/images/sal.png',
    yieldDescription: 'Sazonador básico con duración para varios meses.',
  ),
  ProductModel(
    id: '7',
    name: 'Salsa de Tomate (200 g)',
    price: 650,
    category: 'Abarrotes',
    imagePath: 'assets/images/salsa_tomate.png',
    yieldDescription: 'Acompañamiento básico para 2 a 3 comidas con pastas.',
  ),

  // --- PROTEÍNAS & CARNES ---
  ProductModel(
    id: '8',
    name: 'Bandeja Huevos (12 un)',
    price: 3400,
    category: 'Proteínas',
    imagePath: 'assets/images/huevos.png',
    yieldDescription: 'Excelente fuente de proteína para desayunos y cenas.',
  ),
  ProductModel(
    id: '9',
    name: 'Pechuga de Pollo (1 kg)',
    price: 4990,
    category: 'Proteínas',
    imagePath: 'assets/images/pollo.png',
    yieldDescription:
        'Proteína magra congelable para 5 a 6 platos principales.',
  ),
  ProductModel(
    id: '10',
    name: 'Carne Molida 10% (500 g)',
    price: 3890,
    category: 'Proteínas',
    imagePath: 'assets/images/carne_molida.png',
    yieldDescription: 'Versátil para salsas boloñesa, hamburguesas o pino.',
  ),
  ProductModel(
    id: '11',
    name: 'Atún en Agua (160 g)',
    price: 1200,
    category: 'Proteínas',
    imagePath: 'assets/images/atun.png',
    yieldDescription: 'Proteína rápida sin necesidad de cocción.',
  ),
  ProductModel(
    id: '12',
    name: 'Vienesas Tradicionales (5 un)',
    price: 1100,
    category: 'Proteínas',
    imagePath: 'assets/images/vienesas.png',
    yieldDescription: 'Comida rápida de preparar para días ajustados.',
  ),

  // --- LÁCTEOS ---
  ProductModel(
    id: '13',
    name: 'Leche Entera (1 Litro)',
    price: 1050,
    category: 'Lácteos',
    imagePath: 'assets/images/leche.png',
    yieldDescription: 'Rinde alrededor de 4 vasos para cafés, batidos o avena.',
  ),
  ProductModel(
    id: '14',
    name: 'Yogurt Batido (120 g)',
    price: 380,
    category: 'Lácteos',
    imagePath: 'assets/images/yogurt.png',
    yieldDescription: 'Colación ligera o postre para la jornada universitaria.',
  ),
  ProductModel(
    id: '15',
    name: 'Queso Laminado (250 g)',
    price: 2490,
    category: 'Lácteos',
    imagePath: 'assets/images/queso.png',
    yieldDescription: 'Rinde aproximadamente 10 a 12 láminas para sándwiches.',
  ),

  // --- FRUTAS Y VERDURAS ---
  ProductModel(
    id: '16',
    name: 'Malla de Papas (2 kg)',
    price: 2500,
    category: 'Verduras',
    imagePath: 'assets/images/papas.png',
    yieldDescription:
        'Carbohidrato base para acompañamientos de 2 a 3 semanas.',
  ),
  ProductModel(
    id: '17',
    name: 'Kilo de Plátanos (1 kg)',
    price: 1390,
    category: 'Frutas',
    imagePath: 'assets/images/platanos.png',
    yieldDescription:
        'Snack saludable para colaciones entre clases (5-6 unidades).',
  ),
  ProductModel(
    id: '18',
    name: 'Kilo de Manzanas (1 kg)',
    price: 1290,
    category: 'Frutas',
    imagePath: 'assets/images/manzanas.png',
    yieldDescription:
        'Fruta fresca de larga duración (approx. 5 a 6 manzanas).',
  ),
  ProductModel(
    id: '19',
    name: 'Bolsa de Cebollas (1 kg)',
    price: 1200,
    category: 'Verduras',
    imagePath: 'assets/images/cebollas.png',
    yieldDescription:
        'Base esencial para aderezos de sofritos en múltiples recetas.',
  ),
  ProductModel(
    id: '20',
    name: 'Kilo de Tomates (1 kg)',
    price: 1690,
    category: 'Verduras',
    imagePath: 'assets/images/tomates.png',
    yieldDescription: 'Ideal para ensaladas diarias durante la semana.',
  ),

  // --- PANADERÍA & HOGAR ---
  ProductModel(
    id: '21',
    name: 'Pan Hallulla / Marraqueta (1 kg)',
    price: 2100,
    category: 'Panadería',
    imagePath: 'assets/images/pan_fresco.png',
    yieldDescription:
        'Rinde aproximadamente 10 a 12 panes para desayunos y onces.',
  ),
  ProductModel(
    id: '22',
    name: 'Pan de Molde Familiar',
    price: 2390,
    category: 'Panadería',
    imagePath: 'assets/images/pan_molde.png',
    yieldDescription: 'Ideal para preparar sándwiches rápidos para llevar.',
  ),
  ProductModel(
    id: '23',
    name: 'Té Cajas (100 bolsitas)',
    price: 2990,
    category: 'Abarrotes',
    imagePath: 'assets/images/te.png',
    yieldDescription: 'Bebestible caliente que rinde para más de un mes.',
  ),
  ProductModel(
    id: '24',
    name: 'Detergente Líquido (1 Litro)',
    price: 2990,
    category: 'Limpieza',
    imagePath: 'assets/images/detergente.png',
    yieldDescription: 'Rinde aproximadamente para 10 a 12 lavados de ropa.',
  ),
  ProductModel(
    id: '25',
    name: 'Lavatristes / Lavaloza (750 ml)',
    price: 1490,
    category: 'Limpieza',
    imagePath: 'assets/images/lavaloza.png',
    yieldDescription: 'Limpiador concentrado para la loza de varias semanas.',
  ),
];
