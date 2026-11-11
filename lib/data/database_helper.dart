import 'dart:async';

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
      version: 3,
      onCreate: (db, version) async {
        await _crearTabla(db);
        await _insertarProductosIniciales(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('DROP TABLE IF EXISTS productos');

          await _crearTabla(db);
          await _insertarProductosIniciales(db);
        }
      },
    );
  }

  // Crear tabla de productos
  Future<void> _crearTabla(Database db) async {
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

  // Insertar productos iniciales
  Future<void> _insertarProductosIniciales(Database db) async {
    final List<Map<String, dynamic>> productosBasicos = [
      {
        'id': 'base_1',
        'name': 'Arroz (1 kg)',
        'price': 1200.0,
        'category': 'Abarrotes',
        'imagePath': '',
        'yieldDescription':
            'Rinde múltiples porciones para acompañar almuerzos.',
        'quantity': 0,
      },
      {
        'id': 'base_2',
        'name': 'Aceite Maravilla (1 L)',
        'price': 1890.0,
        'category': 'Abarrotes',
        'imagePath': '',
        'yieldDescription': 'Esencial para cocinar y preparar aderezos.',
        'quantity': 0,
      },
      {
        'id': 'base_3',
        'name': 'Pan Hallulla / Marraqueta (1 kg)',
        'price': 2100.0,
        'category': 'Panadería',
        'imagePath': '',
        'yieldDescription': 'Alimento básico para desayunos y once.',
        'quantity': 0,
      },
      {
        'id': 'base_4',
        'name': 'Leche Entera (1 L)',
        'price': 990.0,
        'category': 'Lácteos',
        'imagePath': '',
        'yieldDescription': 'Fuente de calcio y lácteo diario.',
        'quantity': 0,
      },
      {
        'id': 'base_5',
        'name': 'Kilo de Tomates (1 kg)',
        'price': 1690.0,
        'category': 'Verduras',
        'imagePath': '',
        'yieldDescription': 'Ideal para ensaladas frescas.',
        'quantity': 0,
      },
      {
        'id': 'base_6',
        'name': 'Bolsa de Cebollas (1 kg)',
        'price': 1200.0,
        'category': 'Verduras',
        'imagePath': '',
        'yieldDescription': 'Base indispensable para sofritos y comidas.',
        'quantity': 0,
      },
    ];

    for (var prod in productosBasicos) {
      await db.insert('productos', prod);
    }
  }

  // Insertar un producto
  Future<int> insertarProducto(ProductModel producto) async {
    final db = await database;

    return db.insert(
      'productos',
      producto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los productos
  Future<List<Map<String, Object?>>> obtenerProductos() async {
    final db = await database;

    return db.query('productos', orderBy: 'id DESC');
  }

  // Eliminar un producto
  Future<int> eliminarProducto(String id) async {
    final db = await database;

    return db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }
}
