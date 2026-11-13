import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_05_posts_alberto/models/publicacion.dart';
import 'package:practica_05_posts_alberto/screens/lista_publicaciones.dart';
import 'package:practica_05_posts_alberto/services/api_publicaciones.dart';

List<Map<String, dynamic>> _falsas(int n) => List.generate(
  n,
  (i) => {
    'userId': 1,
    'id': i + 1,
    'title': 'Titulo ${i + 1}',
    'body': 'Cuerpo ${i + 1}',
  },
);

Widget _app(http.Client cliente) => MaterialApp(
  home: ListaPublicaciones(api: ApiPublicaciones(cliente: cliente)),
);

void main() {
  test('Publicacion.fromJson convierte el JSON', () {
    final p = Publicacion.fromJson({
      'userId': 3,
      'id': 7,
      'title': 'Hola',
      'body': 'Mundo',
    });
    expect(p.id, 7);
    expect(p.usuarioId, 3);
    expect(p.titulo, 'Hola');
    expect(p.cuerpo, 'Mundo');
  });

  test('El servicio lanza error si el status no es 200', () async {
    final api = ApiPublicaciones(
      cliente: MockClient((_) async => http.Response('', 500)),
    );
    await expectLater(api.obtenerPublicaciones(), throwsException);
  });

  testWidgets('Muestra carga y luego la lista', (tester) async {
    final cliente = MockClient(
      (_) async => http.Response(jsonEncode(_falsas(25)), 200),
    );
    await tester.pumpWidget(_app(cliente));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Titulo 1'), findsOneWidget);
  });

  testWidgets('Muestra error y boton Reintentar', (tester) async {
    final cliente = MockClient((_) async => http.Response('', 500));
    await tester.pumpWidget(_app(cliente));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('Al tocar una publicacion abre el detalle', (tester) async {
    final cliente = MockClient(
      (_) async => http.Response(jsonEncode(_falsas(25)), 200),
    );
    await tester.pumpWidget(_app(cliente));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Titulo 1'));
    await tester.pumpAndSettle();
    expect(find.text('Publicación #1'), findsOneWidget);
    expect(find.text('Usuario 1'), findsOneWidget);
  });
}