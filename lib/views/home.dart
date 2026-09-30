import 'package:flutter/material.dart';

import '../models/product.dart';
import '../views/list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _sueldoController = TextEditingController();

  void _generarCanasta({required bool autoRecomendar}) {
    final double? sueldo = double.tryParse(_sueldoController.text);

    if (sueldo == null || sueldo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un monto de sueldo válido.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    List<ProductModel> productList = mockProducts
        .map((p) => p.copyWith(quantity: 0))
        .toList();

    if (autoRecomendar) {
      _aplicarAlgoritmoCanastaInteligente(productList, sueldo);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductListView(products: productList, sueldo: sueldo),
      ),
    );
  }

  // Distribuir por categoría
  void _aplicarAlgoritmoCanastaInteligente(
    List<ProductModel> products,
    double sueldo,
  ) {
    // Le damos un porcentaje del sueldo a cada categoría basado en la importancia
    final Map<String, double> cuotasCategoria = {
      'Abarrotes': sueldo * 0.30,
      'Proteínas': sueldo * 0.25,
      'Lácteos': sueldo * 0.10,
      'Verduras': sueldo * 0.10,
      'Frutas': sueldo * 0.10,
      'Panadería': sueldo * 0.08,
      'Limpieza': sueldo * 0.07,
    };

    for (var entry in cuotasCategoria.entries) {
      String categoria = entry.key;
      double presupuestoCategoria = entry.value;

      //Se filtran los productos de la categoría ordenados por precio ascendente
      var productosCategoria =
          products.where((p) => p.category == categoria).toList()
            ..sort((a, b) => a.price.compareTo(b.price));

      double gastoEnCategoria = 0.0;

      for (var product in productosCategoria) {
        if (gastoEnCategoria + product.price <= presupuestoCategoria) {
          product.quantity = 1; // Asignamos 1 unidad recomendada
          gastoEnCategoria += product.price;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Calculator'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.calculate_outlined, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Gestor de Alimentación Estudiantil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa tu presupuesto para generar una canasta basica:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _sueldoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Presupuesto o Sueldo (CLP)',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                suffixText: 'CLP',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generar Canasta Automaticamente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _generarCanasta(autoRecomendar: true),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text('Armar Canasta Desde Cero'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _generarCanasta(autoRecomendar: false),
            ),
          ],
        ),
      ),
    );
  }
}
