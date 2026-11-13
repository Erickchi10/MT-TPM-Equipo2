import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:practica_05_api_alberto/main.dart';

void main() {
  testWidgets('Muestra el indicador de carga al iniciar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UsuariosPage()));
    expect(find.text('Usuarios REST'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('Usuario.fromJson convierte el JSON', () {
    final u = Usuario.fromJson({
      'id': 1,
      'name': 'Leanne Graham',
      'email': 'Sincere@april.biz',
    });
    expect(u.id, 1);
    expect(u.nombre, 'Leanne Graham');
    expect(u.correo, 'Sincere@april.biz');
  });
}