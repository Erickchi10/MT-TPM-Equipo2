import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura_gael/main.dart';

void main() {
  testWidgets('permite agregar una tarea', (tester) async {
    await tester.pumpWidget(const MiApp());
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.text('Pendientes: 0'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Estudiar Provider');
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Estudiar Provider'), findsOneWidget);
    expect(find.text('Pendientes: 1'), findsOneWidget);
  });
}
