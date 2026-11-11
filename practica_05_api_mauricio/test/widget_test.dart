import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api_mauricio/main.dart';
import 'package:practica_05_api_mauricio/posts_page.dart';

void main() {
  test('Usuario.fromJson convierte bien el JSON', () {
    final u = Usuario.fromJson({
      'id': 1,
      'name': 'Leanne',
      'email': 'leanne@mail.com',
    });
    expect(u.id, 1);
    expect(u.nombre, 'Leanne');
    expect(u.correo, 'leanne@mail.com');
  });

  test('Post.fromJson convierte bien el JSON', () {
    final p = Post.fromJson({'id': 5, 'title': 'Hola', 'body': 'Contenido'});
    expect(p.id, 5);
    expect(p.titulo, 'Hola');
    expect(p.cuerpo, 'Contenido');
  });
}
