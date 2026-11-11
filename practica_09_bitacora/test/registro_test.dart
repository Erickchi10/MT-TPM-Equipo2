import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_bitacora/models/registro_inspeccion.dart';
import 'package:practica_09_bitacora/services/camara_service.dart';
import 'package:practica_09_bitacora/services/sensores_service.dart';

void main() {
  final fecha = DateTime(2026, 11, 9, 7, 5, 3);

  test('fechaTexto usa el formato dd/MM/yyyy', () {
    final registro = RegistroInspeccion(
      rutaFoto: 'foto.jpg',
      fecha: fecha,
      acelerometro: null,
      giroscopio: null,
    );
    expect(registro.fechaTexto, '09/11/2026');
  });

  test('horaTexto usa HH:mm:ss con ceros a la izquierda', () {
    final registro = RegistroInspeccion(
      rutaFoto: 'foto.jpg',
      fecha: fecha,
      acelerometro: null,
      giroscopio: null,
    );
    expect(registro.horaTexto, '07:05:03');
  });

  test('textoLectura formatea X, Y y Z con dos decimales', () {
    const lectura = LecturaSensor(1.234, -5.0, 9.806);
    expect(
      RegistroInspeccion.textoLectura(lectura),
      'X: 1.23  Y: -5.00  Z: 9.81',
    );
  });

  test('una lectura nula se muestra como No disponible', () {
    expect(RegistroInspeccion.textoLectura(null), 'No disponible');
  });

  test('el registro conserva la ruta y las lecturas de los sensores', () {
    final registro = RegistroInspeccion(
      rutaFoto: 'ruta/foto.jpg',
      fecha: fecha,
      acelerometro: const LecturaSensor(0, 9.8, 0),
      giroscopio: const LecturaSensor(0.1, 0.2, 0.3),
    );
    expect(registro.rutaFoto, 'ruta/foto.jpg');
    expect(registro.acelerometroTexto, 'X: 0.00  Y: 9.80  Z: 0.00');
    expect(registro.giroscopioTexto, 'X: 0.10  Y: 0.20  Z: 0.30');
  });

  test('sin giroscopio el registro lo indica y conserva el acelerómetro', () {
    final registro = RegistroInspeccion(
      rutaFoto: 'foto.jpg',
      fecha: fecha,
      acelerometro: const LecturaSensor(1, 2, 3),
      giroscopio: null,
    );
    expect(registro.giroscopioTexto, 'No disponible');
    expect(registro.acelerometroTexto, 'X: 1.00  Y: 2.00  Z: 3.00');
  });

  test('una captura cancelada no trae imagen', () {
    const respuesta = RespuestaCamara(EstadoCamara.cancelado);
    expect(respuesta.estado, EstadoCamara.cancelado);
    expect(respuesta.imagen, isNull);
  });
}
