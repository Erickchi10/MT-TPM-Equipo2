import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_sensores_alberto/screens/sensores_screen.dart';
import 'package:practica_09_sensores_alberto/services/camara_service.dart';
import 'package:practica_09_sensores_alberto/services/sensores_service.dart';

class CamaraFalsa extends CamaraService {
  CamaraFalsa(this.respuesta);

  final ResultadoFoto respuesta;

  @override
  Future<ResultadoFoto> tomarFoto() async => respuesta;
}

class SensoresFalsos extends SensoresService {
  SensoresFalsos(this.acel, this.giro);

  final Stream<Lectura> acel;
  final Stream<Lectura> giro;

  @override
  Stream<Lectura> acelerometro() => acel;

  @override
  Stream<Lectura> giroscopio() => giro;
}

Widget pantalla(CamaraService camara, SensoresService sensores) => MaterialApp(
  home: SensoresScreen(camara: camara, sensores: sensores),
);

void main() {
  testWidgets('Muestra los valores del acelerómetro y del giroscopio', (
    tester,
  ) async {
    await tester.pumpWidget(
      pantalla(
        CamaraFalsa(const ResultadoFoto(EstadoFoto.cancelada)),
        SensoresFalsos(
          Stream.value((x: 0.12, y: 9.78, z: 0.5)),
          Stream.value((x: 1.5, y: -0.25, z: 0.0)),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('9.78'), findsOneWidget);
    expect(find.text('-0.25'), findsOneWidget);
  });

  testWidgets('Un sensor que falla muestra No disponible', (tester) async {
    await tester.pumpWidget(
      pantalla(
        CamaraFalsa(const ResultadoFoto(EstadoFoto.cancelada)),
        SensoresFalsos(
          const Stream.empty(),
          Stream.error(Exception('sin giroscopio')),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('No disponible en este dispositivo'), findsOneWidget);
    expect(find.text('Esperando lecturas...'), findsOneWidget);
  });

  testWidgets('Cancelar la cámara muestra un aviso', (tester) async {
    await tester.pumpWidget(
      pantalla(
        CamaraFalsa(const ResultadoFoto(EstadoFoto.cancelada)),
        SensoresFalsos(const Stream.empty(), const Stream.empty()),
      ),
    );
    await tester.tap(find.text('Tomar foto'));
    await tester.pump();
    expect(find.text('Captura cancelada'), findsOneWidget);
  });

  testWidgets('Permiso denegado avisa y la app sigue abierta', (tester) async {
    await tester.pumpWidget(
      pantalla(
        CamaraFalsa(const ResultadoFoto(EstadoFoto.sinPermiso)),
        SensoresFalsos(const Stream.empty(), const Stream.empty()),
      ),
    );
    await tester.tap(find.text('Tomar foto'));
    await tester.pump();
    expect(
      find.text('Permiso de cámara denegado. Actívalo en Ajustes.'),
      findsOneWidget,
    );
    expect(find.text('Tomar foto'), findsOneWidget);
  });
}
