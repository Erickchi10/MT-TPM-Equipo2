import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/tecnico.dart';

enum EstadoApi { ok, sinConexion, errorServidor, error }

class RespuestaApi {
  const RespuestaApi(this.estado, [this.tecnicos = const []]);
  final EstadoApi estado;
  final List<Tecnico> tecnicos;
}

class ApiService {
  static const String _url = 'https://jsonplaceholder.typicode.com/users';

  /// Descarga la lista de técnicos. Nunca lanza excepciones.
  Future<RespuestaApi> obtenerTecnicos() async {
    try {
      final respuesta = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (respuesta.statusCode != 200) {
        return const RespuestaApi(EstadoApi.errorServidor);
      }
      final lista = jsonDecode(respuesta.body) as List<dynamic>;
      final tecnicos = lista
          .map((e) => Tecnico.fromJson(e as Map<String, dynamic>))
          .toList();
      return RespuestaApi(EstadoApi.ok, tecnicos);
    } on http.ClientException {
      return const RespuestaApi(EstadoApi.sinConexion);
    } catch (_) {
      return const RespuestaApi(EstadoApi.error);
    }
  }
}
