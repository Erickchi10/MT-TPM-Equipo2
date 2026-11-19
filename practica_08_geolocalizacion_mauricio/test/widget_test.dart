import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion_mauricio/main.dart';

void main() {
  testWidgets('La aplicación GeoPoints inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GeoPointsApp());

    expect(find.text('GeoPoints'), findsOneWidget);
    expect(find.text('Mi ubicación actual'), findsOneWidget);
    expect(find.text('Mis puntos de interés'), findsOneWidget);
    expect(find.text('Obtener ubicación'), findsOneWidget);
  });
}
