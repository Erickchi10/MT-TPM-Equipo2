import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_09_bitacora_alberto/models/inspeccion.dart';
import 'package:practica_09_bitacora_alberto/providers/bitacora_provider.dart';
import 'package:practica_09_bitacora_alberto/screens/bitacora_screen.dart';
import 'package:practica_09_bitacora_alberto/services/camara_service.dart';
import 'package:practica_09_bitacora_alberto/services/formato.dart';
import 'package:practica_09_bitacora_alberto/services/fotos_service.dart';
import 'package:practica_09_bitacora_alberto/services/inspecciones_repositorio.dart';
import 'package:practica_09_bitacora_alberto/services/sensores_service.dart';
import 'package:practica_09_bitacora_alberto/widgets/tarjeta_evidencia.dart';

class CamaraFalsa extends CamaraService {
  CamaraFalsa(this.respuesta);

  final ResultadoFoto respuesta;

  @override
  Future<ResultadoFoto> tomarFoto() async => respuesta;
}

class SensoresFalsos extends SensoresService {
  SensoresFalsos({this.sinGiroscopio = false});

  final bool sinGiroscopio;

  @override
  Stream<Lectura> acelerometro() => Stream.value((x: 0.0, y: 9.78, z: 0.81));

  @override
  Stream<Lectura> giroscopio() => sinGiroscopio
      ? Stream.error(Exception('sin giroscopio'))
      : Stream.value((x: 0.1, y: -0.2, z: 0.0));
}

class FotosFalsas extends FotosService {
  @override
  Future<String> guardar(String rutaTemporal, String id) async => rutaTemporal;

  @override
  Future<void> borrar(String ruta) async {}
}

final fechaFija = DateTime(2026, 11, 15, 18, 5, 9);
const fotoOk = ResultadoFoto(EstadoFoto.ok, ruta: '/tmp/foto.jpg');

BitacoraProvider crear(ResultadoFoto foto, {bool sinGiroscopio = false}) =>
    BitacoraProvider(
      camara: CamaraFalsa(foto),
      sensores: SensoresFalsos(sinGiroscopio: sinGiroscopio),
      fotos: FotosFalsas(),
      repositorio: InspeccionesRepositorio(),
      reloj: () => fechaFija,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Inspeccion toJson y fromJson conservan los datos', () {
    final i = Inspeccion(
      id: '1',
      titulo: 'Extintor',
      fotoRuta: '/f.jpg',
      fecha: fechaFija,
      acelerometro: (x: 0.0, y: 9.78, z: 0.81),
    );
    final copia = Inspeccion.fromJson(i.toJson());
    expect(copia.titulo, 'Extintor');
    expect(copia.fecha, fechaFija);
    expect(copia.acelerometro?.y, 9.78);
    expect(copia.giroscopio, isNull);
  });

  test('Formato de fecha, hora y valores', () {
    expect(Formato.fecha(fechaFija), '15/11/2026');
    expect(Formato.hora(fechaFija), '18:05:09');
    expect(Formato.valor(-0.256), '-0.26');
  });

  test('El repositorio guarda y vuelve a cargar', () async {
    final repo = InspeccionesRepositorio();
    await repo.guardar([
      Inspeccion(
        id: '1',
        titulo: 'Tablero',
        fotoRuta: '/f.jpg',
        fecha: fechaFija,
      ),
    ]);
    final lista = await repo.cargar();
    expect(lista.single.titulo, 'Tablero');
  });

  test('Datos dañados regresan una lista vacía', () async {
    SharedPreferences.setMockInitialValues({
      'inspecciones_alberto': 'esto no es json',
    });
    expect(await InspeccionesRepositorio().cargar(), isEmpty);
  });

  test('Registrar guarda foto, fecha, hora y sensores', () async {
    final b = crear(fotoOk);
    await b.cargar();
    final r = await b.registrar('  Extintor pasillo B ');
    expect(r.ok, isTrue);
    final i = b.inspecciones.single;
    expect(i.titulo, 'Extintor pasillo B');
    expect(i.fecha, fechaFija);
    expect(i.acelerometro?.y, 9.78);
    expect(i.giroscopio?.y, -0.2);

    // Otro provider lee lo guardado: simula cerrar y abrir la app.
    final otra = crear(fotoOk);
    await otra.cargar();
    expect(otra.inspecciones, hasLength(1));
  });

  test('Cancelar la cámara no guarda nada', () async {
    final b = crear(const ResultadoFoto(EstadoFoto.cancelada));
    await b.cargar();
    final r = await b.registrar('Tablero');
    expect(r.ok, isFalse);
    expect(r.mensaje, contains('cancelada'));
    expect(b.inspecciones, isEmpty);
  });

  test('Permiso denegado avisa sin guardar', () async {
    final b = crear(const ResultadoFoto(EstadoFoto.sinPermiso));
    await b.cargar();
    final r = await b.registrar('Tablero');
    expect(r.ok, isFalse);
    expect(r.mensaje, contains('Permiso'));
    expect(b.inspecciones, isEmpty);
  });

  test('El nombre vacío no se acepta', () async {
    final b = crear(fotoOk);
    await b.cargar();
    final r = await b.registrar('   ');
    expect(r.ok, isFalse);
    expect(b.inspecciones, isEmpty);
  });

  test('Sin giroscopio se guarda como no disponible', () async {
    final b = crear(fotoOk, sinGiroscopio: true);
    await b.cargar();
    await b.registrar('Puerta de emergencia');
    final i = b.inspecciones.single;
    expect(i.acelerometro, isNotNull);
    expect(i.giroscopio, isNull);
  });

  testWidgets('Lista vacía muestra el mensaje inicial', (tester) async {
    final b = crear(fotoOk);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: b,
        child: const MaterialApp(home: BitacoraScreen()),
      ),
    );
    await b.cargar();
    await tester.pump();
    expect(find.textContaining('Aún no hay inspecciones'), findsOneWidget);
    expect(find.text('Nueva inspección'), findsOneWidget);
  });

  testWidgets('La tarjeta de evidencia muestra fecha, hora y sensores', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TarjetaEvidencia(
              inspeccion: Inspeccion(
                id: '1',
                titulo: 'Tablero eléctrico',
                fotoRuta: 'no_existe.jpg',
                fecha: fechaFija,
                acelerometro: (x: 0.0, y: 9.78, z: 0.81),
              ),
              onEliminar: () {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('Tablero eléctrico'), findsOneWidget);
    expect(find.text('15/11/2026'), findsOneWidget);
    expect(find.text('18:05:09'), findsOneWidget);
    expect(find.text('Y: 9.78'), findsOneWidget);
    expect(find.text('No disponible'), findsOneWidget);
  });
}
