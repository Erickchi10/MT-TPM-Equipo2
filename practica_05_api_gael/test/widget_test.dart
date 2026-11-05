import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practica_05_api/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
