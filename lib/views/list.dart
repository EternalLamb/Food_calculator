import 'package:flutter/material.dart';

import '../models/product.dart';
import '../views/details.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  final double sueldo; // Aquí se guarda el sueldo que viene de Home

  const ProductListView({
    super.key,
    required this.products,
    required this.sueldo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Alimentos')),
      body: Column(
        children: [
          // Banner simple que muestra el sueldo guardado
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade100,
            width: double.infinity,
            child: Text(
              'Sueldo ingresado: \$${sueldo.toStringAsFixed(0)} CLP',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Lista con los alimentos y sus precios
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'Precio: \$${product.price.toStringAsFixed(0)} CLP',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailView(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
