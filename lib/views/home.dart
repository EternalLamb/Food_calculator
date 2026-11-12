import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/product.dart';
import 'list.dart';
import 'encuesta.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _sueldoController = TextEditingController();

  @override
  void dispose() {
    _sueldoController.dispose();
    super.dispose();
  }

  void _aplicarAlgoritmoCanastaInteligente(
    List<ProductModel> products,
    double sueldo,
  ) {
    if (products.isEmpty) return;

    final Map<String, double> cuotasCategoria = {
      'Abarrotes': sueldo * 0.30,
      'Proteínas': sueldo * 0.25,
      'Lácteos': sueldo * 0.10,
      'Verduras': sueldo * 0.10,
      'Frutas': sueldo * 0.10,
      'Panadería': sueldo * 0.08,
      'Limpieza': sueldo * 0.07,
    };

    double gastoTotal = 0.0;

    for (var entry in cuotasCategoria.entries) {
      String categoria = entry.key;
      double presupuestoCategoria = entry.value;

      var productosCategoria =
          products.where((p) => p.category == categoria).toList()
            ..sort((a, b) => a.price.compareTo(b.price));

      if (productosCategoria.isEmpty) continue;

      double gastoEnCategoria = 0.0;
      bool pudoComprar = true;

      while (pudoComprar) {
        pudoComprar = false;
        for (var product in productosCategoria) {
          if (gastoEnCategoria + product.price <= presupuestoCategoria &&
              gastoTotal + product.price <= sueldo) {
            product.quantity++;
            gastoEnCategoria += product.price;
            gastoTotal += product.price;
            pudoComprar = true;
          }
        }
      }
    }

    var todosOrdenados = List<ProductModel>.from(products)
      ..sort((a, b) => a.price.compareTo(b.price));

    bool sigueAlcanzando = true;
    while (sigueAlcanzando) {
      sigueAlcanzando = false;
      for (var product in todosOrdenados) {
        if (gastoTotal + product.price <= sueldo) {
          product.quantity++;
          gastoTotal += product.price;
          sigueAlcanzando = true;
        }
      }
    }
  }

  Future<void> _generarCanasta({required bool autoRecomendar}) async {
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
    final data = await DatabaseHelper.instance.obtenerProductos();
    List<ProductModel> productList = data
        .map((map) => ProductModel.fromMap(map))
        .toList();

    for (var p in productList) {
      p.quantity = 0;
      await DatabaseHelper.instance.insertarProducto(p);
    }

    if (autoRecomendar) {
      _aplicarAlgoritmoCanastaInteligente(productList, sueldo);

      for (var p in productList) {
        if (p.quantity > 0) {
          await DatabaseHelper.instance.insertarProducto(p);
        }
      }
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListView(sueldo: sueldo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Presupuesto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.calculate_outlined,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Calculadora de Canasta Básica',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingresa tu sueldo o presupuesto disponible para planificar tus compras esenciales.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _sueldoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Sueldo / Presupuesto (CLP)',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generar Canasta Automáticamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                TextButton.icon(
                  icon: const Icon(Icons.rate_review, color: Colors.blueGrey),
                  label: const Text(
                    'Evaluar Aplicación (Beta Testing)',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EvaluacionQAView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
