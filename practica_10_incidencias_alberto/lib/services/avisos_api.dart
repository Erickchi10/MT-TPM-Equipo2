import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/aviso.dart';

class AvisosApi {
  AvisosApi({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  static final _url = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts?_limit=5',
  );

  Future<List<Aviso>> obtener() async {
    final r = await _cliente.get(_url).timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) {
      throw Exception('El servidor respondió ${r.statusCode}');
    }
    final lista = jsonDecode(r.body) as List;
    return lista.map((e) => Aviso.fromJson(e as Map<String, dynamic>)).toList();
  }
}
