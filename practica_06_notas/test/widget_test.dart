import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_06_notas/models/nota.dart';
import 'package:practica_06_notas/preferencias.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Nota.toMap y fromMap conservan los datos', () {
    const nota = Nota(
      id: 1,
      titulo: 'Titulo',
      contenido: 'Contenido',
      pendienteSincronizar: false,
    );
    final copia = Nota.fromMap(nota.toMap());
    expect(copia.id, 1);
    expect(copia.titulo, 'Titulo');
    expect(copia.contenido, 'Contenido');
    expect(copia.pendienteSincronizar, false);
  });

  test('Una nota nueva queda pendiente de sincronizar', () {
    const nota = Nota(titulo: 'a', contenido: 'b');
    expect(nota.pendienteSincronizar, true);
    expect(nota.toMap()['pendiente_sincronizar'], 1);
  });

  test('Preferencias guarda y lee el nombre', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await Preferencias.leerNombre(), isNull);
    await Preferencias.guardarNombre('Erick');
    expect(await Preferencias.leerNombre(), 'Erick');
  });
}
