import 'package:flutter/foundation.dart';
import '../models/tarea.dart';
import '../services/db_service.dart';

class TareasProvider extends ChangeNotifier {
  List<Tarea> _tareas = [];
  String _filtro = 'Todas';
  bool _isOffline = false;

  List<Tarea> get tareas => _tareas;
  String get filtro => _filtro;
  bool get isOffline => _isOffline;

  List<Tarea> get tareasFiltradas {
    if (_filtro == 'Pendientes') {
      return _tareas.where((t) => !t.completada).toList();
    } else if (_filtro == 'Completadas') {
      return _tareas.where((t) => t.completada).toList();
    }
    return _tareas;
  }

  void setOffline(bool valor) {
    _isOffline = valor;
    notifyListeners();
  }

  void cambiarFiltro(String nuevoFiltro) {
    _filtro = nuevoFiltro;
    notifyListeners();
  }

  Future<void> cargarTareas() async {
    _tareas = await DbService.listar();
    notifyListeners();
  }

  Future<void> agregarTarea(String titulo, String desc) async {
    await DbService.insertar(Tarea(titulo: titulo, descripcion: desc));
    await cargarTareas();
  }

  Future<void> actualizarTarea(Tarea tarea) async {
    await DbService.actualizar(tarea);
    await cargarTareas();
  }

  Future<void> eliminarTarea(int id) async {
    await DbService.eliminar(id);
    await cargarTareas();
  }

  Future<void> cambiarEstado(Tarea tarea) async {
    final actualizada = Tarea(
      id: tarea.id,
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
      completada: !tarea.completada,
      pendienteSincronizar: 1,
    );
    await DbService.actualizar(actualizada);
    await cargarTareas();
  }
}
