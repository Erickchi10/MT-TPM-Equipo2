
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    final ruta = join(
      await getDatabasesPath(),
      'bitacora_inspecciones.db',
    );

    _database = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE inspecciones (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            categoria TEXT NOT NULL,
            foto_path TEXT,
            latitud REAL,
            longitud REAL,
            fecha TEXT NOT NULL,
            acelerometro_x REAL,
            acelerometro_y REAL,
            acelerometro_z REAL,
            giroscopio_x REAL,
            giroscopio_y REAL,
            giroscopio_z REAL,
            sincronizado INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<int> guardarInspeccion(
    Map<String, Object?> datos,
  ) async {
    final db = await database;

    return await db.insert(
      'inspecciones',
      datos,
    );
  }

  static Future<List<Map<String, Object?>>> obtenerInspecciones() async {
    final db = await database;

    return await db.query(
      'inspecciones',
      orderBy: 'id DESC',
    );
  }


  static Future<int> eliminarInspeccion(int id) async {
    final db = await database;

    return await db.delete(
      'inspecciones',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> marcarComoSincronizada(int id) async {
  final db = await database;

  return await db.update(
    'inspecciones',
    {'sincronizado': 1},
    where: 'id = ?',
    whereArgs: [id],
    );
  }
}
