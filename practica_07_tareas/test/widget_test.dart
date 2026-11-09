import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_tareas/models/tarea.dart';
import 'package:practica_07_tareas/providers/tareas_provider.dart';
import 'package:practica_07_tareas/services/preferencias_service.dart';
import 'package:practica_07_tareas/services/tarea_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TareaServiceFalso implements TareaService {
  final List<Tarea> _datos = [];
  int _siguienteId = 1;

  @override
  Future<List<Tarea>> listar(String filtro) async {
    final lista = _datos.where((t) {
      if (filtro == 'pendientes') return !t.completada;
      if (filtro == 'completadas') return t.completada;
      return true;
    }).toList();
    return lista.reversed.toList();
  }

  @override
  Future<Tarea> insertar(Tarea tarea) async {
    final nueva = Tarea(
      id: _siguienteId++,
      titulo: tarea.titulo,
      completada: tarea.completada,
      pendienteSincronizar: tarea.pendienteSincronizar,
      fechaCreacion: tarea.fechaCreacion,
    );
    _datos.add(nueva);
    return nueva;
  }

  @override
  Future<void> actualizar(Tarea tarea) async {
    final i = _datos.indexWhere((t) => t.id == tarea.id);
    if (i != -1) _datos[i] = tarea;
  }

  @override
  Future<void> eliminar(int id) async {
    _datos.removeWhere((t) => t.id == id);
  }

  @override
  Future<bool> existeTitulo(String titulo, {int? exceptoId}) async {
    return _datos.any(
      (t) =>
          t.titulo.toLowerCase() == titulo.toLowerCase() && t.id != exceptoId,
    );
  }
}

TareasProvider crearProvider() {
  return TareasProvider(TareaServiceFalso(), PreferenciasService());
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Tarea toMap y fromMap conservan los datos', () {
    final original = Tarea(
      id: 7,
      titulo: 'Estudiar Flutter',
      completada: true,
      pendienteSincronizar: false,
      fechaCreacion: DateTime(2026, 11, 8, 17, 30),
    );
    final copia = Tarea.fromMap(original.toMap());
    expect(copia.id, 7);
    expect(copia.titulo, 'Estudiar Flutter');
    expect(copia.completada, true);
    expect(copia.pendienteSincronizar, false);
    expect(copia.fechaCreacion, DateTime(2026, 11, 8, 17, 30));
  });

  test('una tarea nueva queda pendiente y sin completar', () {
    final t = Tarea(titulo: 'Nueva', fechaCreacion: DateTime.now());
    expect(t.completada, false);
    expect(t.pendienteSincronizar, true);
  });

  test('copiarCon cambia solo lo indicado', () {
    final t = Tarea(titulo: 'Leer', fechaCreacion: DateTime(2026, 1, 1));
    final c = t.copiarCon(completada: true);
    expect(c.completada, true);
    expect(c.titulo, 'Leer');
    expect(c.fechaCreacion, DateTime(2026, 1, 1));
  });

  test('validar rechaza vacío, corto, largo y repetido', () async {
    final p = crearProvider();
    await p.iniciar();
    expect(await p.validar('   '), 'Escribe el título de la tarea');
    expect(await p.validar('ab'), 'Mínimo 3 caracteres');
    expect(await p.validar('a' * 61), 'Máximo 60 caracteres');
    expect(await p.guardar('Comprar pan'), isNull);
    expect(await p.validar('comprar pan'), 'Esa tarea ya existe');
  });

  test('guardar, completar y filtrar tareas', () async {
    final p = crearProvider();
    await p.iniciar();
    await p.guardar('Tarea uno');
    await p.guardar('Tarea dos');
    expect(p.tareas.length, 2);
    await p.alternar(p.tareas.first);
    await p.cambiarFiltro('pendientes');
    expect(p.tareas.length, 1);
    await p.cambiarFiltro('completadas');
    expect(p.tareas.length, 1);
  });

  test('el filtro se guarda y se recupera al iniciar', () async {
    final p1 = crearProvider();
    await p1.iniciar();
    expect(p1.filtro, 'todas');
    await p1.cambiarFiltro('completadas');

    final p2 = crearProvider();
    await p2.iniciar();
    expect(p2.filtro, 'completadas');
  });
}
