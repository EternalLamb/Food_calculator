import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Precio: \$${product.price.toStringAsFixed(0)} CLP',
              style: TextStyle(fontSize: 20, color: Colors.teal.shade800),
            ),
            const SizedBox(height: 15),
            Text(
              'Categoría: ${product.category}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            Text(
              'Rendimiento: ${product.yieldDescription}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
