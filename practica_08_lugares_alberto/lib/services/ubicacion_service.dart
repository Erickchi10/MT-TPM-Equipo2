import 'package:geolocator/geolocator.dart';

enum EstadoUbicacion {
  ok,
  servicioApagado,
  permisoNegado,
  permisoBloqueado,
  error,
}

class ResultadoUbicacion {
  final EstadoUbicacion estado;
  final double? latitud;
  final double? longitud;
  final double? precision;
  final String? detalle;

  const ResultadoUbicacion(
    this.estado, {
    this.latitud,
    this.longitud,
    this.precision,
    this.detalle,
  });
}

class UbicacionService {
  Future<ResultadoUbicacion> obtener() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const ResultadoUbicacion(EstadoUbicacion.servicioApagado);
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.deniedForever) {
        return const ResultadoUbicacion(EstadoUbicacion.permisoBloqueado);
      }
      if (permiso == LocationPermission.denied) {
        return const ResultadoUbicacion(EstadoUbicacion.permisoNegado);
      }
      final p = await Geolocator.getCurrentPosition();
      return ResultadoUbicacion(
        EstadoUbicacion.ok,
        latitud: p.latitude,
        longitud: p.longitude,
        precision: p.accuracy,
      );
    } catch (e) {
      return ResultadoUbicacion(EstadoUbicacion.error, detalle: '$e');
    }
  }

  static double distancia(double lat1, double lng1, double lat2, double lng2) =>
      Geolocator.distanceBetween(lat1, lng1, lat2, lng2);

  Future<bool> abrirAjustes() => Geolocator.openAppSettings();
}
