import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_incidencias/models/incidencia.dart';

void main() {
  test('toMap y fromMap conservan los datos', () {
    final original = Incidencia(
      id: '1',
      titulo: 'Bache',
      descripcion: 'Bache grande en la calle',
      categoria: 'Bache',
      fecha: DateTime(2026, 11, 12, 15, 8),
      fotoPath: '/ruta/foto.jpg',
      latitud: 20.344198,
      longitud: -90.043764,
    );
    final copia = Incidencia.fromMap(original.toMap());
    expect(copia.id, '1');
    expect(copia.titulo, 'Bache');
    expect(copia.categoria, 'Bache');
    expect(copia.fecha, DateTime(2026, 11, 12, 15, 8));
    expect(copia.fotoPath, '/ruta/foto.jpg');
    expect(copia.latitud, 20.344198);
    expect(copia.longitud, -90.043764);
  });

  test('sin coordenadas muestra "Sin ubicación"', () {
    final i = Incidencia(
      id: '2',
      titulo: 'Basura',
      descripcion: 'Basura acumulada',
      categoria: 'Basura',
      fecha: DateTime(2026, 11, 12),
    );
    expect(i.ubicacionTexto, 'Sin ubicación');
    expect(i.fotoPath, isNull);
  });

  test('fecha y hora se muestran con ceros a la izquierda', () {
    final i = Incidencia(
      id: '3',
      titulo: 'Luz',
      descripcion: 'Lámpara apagada',
      categoria: 'Alumbrado',
      fecha: DateTime(2026, 11, 5, 9, 7),
    );
    expect(i.fechaTexto, '05/11/2026');
    expect(i.horaTexto, '09:07');
  });
}
