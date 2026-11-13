import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publicacion.dart';

class ApiPublicaciones {
  static const _url = 'https://jsonplaceholder.typicode.com/posts';
  final http.Client cliente;

  ApiPublicaciones({http.Client? cliente})
    : cliente = cliente ?? http.Client();

  Future<List<Publicacion>> obtenerPublicaciones() async {
    final respuesta = await cliente.get(Uri.parse(_url));
    if (respuesta.statusCode != 200) {
      throw Exception('Error HTTP ${respuesta.statusCode}');
    }
    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos
        .map((e) => Publicacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

