import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_posts/models/post.dart';
import 'package:practica_05_posts/screens/posts_page.dart';

const _posts = [
  Post(userId: 1, id: 1, title: 'Titulo uno', body: 'Cuerpo uno'),
  Post(userId: 1, id: 2, title: 'Titulo dos', body: 'Cuerpo dos'),
];

void main() {
  test('Post.fromJson convierte el JSON a objeto Dart', () {
    final post = Post.fromJson({
      'userId': 1,
      'id': 7,
      'title': 'Un titulo',
      'body': 'Un cuerpo',
    });

    expect(post.userId, 1);
    expect(post.id, 7);
    expect(post.title, 'Un titulo');
    expect(post.body, 'Un cuerpo');
  });

  testWidgets('Muestra el indicador de carga mientras espera', (tester) async {
    final completer = Completer<List<Post>>();
    await tester.pumpWidget(
      MaterialApp(home: PostsPage(cargador: () => completer.future)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(_posts);
    await tester.pumpAndSettle();
  });

  testWidgets('Muestra la lista de publicaciones', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: PostsPage(cargador: () async => _posts)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Titulo uno'), findsOneWidget);
    expect(find.text('Cuerpo dos'), findsOneWidget);
  });

  testWidgets('Muestra el error y el boton Reintentar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PostsPage(
          cargador: () async {
            throw Exception('HTTP 500');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No se pudieron cargar las publicaciones'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('Muestra mensaje cuando la lista esta vacia', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: PostsPage(cargador: () async => <Post>[])),
    );
    await tester.pumpAndSettle();

    expect(find.text('No hay publicaciones para mostrar'), findsOneWidget);
  });

  testWidgets('Al tocar una publicacion abre el detalle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: PostsPage(cargador: () async => _posts)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Titulo uno'));
    await tester.pumpAndSettle();

    expect(find.text('Publicación #1'), findsOneWidget);
    expect(find.text('Autor (userId): 1'), findsOneWidget);
  });
}
