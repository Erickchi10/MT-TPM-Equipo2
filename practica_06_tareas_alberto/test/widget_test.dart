import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_06_tareas_alberto/data/preferencias.dart';
import 'package:practica_06_tareas_alberto/models/orden.dart';
import 'package:practica_06_tareas_alberto/models/tarea.dart';
import 'package:practica_06_tareas_alberto/screens/form_tarea.dart';

Tarea _t(int id, Prioridad p, {bool hecha = false, int minuto = 0}) => Tarea(
  id: id,
  titulo: 'Tarea $id',
  prioridad: p,
  completada: hecha,
  creada: DateTime(2026, 11, 13, 10, minuto),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toMap y fromMap conservan los datos', () {
    final original = Tarea(
      id: 5,
      titulo: 'Estudiar SQLite',
      descripcion: 'Capítulo 6',
      prioridad: Prioridad.alta,
      completada: true,
      creada: DateTime(2026, 11, 13, 9, 30),
      pendienteSincronizar: false,
    );
    final copia = Tarea.fromMap(original.toMap());
    expect(copia.id, 5);
    expect(copia.titulo, 'Estudiar SQLite');
    expect(copia.descripcion, 'Capítulo 6');
    expect(copia.prioridad, Prioridad.alta);
    expect(copia.completada, isTrue);
    expect(copia.creada, DateTime(2026, 11, 13, 9, 30));
    expect(copia.pendienteSincronizar, isFalse);
  });

  test('Editar una tarea la deja pendiente de sincronizar', () {
    final sincronizada = Tarea(
      id: 1,
      titulo: 'Tarea',
      creada: DateTime(2026),
      pendienteSincronizar: false,
    );
    final editada = sincronizada.copyWith(completada: true);
    expect(editada.completada, isTrue);
    expect(editada.pendienteSincronizar, isTrue);
  });

  test('Validación del título', () {
    expect(Tarea.validarTitulo(''), 'El título es obligatorio');
    expect(Tarea.validarTitulo('ab'), 'Mínimo 3 caracteres');
    expect(Tarea.validarTitulo('Comprar pan'), isNull);
  });

  test('Ordena por prioridad y deja las completadas al final', () {
    final tareas = [
      _t(1, Prioridad.baja),
      _t(2, Prioridad.alta),
      _t(3, Prioridad.media),
      _t(4, Prioridad.alta, hecha: true),
    ];
    final todas = organizarTareas(
      tareas,
      orden: OrdenTareas.prioridad,
      mostrarCompletadas: true,
    );
    expect(todas.map((t) => t.id), [2, 3, 1, 4]);
    final sinHechas = organizarTareas(
      tareas,
      orden: OrdenTareas.prioridad,
      mostrarCompletadas: false,
    );
    expect(sinHechas.map((t) => t.id), [2, 3, 1]);
  });

  test('Ordena por más recientes', () {
    final tareas = [
      _t(1, Prioridad.alta, minuto: 1),
      _t(2, Prioridad.baja, minuto: 3),
      _t(3, Prioridad.media, minuto: 2),
    ];
    final lista = organizarTareas(
      tareas,
      orden: OrdenTareas.recientes,
      mostrarCompletadas: true,
    );
    expect(lista.map((t) => t.id), [2, 3, 1]);
  });

  test('Preferencias por defecto', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await PreferenciasUI.leerMostrarCompletadas(), isTrue);
    expect(await PreferenciasUI.leerOrden(), OrdenTareas.prioridad);
  });

  test('Las preferencias se guardan', () async {
    SharedPreferences.setMockInitialValues({});
    await PreferenciasUI.guardarOrden(OrdenTareas.recientes);
    await PreferenciasUI.guardarMostrarCompletadas(false);
    expect(await PreferenciasUI.leerOrden(), OrdenTareas.recientes);
    expect(await PreferenciasUI.leerMostrarCompletadas(), isFalse);
  });

  testWidgets('El formulario no deja guardar sin título', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormTarea()));
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    expect(find.text('El título es obligatorio'), findsOneWidget);
  });
}
