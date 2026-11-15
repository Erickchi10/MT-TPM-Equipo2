import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:practica_07_publicaciones_alberto/models/publicacion.dart';
import 'package:practica_07_publicaciones_alberto/providers/publicaciones_provider.dart';
import 'package:practica_07_publicaciones_alberto/screens/lista_publicaciones.dart';
import 'package:practica_07_publicaciones_alberto/services/api_publicaciones.dart';
import 'package:practica_07_publicaciones_alberto/services/compartir_service.dart';
import 'package:practica_07_publicaciones_alberto/widgets/publicacion_tile.dart';

List<Map<String, dynamic>> _falsas(int n) => List.generate(
  n,
  (i) => {
    'userId': 1,
    'id': i + 1,
    'title': 'Publicacion ${i + 1}',
    'body': 'Contenido ${i + 1}',
  },
);

http.Client _ok(int n) =>
    MockClient((_) async => http.Response(jsonEncode(_falsas(n)), 200));

http.Client _falla() => MockClient((_) async => http.Response('', 500));

PublicacionesProvider _prov(http.Client c) =>
    PublicacionesProvider(ApiPublicaciones(cliente: c));

void main() {
  test('Carga las publicaciones y queda listo', () async {
    final p = _prov(_ok(25));
    expect(p.estado, EstadoCarga.cargando);
    await p.cargar();
    expect(p.estado, EstadoCarga.listo);
    expect(p.total, 25);
    expect(p.visibles.length, 25);
  });

  test('Si el servidor falla queda en error', () async {
    final p = _prov(_falla());
    await p.cargar();
    expect(p.estado, EstadoCarga.error);
    expect(p.error, contains('500'));
  });

  test('La búsqueda filtra por título', () async {
    final p = _prov(_ok(25));
    await p.cargar();
    p.buscar('publicacion 7');
    expect(p.visibles.map((x) => x.id), [7]);
    p.buscar('');
    expect(p.visibles.length, 25);
  });

  test('Favoritos y filtro de solo favoritos', () async {
    final p = _prov(_ok(25));
    await p.cargar();
    p.alternarFavorito(3);
    p.alternarFavorito(5);
    expect(p.totalFavoritos, 2);
    expect(p.esFavorito(3), isTrue);
    p.alternarSoloFavoritos();
    expect(p.visibles.map((x) => x.id), [3, 5]);
    p.alternarFavorito(3);
    expect(p.visibles.map((x) => x.id), [5]);
  });

  test('Texto para compartir', () {
    const pub = Publicacion(
      id: 9,
      usuarioId: 2,
      titulo: 'Hola',
      cuerpo: 'Mundo',
    );
    final texto = CompartirService.textoDe(pub);
    expect(texto, contains('Hola'));
    expect(texto, contains('Mundo'));
    expect(texto, contains('#9'));
  });

  testWidgets('La pantalla muestra la lista y filtra al buscar', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => _prov(_ok(25))..cargar(),
        child: const MaterialApp(home: ListaPublicaciones()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('25 de 25 publicaciones'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Publicacion 7');
    await tester.pump();
    expect(find.byType(PublicacionTile), findsOneWidget);
    expect(find.text('1 de 25 publicaciones'), findsOneWidget);
  });
}
