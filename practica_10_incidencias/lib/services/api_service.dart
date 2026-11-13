import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/aviso.dart';

enum EstadoApi { ok, sinConexion, errorServidor, error }

class RespuestaApi {
  const RespuestaApi(this.estado, [this.avisos = const []]);
  final EstadoApi estado;
  final List<Aviso> avisos;
}

class ApiService {
  static const String _url =
      'https://jsonplaceholder.typicode.com/posts?_limit=10';

  /// Descarga los avisos. Nunca lanza excepciones: devuelve un estado.
  Future<RespuestaApi> obtenerAvisos() async {
    try {
      final respuesta = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (respuesta.statusCode != 200) {
        return const RespuestaApi(EstadoApi.errorServidor);
      }
      final lista = jsonDecode(respuesta.body) as List<dynamic>;
      final avisos = lista
          .map((e) => Aviso.fromJson(e as Map<String, dynamic>))
          .toList();
      return RespuestaApi(EstadoApi.ok, avisos);
    } on http.ClientException {
      return const RespuestaApi(EstadoApi.sinConexion);
    } catch (_) {
      return const RespuestaApi(EstadoApi.error);
    }
  }
}
