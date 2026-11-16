import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/aviso.dart';
import '../models/incidencia.dart';
import '../services/avisos_api.dart';
import '../services/camara_service.dart';
import '../services/fotos_service.dart';
import '../services/incidencias_repositorio.dart';
import '../services/notificaciones_service.dart';
import '../services/ubicacion_service.dart';

enum EstadoAvisos { cargando, ok, sinConexion, error }

class IncidenciasProvider extends ChangeNotifier {
  IncidenciasProvider({
    required this._notificaciones,
    IncidenciasRepositorio? repositorio,
    AvisosApi? api,
    CamaraService? camara,
    UbicacionService? ubicacion,
    FotosService? fotos,
    DateTime Function()? reloj,
  }) : _repo = repositorio ?? IncidenciasRepositorio(),
       _api = api ?? AvisosApi(),
       _camara = camara ?? CamaraService(),
       _ubicacion = ubicacion ?? UbicacionService(),
       _fotos = fotos ?? FotosService(),
       _reloj = reloj ?? DateTime.now;

  final NotificacionesService _notificaciones;
  final IncidenciasRepositorio _repo;
  final AvisosApi _api;
  final CamaraService _camara;
  final UbicacionService _ubicacion;
  final FotosService _fotos;
  final DateTime Function() _reloj;

  List<Incidencia> _incidencias = [];
  bool _cargando = true;
  bool _notificacionesPermitidas = true;
  List<Aviso> _avisos = [];
  EstadoAvisos _estadoAvisos = EstadoAvisos.cargando;

  List<Incidencia> get incidencias => List.unmodifiable(_incidencias);
  bool get cargando => _cargando;
  bool get notificacionesPermitidas => _notificacionesPermitidas;
  List<Aviso> get avisos => List.unmodifiable(_avisos);
  EstadoAvisos get estadoAvisos => _estadoAvisos;

  Future<void> cargar() async {
    _incidencias = await _repo.cargar();
    _incidencias.sort((a, b) => b.fecha.compareTo(a.fecha));
    _cargando = false;
    notifyListeners();
  }

  Future<void> pedirPermisoNotificaciones() async {
    _notificacionesPermitidas = await _notificaciones.pedirPermiso();
    notifyListeners();
  }

  Future<void> cargarAvisos() async {
    _estadoAvisos = EstadoAvisos.cargando;
    notifyListeners();
    try {
      _avisos = await _api.obtener();
      _estadoAvisos = EstadoAvisos.ok;
    } on SocketException {
      _estadoAvisos = EstadoAvisos.sinConexion;
    } on TimeoutException {
      _estadoAvisos = EstadoAvisos.sinConexion;
    } on http.ClientException {
      _estadoAvisos = EstadoAvisos.sinConexion;
    } catch (_) {
      _estadoAvisos = EstadoAvisos.error;
    }
    notifyListeners();
  }

  Future<ResultadoFoto> tomarFoto() => _camara.tomarFoto();

  Future<ResultadoUbicacion> obtenerUbicacion() => _ubicacion.obtener();

  /// Guarda el reporte sin internet y avisa con una notificación local.
  Future<String> guardar({
    required String titulo,
    required String descripcion,
    required String categoria,
    String? fotoTemporal,
    double? latitud,
    double? longitud,
  }) async {
    final fecha = _reloj();
    final id = fecha.microsecondsSinceEpoch.toString();
    String? foto;
    if (fotoTemporal != null) {
      try {
        foto = await _fotos.guardar(fotoTemporal, 'incidencia_$id');
      } catch (_) {
        foto = null;
      }
    }
    final nueva = Incidencia(
      id: id,
      titulo: titulo.trim(),
      descripcion: descripcion.trim(),
      categoria: categoria,
      fecha: fecha,
      fotoRuta: foto,
      latitud: latitud,
      longitud: longitud,
    );
    _incidencias = [nueva, ..._incidencias];
    notifyListeners();
    await _repo.guardar(_incidencias);
    await _notificaciones.mostrar(
      id: (fecha.millisecondsSinceEpoch ~/ 1000) % 100000,
      titulo: 'Incidencia guardada',
      cuerpo: '${nueva.titulo} · ${nueva.categoria}',
    );
    return 'Reporte "${nueva.titulo}" guardado';
  }
}
