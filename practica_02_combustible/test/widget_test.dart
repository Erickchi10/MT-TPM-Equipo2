import 'package:flutter_test/flutter_test.dart';

import 'package:practica_02_combustible/main.dart';

void main() {
  testWidgets('La calculadora de combustible se muestra correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Consumo de combustible'), findsOneWidget);
    expect(find.text('Kilómetros recorridos'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
  });
}
