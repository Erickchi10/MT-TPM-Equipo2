import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:practica_09_multimedia_sensores_mauricio/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('La aplicación Bitácora inicia correctamente', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(const BitacoraApp());

    // Se permite que la interfaz se construya sin esperar
    // a que terminen las animaciones continuas.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Bitácora de Inspección'), findsOneWidget);
    expect(find.text('Captura de imágenes'), findsOneWidget);
    expect(find.text('Sensores del dispositivo'), findsOneWidget);
    expect(find.text('Tomar fotografía'), findsOneWidget);
    expect(find.text('Evidencias registradas'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
