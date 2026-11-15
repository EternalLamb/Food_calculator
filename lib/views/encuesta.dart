import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class EvaluacionQAView extends StatefulWidget {
  const EvaluacionQAView({super.key});

  @override
  State<EvaluacionQAView> createState() => _EvaluacionQAViewState();
}

class _EvaluacionQAViewState extends State<EvaluacionQAView> {
  Map<String, dynamic>? _encuestaData;
  final Map<String, double> _respuestas = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarJson();
  }

  Future<void> _cargarJson() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/encuesta_qa.json',
      );
      final data = json.decode(response);
      setState(() {
        _encuestaData = data;
        _isLoading = false;

        // Inicializar valores por defecto en 3 estrellas para cada pregunta
        if (data.containsKey('cumplimiento_hu')) {
          for (var item in data['cumplimiento_hu']) {
            _respuestas[item['id']] = 3.0;
          }
        }
        if (data.containsKey('usabilidad')) {
          for (var item in data['usabilidad']) {
            _respuestas[item['id']] = 3.0;
          }
        }
      });
    } catch (e) {
      setState(() {
        _encuestaData = {};
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar la encuesta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _enviarResultados() {
    if (_respuestas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, responde la encuesta antes de enviar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    String reporte = "--- REPORTE DE QA BETA TESTING ---\n\n";
    _respuestas.forEach((key, value) {
      reporte += "$key: ${value.toInt()} de 5 estrellas\n";
    });

    Share.share(reporte, subject: 'Resultados Beta Testing - Food Calculator');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación de Calidad (QA)'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_encuestaData == null || _encuestaData!.isEmpty)
          ? const Center(
              child: Text('No se pudieron cargar las preguntas del JSON.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Instrumento de Evaluación (Beta Testing)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Evalúa cada aspecto de 1 a 5 estrellas según tu experiencia con el prototipo funcional.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),

                // 1. Sección Cumplimiento de Historias de Usuario
                if (_encuestaData!.containsKey('cumplimiento_hu')) ...[
                  const Text(
                    '1. Cumplimiento de Historias de Usuario',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(),
                  ...(_encuestaData!['cumplimiento_hu'] as List).map((item) {
                    String id = item['id'];
                    String titulo = item['titulo'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: _respuestas[id] ?? 3.0,
                              min: 1.0,
                              max: 5.0,
                              divisions: 4,
                              label:
                                  '${(_respuestas[id] ?? 3.0).toInt()} Estrellas',
                              onChanged: (val) {
                                setState(() {
                                  _respuestas[id] = val;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '1 (Difícil)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '5 (Excelente)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // 2. Sección Usabilidad y Experiencia General
                if (_encuestaData!.containsKey('usabilidad')) ...[
                  const Text(
                    '2. Experiencia General y Usabilidad',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(),
                  ...(_encuestaData!['usabilidad'] as List).map((item) {
                    String id = item['id'];
                    String titulo = item['titulo'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: _respuestas[id] ?? 3.0,
                              min: 1.0,
                              max: 5.0,
                              divisions: 4,
                              label:
                                  '${(_respuestas[id] ?? 3.0).toInt()} Estrellas',
                              onChanged: (val) {
                                setState(() {
                                  _respuestas[id] = val;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '1 (Confuso)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '5 (Perfecto)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],

                // Botón de envío nativo
                ElevatedButton.icon(
                  onPressed: _enviarResultados,
                  icon: const Icon(Icons.share),
                  label: const Text('Enviar Resultados por Correo/Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
    );
  }
}
