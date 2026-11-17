import '../models/tarea.dart';

class TareasService {
  TareasService({this.latencia = const Duration(milliseconds: 300)});

  final Duration latencia;
  final List<Tarea> _almacen = [];
  int _siguienteId = 1;

  Future<List<Tarea>> obtenerTodas() async {
    await Future<void>.delayed(latencia);
    return List.unmodifiable(_almacen);
  }

  Future<Tarea> agregar(String titulo) async {
    await Future<void>.delayed(latencia);
    final tarea = Tarea(
      id: '${_siguienteId++}',
      titulo: titulo,
      creada: DateTime.now(),
    );
    _almacen.add(tarea);
    return tarea;
  }

  Future<void> actualizar(Tarea tarea) async {
    await Future<void>.delayed(latencia);
    final indice = _almacen.indexWhere((t) => t.id == tarea.id);
    if (indice != -1) {
      _almacen[indice] = tarea;
    }
  }

  Future<void> eliminar(String id) async {
    await Future<void>.delayed(latencia);
    _almacen.removeWhere((t) => t.id == id);
  }
}
