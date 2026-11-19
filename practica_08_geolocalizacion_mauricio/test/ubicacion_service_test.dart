import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion_mauricio/services/ubicacion_service.dart';

void main() {
  group('Pruebas del servicio de ubicación', () {
    final servicio = UbicacionService();

    test('La distancia entre dos coordenadas iguales debe ser cero', () {
      final distancia = servicio.calcularDistancia(20.0, -90.0, 20.0, -90.0);

      expect(distancia, 0.0);
    });

    test('La distancia entre dos puntos diferentes debe ser positiva', () {
      final distancia = servicio.calcularDistancia(20.0, -90.0, 20.1, -90.0);

      expect(distancia, greaterThan(0));
    });

    test('La distancia debe ser la misma en ambas direcciones', () {
      final distancia1 = servicio.calcularDistancia(20.0, -90.0, 20.1, -90.0);

      final distancia2 = servicio.calcularDistancia(20.1, -90.0, 20.0, -90.0);

      expect(distancia1, closeTo(distancia2, 0.01));
    });
  });
}
