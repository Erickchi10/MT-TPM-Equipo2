import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
    static const String _url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> obtenerPosts() async {
    final respuesta = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));

    if (respuesta.statusCode != 200) {
      throw Exception('HTTP ${respuesta.statusCode}');
    }

    final List datos = jsonDecode(respuesta.body);
    return datos.map((e) => Post.fromJson(e)).toList();
  }
}
