import 'package:flutter/material.dart';

import '../models/product.dart';
import '../views/details.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  final double sueldo;

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
          // Banner de sueldo ingresado
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            width: double.infinity,
            child: Text(
              'Sueldo disponible: \$${sueldo.toStringAsFixed(0)} CLP',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Listado de productos con imagen local
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product.imagePath,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        // Muestra un ícono por defecto si la imagen no existe aún en la carpeta assets/images/
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 55,
                          height: 55,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product.category}\n\$${product.price.toStringAsFixed(0)} CLP',
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
