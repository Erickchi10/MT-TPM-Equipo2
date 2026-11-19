import 'package:geolocator/geolocator.dart';

class UbicacionService {
  Future<Position> obtenerUbicacion() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception(
        'El servicio de ubicación está desactivado. Activa el GPS.',
      );
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('No se concedió el permiso de ubicación.');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'El permiso está bloqueado. Actívalo desde los ajustes de la aplicación.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  double calcularDistancia(
    double latitudActual,
    double longitudActual,
    double latitudDestino,
    double longitudDestino,
  ) {
    return Geolocator.distanceBetween(
      latitudActual,
      longitudActual,
      latitudDestino,
      longitudDestino,
    );
  }
}
