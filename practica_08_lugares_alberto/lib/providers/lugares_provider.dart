import 'package:flutter/foundation.dart';

import '../models/lugar.dart';
import '../services/lugares_repositorio.dart';
import '../services/ubicacion_service.dart';

class LugaresProvider extends ChangeNotifier {
  LugaresProvider({
    UbicacionService? ubicacion,
    LugaresRepositorio? repositorio,
  }) : _ubicacion = ubicacion ?? UbicacionService(),
       _repo = repositorio ?? LugaresRepositorio();

  final UbicacionService _ubicacion;
  final LugaresRepositorio _repo;

  List<Lugar> _lugares = [];
  List<Lugar> _ordenados = [];
  final Map<String, double> _distancias = {};
  ResultadoUbicacion? _resultado;
  bool _buscando = false;

  bool get buscando => _buscando;
  ResultadoUbicacion? get resultado => _resultado;
  bool get tieneUbicacion => _resultado?.estado == EstadoUbicacion.ok;
  List<Lugar> get lugares => _ordenados;
  double? distanciaA(Lugar l) => _distancias[l.id];

  String get mensaje => switch (_resultado?.estado) {
    null => 'Toca "Mi ubicación" para obtener tu posición',
    EstadoUbicacion.ok => 'Ubicación obtenida',
    EstadoUbicacion.servicioApagado => 'Activa el servicio de ubicación',
    EstadoUbicacion.permisoNegado => 'Permiso de ubicación negado',
    EstadoUbicacion.permisoBloqueado =>
      'Permiso bloqueado. Actívalo en Ajustes',
    EstadoUbicacion.error => 'No se pudo obtener la ubicación',
  };

  Future<void> cargar() async {
    _lugares = await _repo.cargar();
    _ordenar();
    notifyListeners();
  }

  Future<void> obtenerUbicacion() async {
    _buscando = true;
    notifyListeners();
    _resultado = await _ubicacion.obtener();
    _buscando = false;
    _ordenar();
    notifyListeners();
  }

  /// Devuelve un mensaje de error, o null si se guardó.
  Future<String?> agregar(String nombre, double lat, double lng) async {
    final n = nombre.trim();
    if (n.isEmpty) return 'Escribe un nombre';
    if (_lugares.any((l) => l.nombre.toLowerCase() == n.toLowerCase())) {
      return 'Ya existe un lugar con ese nombre';
    }
    _lugares.add(
      Lugar(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nombre: n,
        latitud: lat,
        longitud: lng,
        creado: DateTime.now(),
      ),
    );
    await _repo.guardar(_lugares);
    _ordenar();
    notifyListeners();
    return null;
  }

  Future<String?> agregarAqui(String nombre) async {
    final r = _resultado;
    if (r == null || r.estado != EstadoUbicacion.ok) {
      return 'Primero obtén tu ubicación';
    }
    return agregar(nombre, r.latitud!, r.longitud!);
  }

  Future<void> eliminar(String id) async {
    _lugares.removeWhere((l) => l.id == id);
    await _repo.guardar(_lugares);
    _ordenar();
    notifyListeners();
  }

  Future<bool> abrirAjustes() => _ubicacion.abrirAjustes();

  // Distancias y orden se calculan aquí, no en build().
  void _ordenar() {
    _distancias.clear();
    final r = _resultado;
    if (r != null && r.estado == EstadoUbicacion.ok) {
      for (final l in _lugares) {
        _distancias[l.id] = UbicacionService.distancia(
          r.latitud!,
          r.longitud!,
          l.latitud,
          l.longitud,
        );
      }
      _ordenados = [..._lugares]
        ..sort((a, b) => _distancias[a.id]!.compareTo(_distancias[b.id]!));
    } else {
      _ordenados = [..._lugares]..sort((a, b) => b.creado.compareTo(a.creado));
    }
  }
}
