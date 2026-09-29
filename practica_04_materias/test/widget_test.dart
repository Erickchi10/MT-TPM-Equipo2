import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_04_materias/screens/inicio_materias_page.dart';

void main() {
  testWidgets('Muestra el catálogo de materias y navega al detalle', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: InicioMateriasPage()));

    expect(find.text('Catálogo de Materias'), findsOneWidget);
    expect(find.text('Base de Datos'), findsOneWidget);

    await tester.tap(find.text('Base de Datos'));
    await tester.pumpAndSettle();

    expect(find.text('Diseño y administración de bases de datos relacionales.'), findsOneWidget);
  });
}

