import 'package:flutter/material.dart';

import '../models/product.dart';
import '../views/list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _sueldoController = TextEditingController();

  void _irALista() {
    // Leemos el texto ingresado
    final String textoSueldo = _sueldoController.text;

    // Si el usuario no escribió nada, no avanzamos
    if (textoSueldo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu sueldo')),
      );
      return;
    }

    // Convertimos el texto a número
    final double sueldoIngresado = double.tryParse(textoSueldo) ?? 0.0;

    // Navegamos a la pantalla "list.dart" pasándole el sueldo guardado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductListView(products: mockProducts, sueldo: sueldoIngresado),
      ),
    );
  }

  @override
  void dispose() {
    _sueldoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Calculadora de alimentos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _sueldoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresar sueldo:',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _irALista,
              child: const Text('Ver alimentos'),
            ),
          ],
        ),
      ),
    );
  }
}
