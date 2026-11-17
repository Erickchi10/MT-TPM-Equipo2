
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_notificaciones_gael/main.dart';

void main() {
  testWidgets(
    'La Bitácora de Inspecciones muestra su pantalla principal',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pump();

      expect(
        find.text('Bitácora de Inspecciones'),
        findsOneWidget,
      );

      expect(
        find.text('Nueva inspección'),
        findsOneWidget,
      );
    },
  );
}
