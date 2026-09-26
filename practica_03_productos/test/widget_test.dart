import 'package:flutter_test/flutter_test.dart';

import 'package:practica_03_productos/main.dart';

void main() {
  testWidgets('El formulario de productos se muestra correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Registro de productos'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Agregar producto'), findsOneWidget);
  });
}

