import 'package:geolocator/geolocator.dart';

/// Resultados posibles al pedir la ubicación.
enum EstadoUbicacion {
  ok,
  servicioDesactivado,
  permisoDenegado,
  permisoDenegadoParaSiempre,
  error,
}

/// Respuesta del servicio: un estado y, si todo salió bien, la posición.
class RespuestaUbicacion {
  final EstadoUbicacion estado;
  final Position? posicion;

  const RespuestaUbicacion(this.estado, [this.posicion]);
}

class UbicacionService {
  /// Revisa el GPS y el permiso, y obtiene la posición actual.
  /// Nunca lanza excepciones: siempre devuelve un estado.
  Future<RespuestaUbicacion> obtenerPosicion() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      return const RespuestaUbicacion(EstadoUbicacion.servicioDesactivado);
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      return const RespuestaUbicacion(EstadoUbicacion.permisoDenegado);
    }
    if (permiso == LocationPermission.deniedForever) {
      return const RespuestaUbicacion(
        EstadoUbicacion.permisoDenegadoParaSiempre,
      );
    }

    try {
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 30),
        ),
      );
      return RespuestaUbicacion(EstadoUbicacion.ok, posicion);
    } catch (_) {
      // Si no hay una posición nueva, se intenta con la última conocida.
      try {
        final ultima = await Geolocator.getLastKnownPosition();
        if (ultima != null) {
          return RespuestaUbicacion(EstadoUbicacion.ok, ultima);
        }
      } catch (_) {}
      return const RespuestaUbicacion(EstadoUbicacion.error);
    }
  }

  /// Distancia en metros entre dos coordenadas.
  double distanciaMetros(
    double latInicio,
    double lonInicio,
    double latFin,
    double lonFin,
  ) {
    return Geolocator.distanceBetween(latInicio, lonInicio, latFin, lonFin);
  }

  Future<bool> abrirAjustesApp() => Geolocator.openAppSettings();

  Future<bool> abrirAjustesUbicacion() => Geolocator.openLocationSettings();
}
