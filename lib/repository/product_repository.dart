import '../data/database_helper.dart';
import '../models/product.dart';

class ProductRepository {
  final DatabaseHelper _db;

  ProductRepository(this._db);

  Future<List<ProductModel>> getAll() async {
    final rows = await _db.obtenerProductos();
    return rows.map((m) => ProductModel.fromMap(m)).toList();
  }

  Future<void> save(ProductModel product) async {
    await _db.insertarProducto(product);
  }

  Future<void> update(ProductModel product) async {
    await _db.actualizarProducto(product);
  }

  Future<void> delete(String id) async {
    await _db.eliminarProducto(id);
  }

  Future<void> saveAll(List<ProductModel> products) async {
    for (final p in products) {
      await _db.insertarProducto(p);
    }
  }
}
