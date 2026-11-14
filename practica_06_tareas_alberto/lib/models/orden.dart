import 'tarea.dart';

enum OrdenTareas { prioridad, recientes }

List<Tarea> organizarTareas(
  List<Tarea> tareas, {
  required OrdenTareas orden,
  required bool mostrarCompletadas,
}) {
  final lista = tareas
      .where((t) => mostrarCompletadas || !t.completada)
      .toList();
  lista.sort((a, b) {
    // Las pendientes siempre van antes que las completadas.
    if (a.completada != b.completada) return a.completada ? 1 : -1;
    if (orden == OrdenTareas.prioridad && a.prioridad != b.prioridad) {
      return a.prioridad.index.compareTo(b.prioridad.index);
    }
    return b.creada.compareTo(a.creada);
  });
  return lista;
}
