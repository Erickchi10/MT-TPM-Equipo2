import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api/main.dart';

void main() {
  testWidgets('Muestra el titulo y el indicador de carga', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UsuariosPage()));

    expect(find.text('Usuarios REST'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('Usuario.fromJson convierte el JSON a objeto Dart', () {
    final usuario = Usuario.fromJson({
      'id': 1,
      'name': 'Leanne Graham',
      'email': 'Sincere@april.biz',
    });

    expect(usuario.id, 1);
    expect(usuario.nombre, 'Leanne Graham');
    expect(usuario.correo, 'Sincere@april.biz');
  });
}
