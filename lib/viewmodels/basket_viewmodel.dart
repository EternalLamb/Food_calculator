import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../repositories/settings_repository.dart';
import '../services/camera_service.dart';

class BasketViewModel extends ChangeNotifier {
  final ProductRepository _repo;
  final SettingsRepository _settings;
  final CameraService _camera;

  BasketViewModel(this._repo, this._settings, this._camera);

  List<ProductModel> products = [];
  bool isLoading = false;
  String? errorMessage;
  double sueldo = 0;

  static const List<String> categorias = [
    'Abarrotes',
    'Proteínas',
    'Lácteos',
    'Frutas',
    'Verduras',
    'Panadería',
    'Limpieza',
  ];

  // ---------- Estado derivado ----------
  double get totalGastado =>
      products.fold(0.0, (s, p) => s + p.price * p.quantity);

  double get saldoRestante => sueldo - totalGastado;

  ProductModel? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  // ---------- Carga ----------
  Future<void> init() async {
    sueldo = await _settings.getSueldo() ?? 0;
    await load();
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      products = await _repo.getAll();
      errorMessage = null;
    } catch (_) {
      errorMessage = 'No se pudieron cargar los productos.';
    }
    isLoading = false;
    notifyListeners();
  }

  // ---------- Generar canasta ----------
  /// Devuelve un mensaje de error de validación, o null si todo salió bien.
  Future<String?> generarCanasta(
    String sueldoTexto, {
    required bool auto,
  }) async {
    final v = double.tryParse(sueldoTexto);
    if (v == null || v <= 0) {
      return 'Por favor, ingresa un monto de sueldo válido.';
    }

    sueldo = v;
    await _settings.saveSueldo(v);
    await load();

    for (final p in products) {
      p.quantity = 0;
    }
    if (auto) _algoritmoCanastaInteligente();

    await _repo.saveAll(products);
    notifyListeners();
    return null;
  }

  void _algoritmoCanastaInteligente() {
    if (products.isEmpty) return;

    final Map<String, double> cuotasCategoria = {
      'Abarrotes': sueldo * 0.30,
      'Proteínas': sueldo * 0.25,
      'Lácteos': sueldo * 0.10,
      'Verduras': sueldo * 0.10,
      'Frutas': sueldo * 0.10,
      'Panadería': sueldo * 0.08,
      'Limpieza': sueldo * 0.07,
    };

    double gastoTotal = 0.0;

    for (final entry in cuotasCategoria.entries) {
      final categoria = entry.key;
      final presupuestoCategoria = entry.value;

      final productosCategoria =
          products.where((p) => p.category == categoria).toList()
            ..sort((a, b) => a.price.compareTo(b.price));

      if (productosCategoria.isEmpty) continue;

      double gastoEnCategoria = 0.0;
      bool pudoComprar = true;

      while (pudoComprar) {
        pudoComprar = false;
        for (final product in productosCategoria) {
          if (gastoEnCategoria + product.price <= presupuestoCategoria &&
              gastoTotal + product.price <= sueldo) {
            product.quantity++;
            gastoEnCategoria += product.price;
            gastoTotal += product.price;
            pudoComprar = true;
          }
        }
      }
    }

    final todosOrdenados = List<ProductModel>.from(products)
      ..sort((a, b) => a.price.compareTo(b.price));

    bool sigueAlcanzando = true;
    while (sigueAlcanzando) {
      sigueAlcanzando = false;
      for (final product in todosOrdenados) {
        if (gastoTotal + product.price <= sueldo) {
          product.quantity++;
          gastoTotal += product.price;
          sigueAlcanzando = true;
        }
      }
    }
  }

  // ---------- Carrito ----------
  /// Devuelve false si no hay saldo suficiente.
  Future<bool> addToCart(ProductModel p) async {
    if (saldoRestante < p.price) return false;
    p.quantity++;
    notifyListeners();
    await _repo.update(p);
    return true;
  }

  Future<void> removeFromCart(ProductModel p) async {
    if (p.quantity <= 0) return;
    p.quantity--;
    notifyListeners();
    await _repo.update(p);
  }

  // ---------- CRUD ----------
  Future<void> deleteProduct(String id) async {
    await _repo.delete(id);
    products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Future<void> addProduct({
    required String name,
    required double price,
    required String category,
    String? imagePath,
  }) async {
    final p = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      category: category,
      imagePath: imagePath ?? '',
      yieldDescription: 'Producto añadido manualmente por el usuario.',
      quantity: 0,
    );
    await _repo.save(p);
    await load();
  }

  Future<void> updateProduct(
    ProductModel old, {
    required String name,
    required double price,
    required String category,
    String? imagePath,
  }) async {
    final p = ProductModel(
      id: old.id,
      name: name,
      price: price,
      category: category,
      imagePath: imagePath ?? old.imagePath,
      yieldDescription: old.yieldDescription,
      quantity: old.quantity,
    );
    await _repo.update(p);
    await load();
  }

  // ---------- Cámara ----------
  /// Devuelve la ruta o null si se canceló. Lanza [CameraException] si falla.
  Future<String?> takePhoto() => _camera.takePhoto();
}
