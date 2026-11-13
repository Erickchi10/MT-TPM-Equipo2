import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_mantenimiento/models/orden.dart';
import 'package:practica_10_mantenimiento/services/ordenes_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Orden crear(String id) => Orden(
    id: id,
    equipo: 'Equipo $id',
    descripcion: 'Descripción de la orden $id',
    prioridad: 'Baja',
    tecnico: 'Técnico $id',
    fecha: DateTime(2026, 11, 12, 10, 30),
  );

  test('sin datos guardados devuelve una lista vacía', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await OrdenesService().cargar(), isEmpty);
  });

  test('guarda y recupera las órdenes', () async {
    SharedPreferences.setMockInitialValues({});
    final servicio = OrdenesService();
    await servicio.guardar([crear('1'), crear('2')]);
    final lista = await servicio.cargar();
    expect(lista.length, 2);
    expect(lista.first.equipo, 'Equipo 1');
  });

  test('se conserva el estado de una orden actualizada', () async {
    SharedPreferences.setMockInitialValues({});
    final servicio = OrdenesService();
    await servicio.guardar([
      crear('1').copiarCon(estado: EstadoOrden.terminada),
    ]);
    expect((await servicio.cargar()).first.estado, EstadoOrden.terminada);
  });

  test('datos dañados devuelven una lista vacía sin fallar', () async {
    SharedPreferences.setMockInitialValues({
      'ordenes_guardadas': 'esto no es json',
    });
    expect(await OrdenesService().cargar(), isEmpty);
  });
}
