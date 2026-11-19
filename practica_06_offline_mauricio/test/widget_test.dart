import 'package:flutter_test/flutter_test.dart';
import 'package:practica_06_offline_mauricio/models/tarea.dart';

void main() {
  test('toMap convierte la tarea a Map', () {
    final t = Tarea(id: 1, titulo: 'Estudiar', descripcion: 'Flutter', completada: true);
    final m = t.toMap();
    expect(m['id'], 1);
    expect(m['titulo'], 'Estudiar');
    expect(m['descripcion'], 'Flutter');
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
    expect(t.titulo, 'Tarea');
    expect(t.completada, false);
    expect(t.pendienteSincronizar, 0);
  });

  test('valores por defecto de una tarea nueva', () {
    final t = Tarea(titulo: 'Nueva', descripcion: 'Sin id');
    expect(t.id, isNull);
    expect(t.completada, false);
    expect(t.pendienteSincronizar, 1);
  });
}
