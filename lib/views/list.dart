import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../viewmodels/basket_viewmodel.dart';
import 'details.dart';
import 'widgets/product_form_sheet.dart';
import 'widgets/product_image.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  Future<void> _agregar(BuildContext context, ProductModel p) async {
    final ok = await context.read<BasketViewModel>().addToCart(p);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Saldo insuficiente para añadir este producto!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _eliminar(BuildContext context, ProductModel p) async {
    await context.read<BasketViewModel>().deleteProduct(p.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡${p.name} eliminado de la lista!'),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BasketViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Canasta de Alimentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined),
            tooltip: 'Añadir Producto con Cámara',
            onPressed: () => showProductFormSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _ResumenPresupuesto(
            sueldo: vm.sueldo,
            total: vm.totalGastado,
            restante: vm.saldoRestante,
          ),
          Expanded(child: _buildBody(context, vm)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, BasketViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null) {
      return Center(child: Text(vm.errorMessage!));
    }
    if (vm.products.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos guardados.\nAgrega uno nuevo con el ícono superior.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: vm.products.length,
      itemBuilder: (context, index) {
        final product = vm.products[index];
        final enCarrito = product.quantity > 0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: enCarrito ? Colors.green.shade50 : null,
          child: ListTile(
            leading: ProductImage(path: product.imagePath),
            title: Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: enCarrito ? Colors.green[900] : Colors.black,
              ),
            ),
            subtitle: Text(
              '${product.category}\n\$${product.price.toStringAsFixed(0)} CLP',
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
                    onPressed: () => vm.removeFromCart(product),
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
                  onPressed: () => _agregar(context, product),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') {
                      showProductFormSheet(context, product: product);
                    } else {
                      _eliminar(context, product);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar')),
                    PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                  ],
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailView(productId: product.id),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ResumenPresupuesto extends StatelessWidget {
  final double sueldo;
  final double total;
  final double restante;

  const _ResumenPresupuesto({
    required this.sueldo,
    required this.total,
    required this.restante,
  });

  Widget _col(String label, double value, {Color? color}) => Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 12)),
      Text(
        '\$${value.toStringAsFixed(0)}',
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: restante < 0
          ? Colors.red.shade100
          : Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _col('Sueldo', sueldo),
          _col('Total Canasta', total, color: Colors.orange),
          _col(
            'Restante',
            restante,
            color: restante < 0 ? Colors.red : Colors.green[800],
          ),
        ],
      ),
    );
  }
}
