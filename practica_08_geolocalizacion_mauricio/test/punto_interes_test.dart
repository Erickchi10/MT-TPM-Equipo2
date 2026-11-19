import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion_mauricio/models/punto_interes.dart';

void main() {
  group('Pruebas del modelo PuntoInteres', () {
    test('Debe crear un punto de interés correctamente', () {
      const punto = PuntoInteres(
        nombre: 'ITESCAM',
        latitud: 20.383,
        longitud: -90.05,
      );

      expect(punto.nombre, 'ITESCAM');
      expect(punto.latitud, 20.383);
      expect(punto.longitud, -90.05);
    });

    test('Debe convertir un punto a Map', () {
      const punto = PuntoInteres(
        nombre: 'Parque Principal',
        latitud: 20.0,
        longitud: -90.0,
      );

      final mapa = punto.toMap();

      expect(mapa['nombre'], 'Parque Principal');
      expect(mapa['latitud'], 20.0);
      expect(mapa['longitud'], -90.0);
    });

    test('Debe recuperar un punto desde Map', () {
      final punto = PuntoInteres.fromMap({
        'nombre': 'Universidad',
        'latitud': 20,
        'longitud': -90,
      });

      expect(punto.nombre, 'Universidad');
      expect(punto.latitud, 20.0);
      expect(punto.longitud, -90.0);
    });
  });
}
