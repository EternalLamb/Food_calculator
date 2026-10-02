import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _mostrarModalAgregarProducto() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String categoriaSeleccionada = 'Abarrotes';
    XFile? imagenTomada;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                    const Text(
                      'Añadir Nuevo Producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: Text(
                        imagenTomada == null
                            ? 'Escanear / Tomar Foto'
                            : '¡Foto Capturada!',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: imagenTomada == null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          final XFile? photo = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (photo != null) {
                            setModalState(() {
                              imagenTomada = photo;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se pudo abrir la cámara.'),
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
                      value: categoriaSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          [
                            'Abarrotes',
                            'Proteínas',
                            'Lácteos',
                            'Frutas',
                            'Verduras',
                            'Panadería',
                            'Limpieza',
                          ].map((String cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            );
                          }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            categoriaSeleccionada = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        final String nombre = nameController.text.trim();
                        final double? precio = double.tryParse(
                          priceController.text,
                        );

                        if (nombre.isEmpty || precio == null || precio <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, ingresa datos válidos.',
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        // Se crea el producto escanado o ingresado a mano
                        final nuevoProducto = ProductModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nombre,
                          price: precio,
                          category: categoriaSeleccionada,
                          imagePath:
                              imagenTomada?.path ?? 'assets/images/arroz.png',
                          yieldDescription:
                              'Producto añadido manualmente por el usuario.',
                        );

                        setState(() {
                          widget.products.insert(0, nuevoProducto);
                        });

                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡${nuevoProducto.name} guardado en el catálogo!',
                            ),
                            backgroundColor: Colors.green[800],
                          ),
                        );
                      },
                      child: const Text('Guardar Producto'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Canasta de Alimentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined),
            tooltip: 'Añadir Producto con Cámara',
            onPressed: _mostrarModalAgregarProducto,
          ),
        ],
      ),
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
                final bool esRutaLocal =
                    product.imagePath.startsWith('/') ||
                    product.imagePath.startsWith('file:');

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  color: enCarrito ? Colors.green.shade50 : null,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: esRutaLocal
                          ? Image.file(
                              File(product.imagePath),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.fastfood,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          : Image.asset(
                              product.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.fastfood,
                                      color: Colors.grey,
                                    ),
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
