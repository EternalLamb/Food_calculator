import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../viewmodels/basket_viewmodel.dart';
import 'widgets/product_image.dart';

class ProductDetailView extends StatelessWidget {
  final String productId;

  const ProductDetailView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = context.select<BasketViewModel, ProductModel?>(
      (vm) => vm.byId(productId),
    );

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Producto')),
        body: const Center(child: Text('El producto ya no existe.')),
      );
    }

    final vm = context.read<BasketViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ProductImage(path: product.imagePath, size: 140)),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Precio: \$${product.price.toStringAsFixed(0)} CLP',
              style: TextStyle(fontSize: 20, color: Colors.green.shade800),
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
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => vm.removeFromCart(product),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${product.quantity}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    final ok = await vm.addToCart(product);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Saldo insuficiente!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
