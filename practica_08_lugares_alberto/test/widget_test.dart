import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_08_lugares_alberto/models/lugar.dart';
import 'package:practica_08_lugares_alberto/providers/lugares_provider.dart';
import 'package:practica_08_lugares_alberto/screens/form_lugar.dart';
import 'package:practica_08_lugares_alberto/services/coordenadas.dart';
import 'package:practica_08_lugares_alberto/services/ubicacion_service.dart';

class GpsFalso extends UbicacionService {
  GpsFalso(this.resultado);
  final ResultadoUbicacion resultado;
  @override
  Future<ResultadoUbicacion> obtener() async => resultado;
}

const calkini = ResultadoUbicacion(
  EstadoUbicacion.ok,
  latitud: 20.370855,
  longitud: -90.050467,
  precision: 5,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Lugar toJson y fromJson conservan los datos', () {
    final l = Lugar(
      id: '1',
      nombre: 'ITESCAM',
      latitud: 20.37,
      longitud: -90.05,
      creado: DateTime(2026, 11, 15),
    );
    final c = Lugar.fromJson(l.toJson());
    expect(c.nombre, 'ITESCAM');
    expect(c.latitud, 20.37);
    expect(c.longitud, -90.05);
    expect(c.creado, DateTime(2026, 11, 15));
  });

  test('Lee coordenadas pegadas de Google Maps', () {
    final c = Coordenadas.leer('20.370855, -90.050467');
    expect(c!.lat, 20.370855);
    expect(c.lng, -90.050467);
    expect(Coordenadas.leer('hola'), isNull);
    expect(Coordenadas.leer('95, 10'), isNull); // latitud fuera de rango
  });

  test('Formato de distancia en metros y kilómetros', () {
    expect(Coordenadas.distancia(850.4), '850 m');
    expect(Coordenadas.distancia(12345), '12.3 km');
  });

  test('distanceBetween: un grado de latitud son unos 111 km', () {
    final d = UbicacionService.distancia(20, -90, 21, -90);
    expect(d, greaterThan(110000));
    expect(d, lessThan(112000));
    expect(UbicacionService.distancia(20, -90, 20, -90), 0);
  });

  test('Guarda 3 lugares y los ordena por distancia', () async {
    final p = LugaresProvider(ubicacion: GpsFalso(calkini));
    await p.cargar();
    await p.obtenerUbicacion();
    await p.agregar('Campeche', 19.8301, -90.5349);
    await p.agregar('Hecelchakan', 20.1786, -90.1325);
    expect(await p.agregarAqui('Aqui'), isNull);
    expect(p.lugares.map((l) => l.nombre), ['Aqui', 'Hecelchakan', 'Campeche']);
    expect(p.distanciaA(p.lugares.first), 0);
  });

  test('No permite nombres repetidos ni vacíos', () async {
    final p = LugaresProvider(ubicacion: GpsFalso(calkini));
    await p.cargar();
    await p.agregar('Parque', 20.37, -90.05);
    expect(await p.agregar('parque', 20.0, -90.0), isNotNull);
    expect(await p.agregar('   ', 20.0, -90.0), 'Escribe un nombre');
  });

  test('Sin permiso no guarda la ubicación actual', () async {
    final p = LugaresProvider(
      ubicacion: GpsFalso(
        const ResultadoUbicacion(EstadoUbicacion.permisoNegado),
      ),
    );
    await p.obtenerUbicacion();
    expect(p.mensaje, 'Permiso de ubicación negado');
    expect(await p.agregarAqui('Casa'), 'Primero obtén tu ubicación');
  });

  test('Los lugares se conservan al volver a abrir', () async {
    final p1 = LugaresProvider(ubicacion: GpsFalso(calkini));
    await p1.cargar();
    await p1.agregar('ITESCAM', 20.37, -90.05);
    final p2 = LugaresProvider(ubicacion: GpsFalso(calkini));
    await p2.cargar();
    expect(p2.lugares.single.nombre, 'ITESCAM');
  });

  testWidgets('El formulario valida nombre y coordenadas', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LugaresProvider(ubicacion: GpsFalso(calkini)),
        child: const MaterialApp(home: FormLugar()),
      ),
    );
    await tester.tap(find.text('Guardar lugar'));
    await tester.pump();
    expect(find.text('Escribe un nombre'), findsOneWidget);

    await tester.tap(find.text('Coordenadas'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).first, 'Parque');
    await tester.enterText(find.byType(TextFormField).last, 'abc');
    await tester.tap(find.text('Guardar lugar'));
    await tester.pump();
    expect(
      find.text('Formato: latitud, longitud (ej. 20.37, -90.05)'),
      findsOneWidget,
    );
  });
}
