import 'package:flutter/material.dart';

import '../models/product.dart';
import 'details.dart';

class ProductListView extends StatefulWidget {
  final List<ProductModel> products;
  final double sueldo;

  const ProductListView({
    super.key,
    required this.products,
    required this.sueldo,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  double get totalGastado {
    return widget.products.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get saldoRestante {
    return widget.sueldo - totalGastado;
  }

  void _addToCart(ProductModel product) {
    if (saldoRestante < product.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Saldo insuficiente para añadir este producto!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      product.quantity++;
    });
  }

  void _removeFromCart(ProductModel product) {
    if (product.quantity > 0) {
      setState(() {
        product.quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Canasta de Alimentos')),
      body: Column(
        children: [
          // Banner Resumen de Presupuesto
          Container(
            padding: const EdgeInsets.all(16),
            color: saldoRestante < 0
                ? Colors.red.shade100
                : Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Sueldo', style: TextStyle(fontSize: 12)),
                    Text(
                      '\$${widget.sueldo.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Total Canasta', style: TextStyle(fontSize: 12)),
                    Text(
                      '\$${totalGastado.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Restante', style: TextStyle(fontSize: 12)),
                    Text(
                      '\$${saldoRestante.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: saldoRestante < 0
                            ? Colors.red
                            : Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de alimentos editable
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                final bool enCarrito = product.quantity > 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  color: enCarrito ? Colors.green.shade50 : null,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: enCarrito ? Colors.green[900] : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${product.category} • \$${product.price.toStringAsFixed(0)} CLP',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (enCarrito) ...[
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _removeFromCart(product),
                          ),
                          Text(
                            '${product.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.green,
                          ),
                          onPressed: () => _addToCart(product),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailView(product: product),
                        ),
                      );
                      setState(() {});
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
