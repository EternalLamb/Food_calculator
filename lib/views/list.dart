import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';
import '../data/database_helper.dart';
import 'details.dart';

class ProductListView extends StatefulWidget {
  final double sueldo;

  const ProductListView({super.key, required this.sueldo});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ImagePicker _picker = ImagePicker();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  // Método para obtener los productos desde SQLite
  Future<void> _cargarProductos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await DatabaseHelper.instance.obtenerProductos();
      setState(() {
        _products = data.map((map) => ProductModel.fromMap(map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get totalGastado {
    return _products.fold(
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

  // Método para eliminar un producto de la base de datos
  Future<void> _eliminarProducto(String id, String nombre) async {
    await DatabaseHelper.instance.eliminarProducto(id);
    await _cargarProductos(); // Recarga la lista desde SQLite

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡$nombre eliminado de la lista!'),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  // NUEVO: Método para mostrar el modal de edición de un producto existente
  Future<void> _mostrarModalEditarProducto(ProductModel producto) async {
    final nameController = TextEditingController(text: producto.name);
    final priceController = TextEditingController(
      text: producto.price.toStringAsFixed(0),
    );
    String categoriaSeleccionada = producto.category;
    XFile? imagenActualizada;

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
                      'Editar Producto',
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
                        imagenActualizada == null
                            ? 'Cambiar Foto (Opcional)'
                            : '¡Nueva Foto Seleccionada!',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: imagenActualizada == null
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
                              imagenActualizada = photo;
                            });
                          }
                        } catch (e) {
                          if (!context.mounted) return;
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
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
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

                        // Construir el objeto actualizado manteniendo su ID original
                        final productoActualizado = ProductModel(
                          id: producto.id,
                          name: nombre,
                          price: precio,
                          category: categoriaSeleccionada,
                          imagePath:
                              imagenActualizada?.path ?? producto.imagePath,
                          yieldDescription: producto.yieldDescription,
                          quantity: producto.quantity,
                        );

                        // Actualizar en la base de datos (requiere tener el método actualizarProducto en tu DatabaseHelper)
                        await DatabaseHelper.instance.actualizarProducto(
                          productoActualizado,
                        );

                        // Recargar la lista
                        await _cargarProductos();

                        if (!context.mounted) return;
                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡${productoActualizado.name} actualizado con éxito!',
                            ),
                            backgroundColor: Colors.blue[800],
                          ),
                        );
                      },
                      child: const Text('Guardar Cambios'),
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
                          if (!context.mounted) return;

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
                      initialValue: categoriaSeleccionada,
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
                      onPressed: () async {
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

                        final nuevoProducto = ProductModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nombre,
                          price: precio,
                          category: categoriaSeleccionada,
                          imagePath: imagenTomada?.path ?? '',
                          yieldDescription:
                              'Producto añadido manualmente por el usuario.',
                          quantity: 0,
                        );

                        await DatabaseHelper.instance.insertarProducto(
                          nuevoProducto,
                        );

                        await _cargarProductos();

                        if (!context.mounted) return;
                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡${nuevoProducto.name} guardado en la lista!',
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

          // Lista de alimentos editable desde SQLite
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                ? const Center(
                    child: Text(
                      'No hay productos guardados.\nAgrega uno nuevo con el ícono superior.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final bool enCarrito = product.quantity > 0;
                      final bool tieneImagen = product.imagePath.isNotEmpty;
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
                            child: tieneImagen
                                ? (esRutaLocal
                                      ? Image.file(
                                          File(product.imagePath),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stack) =>
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
                                          errorBuilder: (ctx, err, stack) =>
                                              Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.fastfood,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        ))
                                : Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.fastfood,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          title: Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: enCarrito
                                  ? Colors.green[900]
                                  : Colors.black,
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
                              // NUEVO: Botón para editar el producto
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Editar Producto',
                                onPressed: () =>
                                    _mostrarModalEditarProducto(product),
                              ),
                              // Botón para eliminar de la base de datos
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                tooltip: 'Eliminar de la BD',
                                onPressed: () =>
                                    _eliminarProducto(product.id, product.name),
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
