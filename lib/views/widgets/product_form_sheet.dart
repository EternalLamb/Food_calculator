import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../viewmodels/basket_viewmodel.dart';

/// Si [product] es null, agrega; si no, edita.
Future<void> showProductFormSheet(
  BuildContext context, {
  ProductModel? product,
}) {
  final vm = context.read<BasketViewModel>();
  final messenger = ScaffoldMessenger.of(context);
  final editando = product != null;

  final nameController = TextEditingController(text: product?.name ?? '');
  final priceController = TextEditingController(
    text: product?.price.toStringAsFixed(0) ?? '',
  );
  String categoria = product?.category ?? BasketViewModel.categorias.first;
  String? nuevaFoto; // estado puramente visual del modal

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    editando ? 'Editar Producto' : 'Añadir Nuevo Producto',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: Text(
                      nuevaFoto == null
                          ? (editando
                                ? 'Cambiar Foto (Opcional)'
                                : 'Escanear / Tomar Foto')
                          : '¡Foto Capturada!',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: nuevaFoto == null
                          ? Theme.of(ctx).colorScheme.primary
                          : Colors.green[700],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        final path = await vm.takePhoto();
                        if (path != null) {
                          setModalState(() => nuevaFoto = path);
                        }
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Producto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio (CLP)',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: categoria,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    items: BasketViewModel.categorias
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) categoria = val;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: editando
                          ? Colors.blue[700]
                          : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final error = vm.validarProducto(
                        nameController.text,
                        priceController.text,
                      );
                      if (error != null) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      final nombre = nameController.text.trim();
                      final precio = double.parse(priceController.text);

                      if (editando) {
                        await vm.updateProduct(
                          product,
                          name: nombre,
                          price: precio,
                          category: categoria,
                          imagePath: nuevaFoto,
                        );
                      } else {
                        await vm.addProduct(
                          name: nombre,
                          price: precio,
                          category: categoria,
                          imagePath: nuevaFoto,
                        );
                      }

                      if (ctx.mounted) Navigator.pop(ctx);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            editando
                                ? '¡$nombre actualizado con éxito!'
                                : '¡$nombre guardado en la lista!',
                          ),
                          backgroundColor: Colors.green[800],
                        ),
                      );
                    },
                    child: Text(
                      editando ? 'Guardar Cambios' : 'Guardar Producto',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
