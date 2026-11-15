import 'package:flutter/foundation.dart';

import '../models/publicacion.dart';
import '../services/api_publicaciones.dart';

enum EstadoCarga { cargando, listo, error }

class PublicacionesProvider extends ChangeNotifier {
  PublicacionesProvider(this._api);

  final ApiPublicaciones _api;

  EstadoCarga _estado = EstadoCarga.cargando;
  String? _error;
  List<Publicacion> _todas = [];
  List<Publicacion> _visibles = [];
  final Set<int> _favoritos = {};
  String _busqueda = '';
  bool _soloFavoritos = false;

  EstadoCarga get estado => _estado;
  String? get error => _error;
  int get total => _todas.length;
  List<Publicacion> get visibles => _visibles;
  bool get soloFavoritos => _soloFavoritos;
  int get totalFavoritos => _favoritos.length;
  bool esFavorito(int id) => _favoritos.contains(id);

  Future<void> cargar() async {
    // Solo muestra el indicador si todavía no hay datos (al recargar se queda la lista).
    if (_todas.isEmpty) {
      _estado = EstadoCarga.cargando;
      _error = null;
      notifyListeners();
    }
    try {
      _todas = await _api.obtenerPublicaciones();
      _estado = EstadoCarga.listo;
      _error = null;
    } catch (e) {
      if (_todas.isEmpty) _estado = EstadoCarga.error;
      _error = e.toString();
    }
    _filtrar();
    notifyListeners();
  }

  void buscar(String texto) {
    _busqueda = texto;
    _filtrar();
    notifyListeners();
  }

  void alternarFavorito(int id) {
    if (!_favoritos.remove(id)) _favoritos.add(id);
    if (_soloFavoritos) _filtrar();
    notifyListeners();
  }

  void alternarSoloFavoritos() {
    _soloFavoritos = !_soloFavoritos;
    _filtrar();
    notifyListeners();
  }

  // El filtro se calcula aquí una sola vez, no dentro de build().
  void _filtrar() {
    final texto = _busqueda.trim().toLowerCase();
    _visibles = _todas.where((p) {
      if (_soloFavoritos && !_favoritos.contains(p.id)) return false;
      if (texto.isEmpty) return true;
      return p.titulo.toLowerCase().contains(texto) ||
          p.cuerpo.toLowerCase().contains(texto);
    }).toList();
  }
}
