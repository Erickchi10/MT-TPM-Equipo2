import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura_mauricio/models/tarea.dart';
import 'package:practica_07_arquitectura_mauricio/providers/tareas_provider.dart';

void main() {
  group('Modelo Tarea', () {
    test('toMap convierte la tarea a Map', () {
      final t = Tarea(id: 1, titulo: 'Estudiar', descripcion: 'Provider', completada: true);
      final m = t.toMap();
      expect(m['id'], 1);
      expect(m['titulo'], 'Estudiar');
      expect(m['completada'], 1);
      expect(m['pendiente_sincronizar'], 1);
    });

    test('fromMap crea la tarea desde un Map', () {
      final t = Tarea.fromMap({
        'id': 2,
        'titulo': 'Tarea',
        'descripcion': 'Desc',
        'completada': 0,
        'pendiente_sincronizar': 0,
      });
      expect(t.id, 2);
      expect(t.completada, false);
      expect(t.pendienteSincronizar, 0);
    });
  });

  group('TareasProvider', () {
    test('estado inicial', () {
      final p = TareasProvider();
      expect(p.tareas, isEmpty);
      expect(p.filtro, 'Todas');
      expect(p.isOffline, false);
      expect(p.tareasFiltradas, isEmpty);
    });

    test('cambiarFiltro actualiza el filtro y avisa a la UI', () {
      final p = TareasProvider();
      var avisos = 0;
      p.addListener(() => avisos++);
      p.cambiarFiltro('Pendientes');
      expect(p.filtro, 'Pendientes');
      p.cambiarFiltro('Completadas');
      expect(p.filtro, 'Completadas');
      expect(avisos, 2);
    });

    test('setOffline cambia el modo sin conexion', () {
      final p = TareasProvider();
      var avisos = 0;
      p.addListener(() => avisos++);
      p.setOffline(true);
      expect(p.isOffline, true);
      p.setOffline(false);
      expect(p.isOffline, false);
      expect(avisos, 2);
    });
  });
}
