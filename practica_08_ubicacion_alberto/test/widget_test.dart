import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_ubicacion_alberto/main.dart';

void main() {
  testWidgets('Pantalla inicial sin ubicación', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UbicacionPage()));
    expect(find.text('Mi ubicación'), findsOneWidget);
    expect(find.text('Sin ubicación'), findsOneWidget);
    expect(find.text('Obtener ubicación'), findsOneWidget);
  });

  testWidgets('Abrir en mapa está desactivado sin ubicación', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UbicacionPage()));
    final boton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Abrir en mapa'),
        matching: find.byWidgetPredicate((w) => w is OutlinedButton),
      ),
    );
    expect(boton.onPressed, isNull);
  });
}
