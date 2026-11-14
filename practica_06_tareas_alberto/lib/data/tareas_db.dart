import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarea.dart';

class TareasDB {
  static Database? _db;

  static Future<Database> get _database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'tareas_alberto.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE tareas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          descripcion TEXT NOT NULL DEFAULT '',
          prioridad INTEGER NOT NULL DEFAULT 1,
          completada INTEGER NOT NULL DEFAULT 0,
          creada INTEGER NOT NULL,
          pendiente_sincronizar INTEGER NOT NULL DEFAULT 1
        )
      '''),
    );
    return _db!;
  }

  static Future<int> insertar(Tarea tarea) async {
    final db = await _database;
    return db.insert('tareas', tarea.toMap());
  }

  static Future<List<Tarea>> listar() async {
    final db = await _database;
    final filas = await db.query('tareas');
    return filas.map(Tarea.fromMap).toList();
  }

  static Future<int> actualizar(Tarea tarea) async {
    final db = await _database;
    return db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}
