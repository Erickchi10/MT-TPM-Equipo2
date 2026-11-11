import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_bitacora/models/registro_inspeccion.dart';
import 'package:practica_09_bitacora/services/bitacora_service.dart';
import 'package:practica_09_bitacora/services/sensores_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fecha = DateTime(2026, 11, 9, 7, 5, 3);

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('toMap y fromMap conservan los datos de una inspección', () {
    final original = RegistroInspeccion(
      rutaFoto: 'ruta/foto.jpg',
      fecha: fecha,
      acelerometro: const LecturaSensor(0.5, 9.8, -1.25),
      giroscopio: null,
    );
    final copia = RegistroInspeccion.fromMap(original.toMap());
    expect(copia.rutaFoto, 'ruta/foto.jpg');
    expect(copia.fecha, fecha);
    expect(copia.acelerometroTexto, 'X: 0.50  Y: 9.80  Z: -1.25');
    expect(copia.giroscopioTexto, 'No disponible');
  });

  test('sin datos guardados, cargar devuelve una lista vacía', () async {
    expect(await BitacoraService().cargar(), isEmpty);
  });

  test('se guardan y recuperan dos inspecciones', () async {
    final servicio = BitacoraService();
    await servicio.guardar([
      RegistroInspeccion(
        rutaFoto: 'a.jpg',
        fecha: fecha,
        acelerometro: const LecturaSensor(0, 9.8, 0),
        giroscopio: null,
      ),
      RegistroInspeccion(
        rutaFoto: 'b.jpg',
        fecha: fecha,
        acelerometro: const LecturaSensor(1, 2, 3),
        giroscopio: const LecturaSensor(0.1, 0.2, 0.3),
      ),
    ]);
    final cargados = await servicio.cargar();
    expect(cargados.length, 2);
    expect(cargados[0].rutaFoto, 'a.jpg');
    expect(cargados[1].giroscopioTexto, 'X: 0.10  Y: 0.20  Z: 0.30');
  });

  test('datos dañados devuelven una lista vacía sin fallar', () async {
    SharedPreferences.setMockInitialValues({
      'bitacora_inspecciones': 'esto no es json',
    });
    expect(await BitacoraService().cargar(), isEmpty);
  });
}
