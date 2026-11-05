import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/nota.dart';

class DB {
  static Database? _db;

  static Future<Database> _abrir() async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'notas.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            contenido TEXT NOT NULL,
            pendiente_sincronizar INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<int> insertar(Nota nota) async {
    final db = await _abrir();
    return db.insert('notas', nota.toMap()..remove('id'));
  }

  static Future<List<Nota>> listar() async {
    final db = await _abrir();
    final filas = await db.query('notas', orderBy: 'id DESC');
    return filas.map(Nota.fromMap).toList();
  }

  static Future<int> actualizar(Nota nota) async {
    final db = await _abrir();
    return db.update(
      'notas',
      nota.toMap(),
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await _abrir();
    return db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}
