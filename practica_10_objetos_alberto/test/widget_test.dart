import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_10_objetos_alberto/models/objeto.dart';
import 'package:practica_10_objetos_alberto/models/resguardante.dart';
import 'package:practica_10_objetos_alberto/providers/objetos_provider.dart';
import 'package:practica_10_objetos_alberto/screens/form_objeto_screen.dart';
import 'package:practica_10_objetos_alberto/screens/objetos_screen.dart';
import 'package:practica_10_objetos_alberto/services/fotos_service.dart';
import 'package:practica_10_objetos_alberto/services/notificaciones_service.dart';
import 'package:practica_10_objetos_alberto/services/objetos_repositorio.dart';
import 'package:practica_10_objetos_alberto/services/resguardantes_api.dart';

class NotificacionesFalsas extends NotificacionesService {
  final titulos = <String>[];

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
    titulos.add(titulo);
  }
}

class FotosFalsas extends FotosService {
  @override
  Future<String> guardar(String rutaTemporal, String nombre) async =>
      rutaTemporal;
}

final fechaFija = DateTime(2026, 11, 16, 10, 0);

const usuariosJson =
    '[{"id":1,"name":"Leanne Graham","email":"leanne@mail.com"},'
    '{"id":2,"name":"Ervin Howell","email":"ervin@mail.com"}]';

const leanne = Resguardante(
  id: 1,
  nombre: 'Leanne Graham',
  correo: 'leanne@mail.com',
);

/// Reloj que avanza un minuto en cada llamada (ids distintos).
DateTime Function() relojQueAvanza() {
  var n = 0;
  return () => fechaFija.add(Duration(minutes: n++));
}

ObjetosProvider crear(NotificacionesService n, {http.Client? cliente}) =>
    ObjetosProvider(
      notificaciones: n,
      repositorio: ObjetosRepositorio(),
      api: ResguardantesApi(
        cliente:
            cliente ??
            MockClient((_) async => http.Response(usuariosJson, 200)),
      ),
      fotos: FotosFalsas(),
      reloj: relojQueAvanza(),
    );

Future<String> registrarUno(ObjetosProvider p, String nombre) => p.registrar(
  nombre: nombre,
  descripcion: 'Se encontró sobre una mesa',
  categoria: 'Electrónicos',
  lugar: 'Biblioteca',
  resguardante: leanne,
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Objeto toJson y fromJson conservan los datos y el estado', () {
    final o = Objeto(
      id: '1',
      nombre: 'Cartera negra',
      descripcion: 'Cartera con credencial',
      categoria: 'Documentos',
      lugar: 'Cafetería',
      resguardante: 'Leanne Graham',
      fecha: fechaFija,
      estado: EstadoObjeto.entregado,
      latitud: 20.37,
      longitud: -90.05,
      entregadoA: 'Juan Pérez',
      fechaEntrega: fechaFija,
    );
    final copia = Objeto.fromJson(o.toJson());
    expect(copia.nombre, 'Cartera negra');
    expect(copia.estado, EstadoObjeto.entregado);
    expect(copia.entregadoA, 'Juan Pérez');
    expect(copia.fechaEntrega, fechaFija);
    expect(copia.fotoRuta, isNull);
  });

  test('Datos dañados regresan una lista vacía', () async {
    SharedPreferences.setMockInitialValues({'objetos_alberto': 'no es json'});
    expect(await ObjetosRepositorio().cargar(), isEmpty);
  });

  test('Registrar guarda, persiste y notifica', () async {
    final n = NotificacionesFalsas();
    final p = crear(n);
    await p.cargar();
    final mensaje = await registrarUno(p, ' Memoria USB ');
    expect(mensaje, contains('registrado'));
    expect(p.objetos.single.nombre, 'Memoria USB');
    expect(p.objetos.single.estado, EstadoObjeto.encontrado);
    expect(n.titulos, ['Objeto registrado']);

    final otro = crear(NotificacionesFalsas());
    await otro.cargar();
    expect(otro.total, 1);
  });

  test('El filtro muestra solo el estado elegido', () async {
    final p = crear(NotificacionesFalsas());
    await p.cargar();
    await registrarUno(p, 'Memoria USB');
    await registrarUno(p, 'Sudadera');
    final sudadera = p.objetos.first;
    await p.cambiarEstado(sudadera.id, EstadoObjeto.reclamado);

    p.filtrar(EstadoObjeto.reclamado);
    expect(p.objetos.single.nombre, 'Sudadera');
    expect(p.contar(EstadoObjeto.encontrado), 1);

    p.filtrar(null);
    expect(p.objetos, hasLength(2));
  });

  test('Entregar guarda a quién y notifica', () async {
    final n = NotificacionesFalsas();
    final p = crear(n);
    await p.cargar();
    await registrarUno(p, 'Llaves');
    final id = p.objetos.single.id;

    await p.cambiarEstado(id, EstadoObjeto.reclamado);
    expect(n.titulos, hasLength(1));

    await p.cambiarEstado(
      id,
      EstadoObjeto.entregado,
      entregadoA: ' Juan Pérez ',
    );
    final o = p.buscar(id)!;
    expect(o.estado, EstadoObjeto.entregado);
    expect(o.entregadoA, 'Juan Pérez');
    expect(o.fechaEntrega, isNotNull);
    expect(n.titulos.last, 'Objeto entregado');
  });

  test('El personal de la API se carga y se guarda', () async {
    final p = crear(NotificacionesFalsas());
    await p.cargarResguardantes();
    expect(p.estadoResguardantes, EstadoResguardantes.ok);
    expect(p.resguardantes, hasLength(2));
    expect(await ObjetosRepositorio().cargarResguardantes(), hasLength(2));
  });

  test('Sin internet se usa la última lista guardada', () async {
    await crear(NotificacionesFalsas()).cargarResguardantes();
    final p = crear(
      NotificacionesFalsas(),
      cliente: MockClient((_) async => throw const SocketException('sin red')),
    );
    await p.cargarResguardantes();
    expect(p.estadoResguardantes, EstadoResguardantes.sinConexion);
    expect(p.resguardantes.first.nombre, 'Leanne Graham');
  });

  test('Error del servidor sin lista guardada queda en error', () async {
    final p = crear(
      NotificacionesFalsas(),
      cliente: MockClient((_) async => http.Response('falla', 500)),
    );
    await p.cargarResguardantes();
    expect(p.estadoResguardantes, EstadoResguardantes.error);
    expect(p.resguardantes, isEmpty);
  });

  testWidgets('Lista vacía muestra el mensaje y los filtros', (tester) async {
    final p = crear(NotificacionesFalsas());
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: p,
        child: const MaterialApp(home: ObjetosScreen()),
      ),
    );
    await p.cargar();
    await tester.pump();
    expect(find.textContaining('Aún no hay objetos'), findsOneWidget);
    expect(find.text('Todos (0)'), findsOneWidget);
    expect(find.text('Registrar objeto'), findsOneWidget);
  });

  testWidgets('El formulario valida los campos obligatorios', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final p = crear(NotificacionesFalsas());
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: p,
        child: const MaterialApp(home: FormObjetoScreen()),
      ),
    );
    await tester.tap(find.text('Guardar objeto'));
    await tester.pump();
    expect(find.text('Escribe el nombre del objeto'), findsOneWidget);
    expect(
      find.text('Describe el objeto (mínimo 10 caracteres)'),
      findsOneWidget,
    );
    expect(find.text('Elige una categoría'), findsOneWidget);
    expect(find.text('Escribe dónde se encontró'), findsOneWidget);
  });
}
