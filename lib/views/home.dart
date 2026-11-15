import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/basket_viewmodel.dart';
import 'encuesta.dart';
import 'list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _sueldoController = TextEditingController();
  bool _prefilled = false;

  @override
  void dispose() {
    _sueldoController.dispose();
    super.dispose();
  }

  Future<void> _generar({required bool auto}) async {
    final vm = context.read<BasketViewModel>();
    final error = await vm.generarCanasta(_sueldoController.text, auto: auto);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.orange),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductListView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BasketViewModel>();

    // Pre-llenar con el último sueldo persistido (solo una vez)
    if (!_prefilled && vm.sueldo > 0) {
      _sueldoController.text = vm.sueldo.toStringAsFixed(0);
      _prefilled = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Presupuesto')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.calculate_outlined,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Calculadora de Canasta Básica',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingresa tu sueldo o presupuesto disponible para planificar tus compras esenciales.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _sueldoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Sueldo / Presupuesto (CLP)',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generar Canasta Automáticamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _generar(auto: true),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Armar Canasta Desde Cero'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _generar(auto: false),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: const Icon(Icons.rate_review, color: Colors.blueGrey),
                  label: const Text(
                    'Evaluar Aplicación (Beta Testing)',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EvaluacionQAView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
