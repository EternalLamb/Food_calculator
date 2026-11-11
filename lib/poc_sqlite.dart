import 'package:flutter/material.dart';

import '../models/product.dart';
import 'data/database_helper.dart';

void main() {
  runApp(const PocSQLiteApp());
}

class PocSQLiteApp extends StatelessWidget {
  const PocSQLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PocSQLitePage(),
    );
  }
}

class PocSQLitePage extends StatefulWidget {
  const PocSQLitePage({super.key});

  @override
  State<PocSQLitePage> createState() => _PocSQLitePageState();
}

class _PocSQLitePageState extends State<PocSQLitePage> {
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController(text: '1');
  final ProductModel _productoSeleccionado = ProductModel(
    id: '',
    name: '',
    price: 0,
    category: '',
    imagePath: '',
    yieldDescription: '',
    quantity: 0,
  );

  List<Map<String, Object?>> _productos = [];
  String _mensaje = 'Cargando productos...';
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await DatabaseHelper.instance.obtenerProductos();

      if (!mounted) return;

      setState(() {
        _productos = productos;
        _mensaje = 'Productos recuperados: ${productos.length}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _mensaje = 'Error al consultar la base de datos: $e';
      });
    }
  }

  Future<void> _agregarProducto() async {
    final nombre = _nombreController.text.trim();
    final cantidad = int.tryParse(_cantidadController.text);

    if (nombre.isEmpty || cantidad == null || cantidad <= 0) {
      setState(() {
        _mensaje = 'Ingresa un nombre y una cantidad válida.';
      });
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await DatabaseHelper.instance.insertarProducto(_productoSeleccionado);

      _nombreController.clear();
      _cantidadController.text = '1';

      await _cargarProductos();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _mensaje = 'Error al guardar el producto: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PoC de persistencia SQLite')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
              ),
            ),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _guardando ? null : _agregarProducto,
              child: Text(_guardando ? 'Guardando...' : 'Guardar producto'),
            ),
            Text(_mensaje),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                  final producto = _productos[index];

                  return ListTile(
                    title: Text(producto['nombre'] as String),
                    subtitle: Text('Cantidad: ${producto['cantidad']}'),
                    trailing: Text('#${producto['id']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
