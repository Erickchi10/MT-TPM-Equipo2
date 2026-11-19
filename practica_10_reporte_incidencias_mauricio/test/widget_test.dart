import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_reporte_incidencias_mauricio/main.dart';

void main() {
  testWidgets('La aplicación inicia y muestra la pantalla principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ReporteIncidenciasApp());

    expect(find.text('Reporte de Incidencias'), findsOneWidget);
    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Accesos rápidos'), findsOneWidget);

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Nuevo'), findsOneWidget);
    expect(find.text('Reportes'), findsOneWidget);
    expect(find.text('Servicios'), findsOneWidget);
  });
}
