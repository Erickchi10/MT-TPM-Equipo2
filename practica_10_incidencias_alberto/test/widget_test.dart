import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_10_incidencias_alberto/models/incidencia.dart';
import 'package:practica_10_incidencias_alberto/providers/incidencias_provider.dart';
import 'package:practica_10_incidencias_alberto/screens/form_incidencia_screen.dart';
import 'package:practica_10_incidencias_alberto/screens/incidencias_screen.dart';
import 'package:practica_10_incidencias_alberto/services/avisos_api.dart';
import 'package:practica_10_incidencias_alberto/services/fotos_service.dart';
import 'package:practica_10_incidencias_alberto/services/incidencias_repositorio.dart';
import 'package:practica_10_incidencias_alberto/services/notificaciones_service.dart';

class NotificacionesFalsas extends NotificacionesService {
  int mostradas = 0;

  @override
  Future<void> iniciar() async {}

  @override
  Future<bool> pedirPermiso() async => true;

  @override
  Future<void> mostrar({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    mostradas++;
  }
}

class FotosFalsas extends FotosService {
  @override
  Future<String> guardar(String rutaTemporal, String nombre) async =>
      rutaTemporal;
}

final fechaFija = DateTime(2026, 11, 16, 9, 30);

const avisosJson =
    '[{"userId":1,"id":1,"title":"Aviso uno","body":"Texto uno"},'
    '{"userId":1,"id":2,"title":"Aviso dos","body":"Texto dos"}]';

IncidenciasProvider crear(NotificacionesService n, {http.Client? cliente}) =>
    IncidenciasProvider(
      notificaciones: n,
      repositorio: IncidenciasRepositorio(),
      api: AvisosApi(
        cliente: cliente ?? MockClient((_) async => http.Response('[]', 200)),
      ),
      fotos: FotosFalsas(),
      reloj: () => fechaFija,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Incidencia toJson y fromJson conservan los datos', () {
    final i = Incidencia(
      id: '1',
      titulo: 'Fuga de agua',
      descripcion: 'Gotea el lavabo del baño',
      categoria: 'Infraestructura',
      fecha: fechaFija,
      latitud: 20.37,
      longitud: -90.05,
    );
    final copia = Incidencia.fromJson(i.toJson());
    expect(copia.titulo, 'Fuga de agua');
    expect(copia.fecha, fechaFija);
    expect(copia.latitud, 20.37);
    expect(copia.fotoRuta, isNull);
  });

  test('Datos dañados regresan una lista vacía', () async {
    SharedPreferences.setMockInitialValues({
      'incidencias_alberto': 'esto no es json',
    });
    expect(await IncidenciasRepositorio().cargar(), isEmpty);
  });

  test('Guardar agrega, persiste y notifica', () async {
    final n = NotificacionesFalsas();
    final p = crear(n);
    await p.cargar();
    final mensaje = await p.guardar(
      titulo: ' Lámpara fundida ',
      descripcion: 'No enciende la lámpara del pasillo',
      categoria: 'Infraestructura',
      latitud: 20.37,
      longitud: -90.05,
    );
    expect(mensaje, contains('guardado'));
    expect(p.incidencias.single.titulo, 'Lámpara fundida');
    expect(n.mostradas, 1);

    final otro = crear(NotificacionesFalsas());
    await otro.cargar();
    expect(otro.incidencias, hasLength(1));
  });

  test('Avisos de la API se cargan', () async {
    final p = crear(
      NotificacionesFalsas(),
      cliente: MockClient((_) async => http.Response(avisosJson, 200)),
    );
    await p.cargarAvisos();
    expect(p.estadoAvisos, EstadoAvisos.ok);
    expect(p.avisos, hasLength(2));
    expect(p.avisos.first.titulo, 'Aviso uno');
  });

  test('Sin internet los avisos quedan en sinConexion', () async {
    final p = crear(
      NotificacionesFalsas(),
      cliente: MockClient((_) async => throw const SocketException('sin red')),
    );
    await p.cargarAvisos();
    expect(p.estadoAvisos, EstadoAvisos.sinConexion);
  });

  test('Un error del servidor deja los avisos en error', () async {
    final p = crear(
      NotificacionesFalsas(),
      cliente: MockClient((_) async => http.Response('falla', 500)),
    );
    await p.cargarAvisos();
    expect(p.estadoAvisos, EstadoAvisos.error);
  });

  testWidgets('Lista vacía muestra el mensaje inicial', (tester) async {
    final p = crear(NotificacionesFalsas());
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: p,
        child: const MaterialApp(home: IncidenciasScreen()),
      ),
    );
    await p.cargar();
    await tester.pump();
    expect(find.textContaining('Aún no hay reportes'), findsOneWidget);
    expect(find.text('Nuevo reporte'), findsOneWidget);
  });

  testWidgets('El formulario valida los campos obligatorios', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final p = crear(NotificacionesFalsas());
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: p,
        child: const MaterialApp(home: FormIncidenciaScreen()),
      ),
    );
    await tester.tap(find.text('Guardar reporte'));
    await tester.pump();
    expect(find.text('Escribe un título'), findsOneWidget);
    expect(
      find.text('Describe el problema (mínimo 10 caracteres)'),
      findsOneWidget,
    );
    expect(find.text('Elige una categoría'), findsOneWidget);
  });
}
