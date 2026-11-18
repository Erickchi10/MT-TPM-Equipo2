
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/inspeccion.dart';

class ApiService {
  static final Uri _url = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );

  static Future<Map<String, dynamic>> enviarReporte(
    Inspeccion inspeccion,
  ) async {
    final respuesta = await http
        .post(
          _url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'userId': 1,
            'title': inspeccion.titulo,
            'body':
                'Categoría: ${inspeccion.categoria}\n'
                'Descripción: ${inspeccion.descripcion}\n'
                'Fecha: ${inspeccion.fecha}',
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (respuesta.statusCode != 201) {
      throw Exception(
        'Error al enviar reporte: ${respuesta.statusCode}',
      );
    }

    final resultado = jsonDecode(respuesta.body);

    if (resultado is! Map) {
      throw const FormatException(
        'Respuesta JSON no válida',
      );
    }

    return Map<String, dynamic>.from(resultado);
  }
}
