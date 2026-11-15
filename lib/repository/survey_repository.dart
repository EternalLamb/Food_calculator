import 'dart:convert';

import 'package:flutter/services.dart';

class SurveyRepository {
  /// Devuelve el JSON completo: { "seccion": [ {id, titulo, min, max}, ... ], ... }
  Future<Map<String, List<Map<String, dynamic>>>> loadSurvey() async {
    final raw = await rootBundle.loadString('assets/encuesta_qa.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;

    return decoded.map(
      (section, items) => MapEntry(
        section,
        (items as List).map((e) => Map<String, dynamic>.from(e)).toList(),
      ),
    );
  }
}
