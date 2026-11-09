import 'package:flutter/foundation.dart';

import '../models/tarea.dart';
import '../services/preferencias_service.dart';
import '../services/tarea_service.dart';

class TareasProvider extends ChangeNotifier {
  TareasProvider(this._tareaService, this._preferencias);

  final TareaService _tareaService;
  final PreferenciasService _preferencias;

  List<Tarea> _tareas = [];
  String _filtro = 'todas';
  bool _cargando = false;
  Tarea? _editando;

  List<Tarea> get tareas => List.unmodifiable(_tareas);
  String get filtro => _filtro;
  bool get cargando => _cargando;
  Tarea? get editando => _editando;

  Future<void> iniciar() async {
    _cargando = true;
    notifyListeners();
    _filtro = await _preferencias.leerFiltro();
    _tareas = await _tareaService.listar(_filtro);
    _cargando = false;
    notifyListeners();
  }

  Future<void> _recargar() async {
    _tareas = await _tareaService.listar(_filtro);
    notifyListeners();
  }

  Future<void> cambiarFiltro(String nuevo) async {
    _filtro = nuevo;
    await _preferencias.guardarFiltro(nuevo);
    await _recargar();
  }

  Future<String?> validar(String texto) async {
    final t = texto.trim();
    if (t.isEmpty) return 'Escribe el título de la tarea';
    if (t.length < 3) return 'Mínimo 3 caracteres';
    if (t.length > 60) return 'Máximo 60 caracteres';
    if (await _tareaService.existeTitulo(t, exceptoId: _editando?.id)) {
      return 'Esa tarea ya existe';
    }
    return null;
  }

  Future<String?> guardar(String texto) async {
    final error = await validar(texto);
    if (error != null) return error;
    final t = texto.trim();
    final enEdicion = _editando;
    if (enEdicion == null) {
      await _tareaService.insertar(
        Tarea(titulo: t, fechaCreacion: DateTime.now()),
      );
    } else {
      await _tareaService.actualizar(
        enEdicion.copiarCon(titulo: t, pendienteSincronizar: true),
      );
      _editando = null;
    }
    await _recargar();
    return null;
  }

  void empezarEdicion(Tarea tarea) {
    _editando = tarea;
    notifyListeners();
  }

  void cancelarEdicion() {
    _editando = null;
    notifyListeners();
  }

  Future<void> alternar(Tarea tarea) async {
    await _tareaService.actualizar(
      tarea.copiarCon(
        completada: !tarea.completada,
        pendienteSincronizar: true,
      ),
    );
    await _recargar();
  }

  Future<void> eliminar(int id) async {
    await _tareaService.eliminar(id);
    if (_editando?.id == id) _editando = null;
    await _recargar();
  }
}
