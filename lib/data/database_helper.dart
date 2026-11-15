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

  Future<void> _insertarProductosIniciales(Database db) async {
    final List<Map<String, dynamic>> productosBasicos = [
      // --- ABARROTES ---
      {
        'id': 'base_1',
        'name': 'Arroz Grado 2 (1 kg)',
        'price': 1200.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/arroz.jpg',
        'yieldDescription':
            'Rinde múltiples porciones para acompañar almuerzos.',
        'quantity': 0,
      },
      {
        'id': 'base_2',
        'name': 'Aceite (1 L)',
        'price': 1890.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/aceite.jpg',
        'yieldDescription': 'Esencial para cocinar y preparar aderezos.',
        'quantity': 0,
      },
      {
        'id': 'base_3',
        'name': 'Fideos Spaghetti (400 g)',
        'price': 890.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/fideos.jpg',
        'yieldDescription': 'Rinde de 4 a 5 porciones de pasta.',
        'quantity': 0,
      },
      {
        'id': 'base_4',
        'name': 'Azúcar Granulada (1 kg)',
        'price': 1350.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/azucar.jpg',
        'yieldDescription': 'Ideal para endulzar infusiones y repostería.',
        'quantity': 0,
      },
      {
        'id': 'base_5',
        'name': 'Harina de Trigo (1 kg)',
        'price': 1100.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/harina.jpg',
        'yieldDescription': 'Base para masas, panqueques y preparaciones.',
        'quantity': 0,
      },
      {
        'id': 'base_6',
        'name': 'Lentejas (1 kg)',
        'price': 1850.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/lentejas.jpg',
        'yieldDescription':
            'Alto contenido en fibra y hierro, rinde muchas porciones.',
        'quantity': 0,
      },
      {
        'id': 'base_7',
        'name': 'Atún en Lata (170 g)',
        'price': 1290.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/atun.jpg',
        'yieldDescription': 'Práctico para ensaladas o sándwiches rápidos.',
        'quantity': 0,
      },
      {
        'id': 'base_8',
        'name': 'Salsa de Tomate (200 g)',
        'price': 690.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/salsa_tomate.jpg',
        'yieldDescription': 'Ideal para acompañar fideos o guisos.',
        'quantity': 0,
      },
      {
        'id': 'base_9',
        'name': 'Té Bolsitas (100 Unidades)',
        'price': 2490.0,
        'category': 'Abarrotes',
        'imagePath': 'assets/images/te.jpg',
        'yieldDescription': 'Para el consumo diario en desayunos y once.',
        'quantity': 0,
      },

      // --- PANADERÍA ---
      {
        'id': 'base_10',
        'name': 'Pan Hallulla / Marraqueta (1 kg)',
        'price': 2100.0,
        'category': 'Panadería',
        'imagePath': 'assets/images/pan.jpg',
        'yieldDescription': 'Alimento básico para desayunos y once.',
        'quantity': 0,
      },

      // --- LÁCTEOS Y HUEVOS ---
      {
        'id': 'base_11',
        'name': 'Leche Entera (1 L)',
        'price': 990.0,
        'category': 'Lácteos',
        'imagePath': 'assets/images/leche.jpg',
        'yieldDescription': 'Fuente de calcio y lácteo diario.',
        'quantity': 0,
      },
      {
        'id': 'base_12',
        'name': 'Huevos de Gallina (Cartón 30 un)',
        'price': 5490.0,
        'category': 'Lácteos',
        'imagePath': 'assets/images/huevos.jpg',
        'yieldDescription':
            'Versátil para múltiples preparaciones y desayunos.',
        'quantity': 0,
      },
      {
        'id': 'base_13',
        'name': 'Queso Mantecoso (Trozo 250 g)',
        'price': 2390.0,
        'category': 'Lácteos',
        'imagePath': 'assets/images/queso.jpg',
        'yieldDescription': 'Ideal para sándwiches y acompañamientos.',
        'quantity': 0,
      },
      {
        'id': 'base_14',
        'name': 'Yogurt Batido Sabor Frutilla (Pack 4)',
        'price': 1490.0,
        'category': 'Lácteos',
        'imagePath': 'assets/images/yogurt.jpg',
        'yieldDescription': 'Perfecto para colaciones o desayunos.',
        'quantity': 0,
      },
      {
        'id': 'base_15',
        'name': 'Mantequilla con Sal (250 g)',
        'price': 2190.0,
        'category': 'Lácteos',
        'imagePath': 'assets/images/mantequilla.jpg',
        'yieldDescription': 'Para untar en el pan o cocinar.',
        'quantity': 0,
      },

      // --- VERDURAS ---
      {
        'id': 'base_16',
        'name': 'Kilo de Tomates (1 kg)',
        'price': 1690.0,
        'category': 'Verduras',
        'imagePath': 'assets/images/tomates.jpg',
        'yieldDescription': 'Ideal para ensaladas frescas.',
        'quantity': 0,
      },
      {
        'id': 'base_17',
        'name': 'Bolsa de Cebollas (1 kg)',
        'price': 1200.0,
        'category': 'Verduras',
        'imagePath': 'assets/images/cebollas.jpg',
        'yieldDescription': 'Base indispensable para sofritos y comidas.',
        'quantity': 0,
      },
      {
        'id': 'base_18',
        'name': 'Papas Saco/Malla (3 kg)',
        'price': 2990.0,
        'category': 'Verduras',
        'imagePath': 'assets/images/papas.jpg',
        'yieldDescription': 'Acompañamiento fundamental para guisos y puré.',
        'quantity': 0,
      },
      {
        'id': 'base_19',
        'name': 'Lechuga Escarola (Unidad)',
        'price': 1200.0,
        'category': 'Verduras',
        'imagePath': 'assets/images/lechuga.webp',
        'yieldDescription': 'Fresca, ideal para ensaladas de la temporada.',
        'quantity': 0,
      },
      {
        'id': 'base_20',
        'name': 'Zanahorias (Malla 1 kg)',
        'price': 1190.0,
        'category': 'Verduras',
        'imagePath': 'assets/images/zanahoria.jpg',
        'yieldDescription': 'Útiles para sopas, ensaladas ralladas y guisos.',
        'quantity': 0,
      },

      // --- FRUTAS ---
      {
        'id': 'base_21',
        'name': 'Palta Hass (1 kg)',
        'price': 4990.0,
        'category': 'Frutas',
        'imagePath': 'assets/images/palta.webp',
        'yieldDescription':
            'Perfecta para acompañar pan, ensaladas o completos.',
        'quantity': 0,
      },
      {
        'id': 'base_22',
        'name': 'Plátanos (1 kg)',
        'price': 1590.0,
        'category': 'Frutas',
        'imagePath': 'assets/images/platanos.jpg',
        'yieldDescription': 'Fruta energética ideal para colaciones.',
        'quantity': 0,
      },
      {
        'id': 'base_23',
        'name': 'Manzanas (1 kg)',
        'price': 1690.0,
        'category': 'Frutas',
        'imagePath': 'assets/images/manzanas.jpg',
        'yieldDescription': 'Fruta crujiente y duradera.',
        'quantity': 0,
      },

      // --- CARNES Y PESCADOS ---
      {
        'id': 'base_24',
        'name': 'Pechuga de Pollo Entera (1 kg)',
        'price': 5990.0,
        'category': 'Carnes',
        'imagePath': 'assets/images/pechuga.jpg',
        'yieldDescription': 'Carne blanca versátil para distintos platos.',
        'quantity': 0,
      },
      {
        'id': 'base_25',
        'name': 'Carne Molida Corriente (1 kg)',
        'price': 6990.0,
        'category': 'Carnes',
        'imagePath': 'assets/images/carne_molida.jpg',
        'yieldDescription':
            'Ideal para hamburguesas caseras, pasteles o salsa boloñesa.',
        'quantity': 0,
      },
      {
        'id': 'base_26',
        'name': 'Trutro Entero de Pollo (1 kg)',
        'price': 3990.0,
        'category': 'Carnes',
        'imagePath': 'assets/images/truto.webp',
        'yieldDescription':
            'Económico y rendidor para almuerzos al horno o cazuela.',
        'quantity': 0,
      },
      {
        'id': 'base_27',
        'name': 'Jurel en Conserva (425 g)',
        'price': 1890.0,
        'category': 'Pescados y Mariscos',
        'imagePath': 'assets/images/jurel.jpg',
        'yieldDescription':
            'Excelente fuente de omega-3, ideal para budines o ensaladas.',
        'quantity': 0,
      },
    ];

    for (var producto in productosBasicos) {
      await db.insert(
        'productos', // Reemplaza con el nombre de tu tabla
        producto,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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

  Future<int> actualizarProducto(ProductModel producto) async {
    final db = await database;
    return db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
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
