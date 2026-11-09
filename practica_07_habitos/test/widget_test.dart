import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_habitos/models/habito.dart';
import 'package:practica_07_habitos/providers/habitos_provider.dart';
import 'package:practica_07_habitos/services/habito_service.dart';

void main() {
  test('copiarCon cambia solo lo indicado', () {
    const h = Habito(id: 1, nombre: 'Leer');
    final c = h.copiarCon(completado: true);
    expect(c.completado, true);
    expect(c.nombre, 'Leer');
  });

  test('cargar trae los hábitos iniciales', () async {
    final p = HabitosProvider(HabitoService());
    await p.cargar();
    expect(p.total, 3);
    expect(p.completados, 0);
  });

  test('agregar ignora texto vacío y agrega uno válido', () async {
    final p = HabitosProvider(HabitoService());
    await p.cargar();
    await p.agregar('   ');
    expect(p.total, 3);
    await p.agregar('Meditar');
    expect(p.total, 4);
  });

  test('alternar marca y desmarca', () async {
    final p = HabitosProvider(HabitoService());
    await p.cargar();
    await p.alternar(p.habitos.first);
    expect(p.completados, 1);
    await p.alternar(p.habitos.first);
    expect(p.completados, 0);
  });

  test('eliminar quita el hábito', () async {
    final p = HabitosProvider(HabitoService());
    await p.cargar();
    await p.eliminar(1);
    expect(p.total, 2);
  });
}
