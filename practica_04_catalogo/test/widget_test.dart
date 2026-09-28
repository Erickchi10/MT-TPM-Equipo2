import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_04_catalogo/screens/inicio_page.dart';

void main() {
  testWidgets('Muestra el catálogo y navega al detalle', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: InicioPage()));

    expect(find.text('Catálogo'), findsOneWidget);
    expect(find.text('Teclado'), findsOneWidget);

    await tester.tap(find.text('Teclado'));
    await tester.pumpAndSettle();

    expect(find.text('Teclado para computadora'), findsOneWidget);
  });
}

