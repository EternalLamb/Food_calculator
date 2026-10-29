import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'lista_compras.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            cantidad INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertarProducto(String nombre, int cantidad) async {
    final db = await database;

    return db.insert('productos', {'nombre': nombre, 'cantidad': cantidad});
  }

  Future<List<Map<String, Object?>>> obtenerProductos() async {
    final db = await database;

    return db.query('productos', orderBy: 'id DESC');
  }
}
