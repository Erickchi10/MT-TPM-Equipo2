import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/reporte.dart';

class ServicioPost {
  final int id;
  final int userId;
  final String titulo;
  final String contenido;

  const ServicioPost({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.contenido,
  });

  factory ServicioPost.fromJson(Map<String, dynamic> json) {
    return ServicioPost(
      id: json['id'] as int,
      userId: json['userId'] as int,
      titulo: json['title'] as String,
      contenido: json['body'] as String,
    );
  }
}

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // Consultar publicaciones de prueba mediante HTTP GET.
  static Future<List<ServicioPost>> obtenerPosts() async {
    try {
      final respuesta = await http
          .get(
            Uri.parse('$_baseUrl/posts?_limit=10'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(respuesta.body);

        return datos.map((elemento) {
          return ServicioPost.fromJson(
            Map<String, dynamic>.from(elemento as Map),
          );
        }).toList();
      }

      throw Exception('Error del servidor. Código: ${respuesta.statusCode}');
    } on http.ClientException {
      throw Exception('No se pudo establecer conexión con el servidor.');
    } on FormatException {
      throw Exception(
        'La respuesta del servidor tiene un formato JSON inválido.',
      );
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }

  // Enviar un reporte mediante HTTP POST.
  static Future<int> sincronizarReporte(Reporte reporte) async {
    try {
      final datosReporte = {
        'userId': 1,
        'titulo': reporte.titulo,
        'descripcion': reporte.descripcion,
        'categoria': reporte.categoria,
        'latitud': reporte.latitud,
        'longitud': reporte.longitud,
        'fecha': reporte.fecha.toIso8601String(),
      };

      final respuesta = await http
          .post(
            Uri.parse('$_baseUrl/posts'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(datosReporte),
          )
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode == 201) {
        final Map<String, dynamic> resultado = jsonDecode(respuesta.body);

        final idServidor = resultado['id'];

        if (idServidor is! int) {
          throw Exception('El servidor no devolvió un identificador válido.');
        }

        return idServidor;
      }

      throw Exception(
        'No se pudo enviar el reporte. '
        'Código: ${respuesta.statusCode}',
      );
    } on http.ClientException {
      throw Exception('No se pudo establecer conexión con el servidor.');
    } on FormatException {
      throw Exception('El servidor devolvió una respuesta inválida.');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error inesperado al enviar el reporte: $e');
    }
  }
}
