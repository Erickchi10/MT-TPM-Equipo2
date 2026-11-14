import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_06_notas_alberto/preferencias.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Sin nombre guardado devuelve Invitado', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await leerNombre(), 'Invitado');
  });

  test('Guarda y lee el nombre del usuario', () async {
    SharedPreferences.setMockInitialValues({});
    await guardarNombre('Alberto');
    expect(await leerNombre(), 'Alberto');
  });
}
