
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:practica_08_geolocalizacion/main.dart';

void main() {
  testWidgets('La aplicación GPS inicia correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
