import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarea.dart';

class DB {
  static Database? _db;

  static Future<Database> _abrir() async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'tareas.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            completada INTEGER NOT NULL DEFAULT 0,
            pendiente_sincronizar INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<int> insertar(Tarea tarea) async {
    final db = await _abrir();
    return db.insert('tareas', tarea.toMap()..remove('id'));
  }

  static Future<List<Tarea>> listar([String filtro = 'todas']) async {
    final db = await _abrir();
    String? where;
    List<Object?>? args;
    if (filtro == 'pendientes') {
      where = 'completada = ?';
      args = [0];
    } else if (filtro == 'completadas') {
      where = 'completada = ?';
      args = [1];
    }
    final filas = await db.query(
      'tareas',
      where: where,
      whereArgs: args,
      orderBy: 'completada ASC, id DESC',
    );
    return filas.map(Tarea.fromMap).toList();
  }

  static Future<int> actualizar(Tarea tarea) async {
    final db = await _abrir();
    return db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await _abrir();
    return db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> existeTitulo(String titulo, {int? exceptoId}) async {
    final db = await _abrir();
    final filas = await db.query(
      'tareas',
      where: 'LOWER(titulo) = ? AND id != ?',
      whereArgs: [titulo.toLowerCase(), exceptoId ?? -1],
      limit: 1,
    );
    return filas.isNotEmpty;
  }
}
