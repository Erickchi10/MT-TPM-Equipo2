import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_mantenimiento/models/orden.dart';

void main() {
  Orden crear({EstadoOrden estado = EstadoOrden.pendiente}) => Orden(
    id: '1',
    equipo: 'Computadora',
    descripcion: 'Actualización del sistema',
    prioridad: 'Media',
    tecnico: 'Ervin Howell',
    fecha: DateTime(2026, 11, 12, 23, 26),
    estado: estado,
    fotoPath: '/ruta/foto.jpg',
  );

  test('toMap y fromMap conservan los datos', () {
    final copia = Orden.fromMap(crear(estado: EstadoOrden.enProceso).toMap());
    expect(copia.id, '1');
    expect(copia.equipo, 'Computadora');
    expect(copia.prioridad, 'Media');
    expect(copia.tecnico, 'Ervin Howell');
    expect(copia.estado, EstadoOrden.enProceso);
    expect(copia.fecha, DateTime(2026, 11, 12, 23, 26));
    expect(copia.fotoPath, '/ruta/foto.jpg');
  });

  test('copiarCon cambia solo el estado', () {
    final terminada = crear().copiarCon(estado: EstadoOrden.terminada);
    expect(terminada.estado, EstadoOrden.terminada);
    expect(terminada.equipo, 'Computadora');
    expect(terminada.tecnico, 'Ervin Howell');
  });

  test('un estado desconocido se toma como pendiente', () {
    final mapa = crear().toMap()..['estado'] = 'otro';
    expect(Orden.fromMap(mapa).estado, EstadoOrden.pendiente);
  });

  test('textos de estado y de fecha y hora', () {
    expect(EstadoOrden.pendiente.texto, 'Pendiente');
    expect(EstadoOrden.enProceso.texto, 'En proceso');
    expect(EstadoOrden.terminada.texto, 'Terminada');
    final o = Orden(
      id: '2',
      equipo: 'Aire',
      descripcion: 'No enfría bien',
      prioridad: 'Alta',
      tecnico: 'Leanne Graham',
      fecha: DateTime(2026, 11, 5, 9, 7),
    );
    expect(o.fechaTexto, '05/11/2026');
    expect(o.horaTexto, '09:07');
  });
}
