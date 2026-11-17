import 'package:flutter/foundation.dart';

import '../models/tarea.dart';
import '../services/tareas_service.dart';

class TareasProvider extends ChangeNotifier {
  TareasProvider(this._servicio);

  final TareasService _servicio;

  List<Tarea> _tareas = [];
  bool _cargando = false;

  List<Tarea> get tareas => List.unmodifiable(_tareas);
  bool get cargando => _cargando;
  int get pendientes => _tareas.where((t) => !t.completada).length;

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    _tareas = await _servicio.obtenerTodas();
    _cargando = false;
    notifyListeners();
  }

  Future<void> agregar(String titulo) async {
    final limpio = titulo.trim();
    if (limpio.isEmpty) return;
    final nueva = await _servicio.agregar(limpio);
    _tareas = [..._tareas, nueva];
    notifyListeners();
  }

  Future<void> alternar(Tarea tarea) async {
    final actualizada = tarea.copyWith(completada: !tarea.completada);
    await _servicio.actualizar(actualizada);
    _tareas = [
      for (final t in _tareas) t.id == actualizada.id ? actualizada : t,
    ];
    notifyListeners();
  }

  Future<void> eliminar(String id) async {
    await _servicio.eliminar(id);
    _tareas = _tareas.where((t) => t.id != id).toList();
    notifyListeners();
  }
}
