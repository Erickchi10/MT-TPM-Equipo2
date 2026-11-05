import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_06_tareas/models/tarea.dart';
import 'package:practica_06_tareas/preferencias.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Tarea.toMap y fromMap conservan los datos', () {
    const tarea = Tarea(
      id: 7,
      titulo: 'Estudiar Flutter',
      completada: true,
      pendienteSincronizar: false,
    );
    final copia = Tarea.fromMap(tarea.toMap());
    expect(copia.id, 7);
    expect(copia.titulo, 'Estudiar Flutter');
    expect(copia.completada, true);
    expect(copia.pendienteSincronizar, false);
  });

  test('Una tarea nueva está pendiente y por sincronizar', () {
    const tarea = Tarea(titulo: 'Nueva tarea');
    expect(tarea.completada, false);
    expect(tarea.pendienteSincronizar, true);
    expect(tarea.toMap()['completada'], 0);
  });

  test('copiarCon marca la tarea como completada', () {
    const tarea = Tarea(id: 1, titulo: 'Tarea');
    final hecha = tarea.copiarCon(completada: true);
    expect(hecha.completada, true);
    expect(hecha.id, 1);
    expect(hecha.titulo, 'Tarea');
  });

  test('El filtro por defecto es todas', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await Preferencias.leerFiltro(), 'todas');
  });

  test('Preferencias guarda y lee el filtro', () async {
    SharedPreferences.setMockInitialValues({});
    await Preferencias.guardarFiltro('completadas');
    expect(await Preferencias.leerFiltro(), 'completadas');
  });
}
