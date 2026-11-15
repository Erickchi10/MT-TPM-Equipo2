import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practica_07_arquitectura_alberto/main.dart';
import 'package:practica_07_arquitectura_alberto/models/registro.dart';
import 'package:practica_07_arquitectura_alberto/providers/contador_provider.dart';
import 'package:practica_07_arquitectura_alberto/services/formato_service.dart';

void main() {
  group('ContadorProvider', () {
    test('Empieza en cero y sin historial', () {
      final p = ContadorProvider();
      expect(p.valor, 0);
      expect(p.historial, isEmpty);
    });

    test('Incrementar suma 1 y lo registra', () {
      final p = ContadorProvider()..incrementar();
      expect(p.valor, 1);
      expect(p.historial.first.tipo, TipoAccion.incremento);
      expect(p.historial.first.valorResultante, 1);
    });

    test('No baja de cero', () {
      final p = ContadorProvider()..decrementar();
      expect(p.valor, 0);
      expect(p.historial, isEmpty);
    });

    test('Reiniciar deja el valor en cero', () {
      final p = ContadorProvider()
        ..incrementar()
        ..incrementar()
        ..reiniciar();
      expect(p.valor, 0);
      expect(p.historial.length, 1);
      expect(p.historial.first.tipo, TipoAccion.reinicio);
    });

    test('Avisa a los widgets cuando cambia', () {
      final p = ContadorProvider();
      var avisos = 0;
      p.addListener(() => avisos++);
      p.incrementar();
      expect(avisos, 1);
    });
  });

  test('FormatoService da formato con intl', () {
    expect(FormatoService.numero(1500), '1,500');
    expect(
      FormatoService.fechaHora(DateTime(2026, 11, 14, 9, 5, 7)),
      '14/11/2026 09:05:07',
    );
  });

  testWidgets('Sumar actualiza el valor y el historial', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ContadorProvider(),
        child: const AppContador(),
      ),
    );
    expect(find.text('Aún no hay movimientos'), findsOneWidget);
    await tester.tap(find.text('Sumar'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Sumó 1'), findsOneWidget);
  });
}
