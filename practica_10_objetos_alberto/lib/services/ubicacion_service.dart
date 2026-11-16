import 'package:geolocator/geolocator.dart';

enum EstadoUbicacion { ok, servicioApagado, permisoNegado, error }

class ResultadoUbicacion {
  const ResultadoUbicacion(this.estado, {this.latitud, this.longitud});

  final EstadoUbicacion estado;
  final double? latitud;
  final double? longitud;
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
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        return const ResultadoUbicacion(EstadoUbicacion.permisoNegado);
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return ResultadoUbicacion(
        EstadoUbicacion.ok,
        latitud: p.latitude,
        longitud: p.longitude,
      );
    } catch (_) {
      return const ResultadoUbicacion(EstadoUbicacion.error);
    }
  }
}
