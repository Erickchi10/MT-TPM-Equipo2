import 'package:flutter_test/flutter_test.dart';

import 'package:practica_03_registro/main.dart';

void main() {
  testWidgets('El formulario de registro se muestra correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Registro de estudiantes'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
  });
}
