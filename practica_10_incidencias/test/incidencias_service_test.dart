import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_incidencias/models/incidencia.dart';
import 'package:practica_10_incidencias/services/incidencias_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Incidencia crear(String id) => Incidencia(
    id: id,
    titulo: 'Reporte $id',
    descripcion: 'Descripción del reporte $id',
    categoria: 'Otro',
    fecha: DateTime(2026, 11, 12, 10, 30),
  );

  test('sin datos guardados devuelve una lista vacía', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await IncidenciasService().cargar(), isEmpty);
  });

  test('guarda y recupera los reportes', () async {
    SharedPreferences.setMockInitialValues({});
    final servicio = IncidenciasService();
    await servicio.guardar([crear('1'), crear('2')]);
    final lista = await servicio.cargar();
    expect(lista.length, 2);
    expect(lista.first.titulo, 'Reporte 1');
  });

  test('datos dañados devuelven una lista vacía sin fallar', () async {
    SharedPreferences.setMockInitialValues({
      'incidencias_guardadas': 'esto no es json',
    });
    expect(await IncidenciasService().cargar(), isEmpty);
  });
}
