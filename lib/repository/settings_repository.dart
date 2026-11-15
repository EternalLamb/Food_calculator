import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _kSueldo = 'ultimo_sueldo';

  Future<double?> getSueldo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kSueldo);
  }

  Future<void> saveSueldo(double sueldo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kSueldo, sueldo);
  }
}
