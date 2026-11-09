import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarea.dart';

abstract class TareaService {
  Future<List<Tarea>> listar(String filtro);
  Future<Tarea> insertar(Tarea tarea);
  Future<void> actualizar(Tarea tarea);
  Future<void> eliminar(int id);
  Future<bool> existeTitulo(String titulo, {int? exceptoId});
}

class TareaServiceSqlite implements TareaService {
  Database? _db;

  Future<Database> _abrir() async {
    final actual = _db;
    if (actual != null) return actual;
    final ruta = join(await getDatabasesPath(), 'tareas_arq.db');
    final db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            completada INTEGER NOT NULL DEFAULT 0,
            pendiente_sincronizar INTEGER NOT NULL DEFAULT 1,
            fecha_creacion TEXT NOT NULL
          )
        ''');
      },
    );
    _db = db;
    return db;
  }

  @override
  Future<List<Tarea>> listar(String filtro) async {
    final db = await _abrir();
    String? donde;
    if (filtro == 'pendientes') donde = 'completada = 0';
    if (filtro == 'completadas') donde = 'completada = 1';
    final filas = await db.query(
      'tareas',
      where: donde,
      orderBy: 'completada ASC, id DESC',
    );
    return filas.map(Tarea.fromMap).toList();
  }

  @override
  Future<Tarea> insertar(Tarea tarea) async {
    final db = await _abrir();
    final id = await db.insert('tareas', tarea.toMap());
    return Tarea.fromMap({...tarea.toMap(), 'id': id});
  }

  @override
  Future<void> actualizar(Tarea tarea) async {
    final db = await _abrir();
    await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  @override
  Future<void> eliminar(int id) async {
    final db = await _abrir();
    await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<bool> existeTitulo(String titulo, {int? exceptoId}) async {
    final db = await _abrir();
    final filas = await db.query(
      'tareas',
      where: exceptoId == null
          ? 'lower(titulo) = ?'
          : 'lower(titulo) = ? AND id != ?',
      whereArgs: exceptoId == null
          ? [titulo.toLowerCase()]
          : [titulo.toLowerCase(), exceptoId],
    );
    return filas.isNotEmpty;
  }
}
