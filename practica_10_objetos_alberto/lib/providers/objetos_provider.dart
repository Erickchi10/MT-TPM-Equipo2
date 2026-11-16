import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/objeto.dart';
import '../models/resguardante.dart';
import '../services/camara_service.dart';
import '../services/fotos_service.dart';
import '../services/notificaciones_service.dart';
import '../services/objetos_repositorio.dart';
import '../services/resguardantes_api.dart';
import '../services/ubicacion_service.dart';

enum EstadoResguardantes { cargando, ok, sinConexion, error }

class ObjetosProvider extends ChangeNotifier {
  ObjetosProvider({
    required this._notificaciones,
    ObjetosRepositorio? repositorio,
    ResguardantesApi? api,
    CamaraService? camara,
    UbicacionService? ubicacion,
    FotosService? fotos,
    DateTime Function()? reloj,
  }) : _repo = repositorio ?? ObjetosRepositorio(),
       _api = api ?? ResguardantesApi(),
       _camara = camara ?? CamaraService(),
       _ubicacion = ubicacion ?? UbicacionService(),
       _fotos = fotos ?? FotosService(),
       _reloj = reloj ?? DateTime.now;

  final NotificacionesService _notificaciones;
  final ObjetosRepositorio _repo;
  final ResguardantesApi _api;
  final CamaraService _camara;
  final UbicacionService _ubicacion;
  final FotosService _fotos;
  final DateTime Function() _reloj;

  List<Objeto> _objetos = [];
  EstadoObjeto? _filtro;
  bool _cargando = true;
  bool _notificacionesPermitidas = true;
  List<Resguardante> _resguardantes = [];
  EstadoResguardantes _estadoResguardantes = EstadoResguardantes.cargando;

  bool get cargando => _cargando;
  bool get notificacionesPermitidas => _notificacionesPermitidas;
  EstadoObjeto? get filtro => _filtro;
  int get total => _objetos.length;
  List<Resguardante> get resguardantes => List.unmodifiable(_resguardantes);
  EstadoResguardantes get estadoResguardantes => _estadoResguardantes;

  /// Objetos según el filtro elegido (null = todos).
  List<Objeto> get objetos {
    final f = _filtro;
    return List.unmodifiable(
      f == null ? _objetos : _objetos.where((o) => o.estado == f),
    );
  }

  int contar(EstadoObjeto estado) =>
      _objetos.where((o) => o.estado == estado).length;

  Objeto? buscar(String id) {
    for (final o in _objetos) {
      if (o.id == id) return o;
    }
    return null;
  }

  Resguardante? resguardantePorId(int id) {
    for (final r in _resguardantes) {
      if (r.id == id) return r;
    }
    return null;
  }

  void filtrar(EstadoObjeto? estado) {
    _filtro = estado;
    notifyListeners();
  }

  Future<void> cargar() async {
    _objetos = await _repo.cargar();
    _objetos.sort((a, b) => b.fecha.compareTo(a.fecha));
    _cargando = false;
    notifyListeners();
  }

  Future<void> pedirPermisoNotificaciones() async {
    _notificacionesPermitidas = await _notificaciones.pedirPermiso();
    notifyListeners();
  }

  /// Descarga el personal de la API. Sin internet usa la última lista guardada.
  Future<void> cargarResguardantes() async {
    _estadoResguardantes = EstadoResguardantes.cargando;
    notifyListeners();
    try {
      _resguardantes = await _api.obtener();
      _estadoResguardantes = EstadoResguardantes.ok;
      await _repo.guardarResguardantes(_resguardantes);
    } on SocketException {
      await _usarGuardados(EstadoResguardantes.sinConexion);
    } on TimeoutException {
      await _usarGuardados(EstadoResguardantes.sinConexion);
    } on http.ClientException {
      await _usarGuardados(EstadoResguardantes.sinConexion);
    } catch (_) {
      await _usarGuardados(EstadoResguardantes.error);
    }
    notifyListeners();
  }

  Future<void> _usarGuardados(EstadoResguardantes estado) async {
    _resguardantes = await _repo.cargarResguardantes();
    _estadoResguardantes = estado;
  }

  Future<ResultadoFoto> tomarFoto() => _camara.tomarFoto();

  Future<ResultadoUbicacion> obtenerUbicacion() => _ubicacion.obtener();

  Future<String> registrar({
    required String nombre,
    required String descripcion,
    required String categoria,
    required String lugar,
    required Resguardante resguardante,
    String? fotoTemporal,
    double? latitud,
    double? longitud,
  }) async {
    final fecha = _reloj();
    final id = fecha.microsecondsSinceEpoch.toString();
    String? foto;
    if (fotoTemporal != null) {
      try {
        foto = await _fotos.guardar(fotoTemporal, 'objeto_$id');
      } catch (_) {
        foto = null;
      }
    }
    final nuevo = Objeto(
      id: id,
      nombre: nombre.trim(),
      descripcion: descripcion.trim(),
      categoria: categoria,
      lugar: lugar.trim(),
      resguardante: resguardante.nombre,
      fecha: fecha,
      fotoRuta: foto,
      latitud: latitud,
      longitud: longitud,
    );
    _objetos = [nuevo, ..._objetos];
    notifyListeners();
    await _repo.guardar(_objetos);
    await _notificaciones.mostrar(
      id: _idNotificacion(fecha),
      titulo: 'Objeto registrado',
      cuerpo: '${nuevo.nombre} · lo resguarda ${nuevo.resguardante}',
    );
    return 'Objeto "${nuevo.nombre}" registrado';
  }

  Future<String> cambiarEstado(
    String id,
    EstadoObjeto nuevo, {
    String? entregadoA,
  }) async {
    final i = _objetos.indexWhere((o) => o.id == id);
    if (i < 0) return 'El objeto ya no existe';
    final ahora = _reloj();
    final actualizado = nuevo == EstadoObjeto.entregado
        ? _objetos[i].copyWith(
            estado: nuevo,
            entregadoA: entregadoA?.trim(),
            fechaEntrega: ahora,
          )
        : _objetos[i].copyWith(estado: nuevo);
    _objetos = [..._objetos]..[i] = actualizado;
    notifyListeners();
    await _repo.guardar(_objetos);
    if (nuevo == EstadoObjeto.entregado) {
      await _notificaciones.mostrar(
        id: _idNotificacion(ahora),
        titulo: 'Objeto entregado',
        cuerpo: '${actualizado.nombre} se entregó a ${actualizado.entregadoA}',
      );
    }
    return '"${actualizado.nombre}" ahora está '
        '${nuevo.etiqueta.toLowerCase()}';
  }

  Future<void> eliminar(String id) async {
    _objetos = _objetos.where((o) => o.id != id).toList();
    notifyListeners();
    await _repo.guardar(_objetos);
  }

  int _idNotificacion(DateTime f) =>
      (f.millisecondsSinceEpoch ~/ 1000) % 100000;
}
