import 'package:flutter_test/flutter_test.dart';

import 'package:practica_02_propina/main.dart';

void main() {
  testWidgets('La calculadora de propina se muestra correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Calculadora de propina'), findsOneWidget);
    expect(find.text('Consumo'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
  });
}
