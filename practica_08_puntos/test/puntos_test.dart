import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_puntos/models/punto.dart';
import 'package:practica_08_puntos/services/puntos_service.dart';
import 'package:practica_08_puntos/services/ubicacion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Punto', () {
    test('toMap y fromMap conservan los datos', () {
      const original = Punto(
        id: '1',
        nombre: 'Tecnológico',
        latitud: 20.370855,
        longitud: -90.050467,
      );
      final copia = Punto.fromMap(original.toMap());
      expect(copia.id, '1');
      expect(copia.nombre, 'Tecnológico');
      expect(copia.latitud, 20.370855);
      expect(copia.longitud, -90.050467);
    });
  });

  group('PuntosService', () {
    test('sin datos guardados devuelve una lista vacía', () async {
      expect(await PuntosService().cargar(), isEmpty);
    });

    test('guarda y recupera tres puntos con nombre', () async {
      final servicio = PuntosService();
      const puntos = [
        Punto(
          id: '1',
          nombre: 'Tecnológico',
          latitud: 20.3709,
          longitud: -90.0505,
        ),
        Punto(id: '2', nombre: 'Centro', latitud: 20.3694, longitud: -90.0510),
        Punto(id: '3', nombre: 'Tepakán', latitud: 20.3500, longitud: -90.0400),
      ];
      await servicio.guardar(puntos);

      final cargados = await servicio.cargar();
      expect(cargados.length, 3);
      expect(cargados.map((p) => p.nombre), [
        'Tecnológico',
        'Centro',
        'Tepakán',
      ]);
      expect(cargados[2].latitud, 20.35);
    });

    test('datos dañados devuelven una lista vacía sin fallar', () async {
      SharedPreferences.setMockInitialValues({'puntos_interes': 'no es json'});
      expect(await PuntosService().cargar(), isEmpty);
    });
  });

  group('UbicacionService.distanciaMetros', () {
    final servicio = UbicacionService();

    test('el mismo punto está a 0 metros', () {
      expect(servicio.distanciaMetros(20.37, -90.05, 20.37, -90.05), 0);
    });

    test('un grado de latitud son unos 111 km', () {
      final d = servicio.distanciaMetros(20, -90, 21, -90);
      expect(d, inInclusiveRange(110000, 112000));
    });

    test('la distancia es la misma en ambos sentidos', () {
      final ida = servicio.distanciaMetros(20.37, -90.05, 20.97, -89.59);
      final vuelta = servicio.distanciaMetros(20.97, -89.59, 20.37, -90.05);
      expect((ida - vuelta).abs(), lessThan(1));
    });
  });
}
