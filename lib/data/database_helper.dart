import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            category TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            yieldDescription TEXT NOT NULL,
            quantity INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS productos');
          await db.execute('''
            CREATE TABLE productos (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              price REAL NOT NULL,
              category TEXT NOT NULL,
              imagePath TEXT NOT NULL,
              yieldDescription TEXT NOT NULL,
              quantity INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  // Recibe un ProductModel en lugar de parámetros sueltos
  Future<int> insertarProducto(ProductModel producto) async {
    final db = await database;
    return db.insert(
      'productos',
      producto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> obtenerProductos() async {
    final db = await database;

    return db.query('productos', orderBy: 'id DESC');
  }
}
