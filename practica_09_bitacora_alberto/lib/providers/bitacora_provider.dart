import 'package:flutter/foundation.dart';

import '../models/inspeccion.dart';
import '../services/camara_service.dart';
import '../services/fotos_service.dart';
import '../services/inspecciones_repositorio.dart';
import '../services/sensores_service.dart';

typedef ResultadoRegistro = ({bool ok, String mensaje});

class BitacoraProvider extends ChangeNotifier {
  BitacoraProvider({
    CamaraService? camara,
    SensoresService? sensores,
    FotosService? fotos,
    InspeccionesRepositorio? repositorio,
    DateTime Function()? reloj,
  }) : _camara = camara ?? CamaraService(),
       _sensores = sensores ?? SensoresService(),
       _fotos = fotos ?? FotosService(),
       _repo = repositorio ?? InspeccionesRepositorio(),
       _reloj = reloj ?? DateTime.now;

  final CamaraService _camara;
  final SensoresService _sensores;
  final FotosService _fotos;
  final InspeccionesRepositorio _repo;
  final DateTime Function() _reloj;

  List<Inspeccion> _inspecciones = [];
  bool _cargando = true;
  bool _registrando = false;

  List<Inspeccion> get inspecciones => List.unmodifiable(_inspecciones);
  bool get cargando => _cargando;
  bool get registrando => _registrando;

  Future<void> cargar() async {
    _inspecciones = await _repo.cargar();
    _inspecciones.sort((a, b) => b.fecha.compareTo(a.fecha));
    _cargando = false;
    notifyListeners();
  }

  /// Toma la foto, lee los sensores en ese momento y guarda la inspección.
  Future<ResultadoRegistro> registrar(String titulo) async {
    final nombre = titulo.trim();
    if (nombre.isEmpty) {
      return (ok: false, mensaje: 'Escribe qué se inspeccionó');
    }
    _registrando = true;
    notifyListeners();
    try {
      final foto = await _camara.tomarFoto();
      if (foto.estado != EstadoFoto.ok) {
        return (ok: false, mensaje: _mensajeFoto(foto));
      }
      final acel = await _leer(_sensores.acelerometro);
      final giro = await _leer(_sensores.giroscopio);
      final fecha = _reloj();
      final id = fecha.microsecondsSinceEpoch.toString();
      final ruta = await _fotos.guardar(foto.ruta!, id);
      final nueva = Inspeccion(
        id: id,
        titulo: nombre,
        fotoRuta: ruta,
        fecha: fecha,
        acelerometro: acel,
        giroscopio: giro,
      );
      _inspecciones = [nueva, ..._inspecciones];
      await _repo.guardar(_inspecciones);
      return (ok: true, mensaje: 'Inspección "$nombre" registrada');
    } catch (e) {
      return (ok: false, mensaje: 'No se pudo guardar la inspección: $e');
    } finally {
      _registrando = false;
      notifyListeners();
    }
  }

  Future<void> eliminar(Inspeccion inspeccion) async {
    _inspecciones = _inspecciones.where((i) => i.id != inspeccion.id).toList();
    notifyListeners();
    await _repo.guardar(_inspecciones);
    try {
      await _fotos.borrar(inspeccion.fotoRuta);
    } catch (_) {
      // Si la foto ya no existe no pasa nada.
    }
  }

  /// Toma la lectura actual de un sensor. Si no hay sensor regresa null.
  Future<Lectura?> _leer(Stream<Lectura> Function() fuente) async {
    try {
      return await fuente().first.timeout(const Duration(seconds: 2));
    } catch (_) {
      return null;
    }
  }

  String _mensajeFoto(ResultadoFoto foto) => switch (foto.estado) {
    EstadoFoto.cancelada => 'Captura cancelada, no se guardó la inspección',
    EstadoFoto.sinPermiso => 'Permiso de cámara denegado. Actívalo en Ajustes.',
    EstadoFoto.error => 'No se pudo tomar la foto: ${foto.detalle}',
    EstadoFoto.ok => '',
  };
}
