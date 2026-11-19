import 'package:geolocator/geolocator.dart';

class UbicacionService {
  Future<Position> obtenerUbicacionActual() async {
    // Comprobar si el GPS está activado.
    final servicioHabilitado = await Geolocator.isLocationServiceEnabled();

    if (!servicioHabilitado) {
      throw Exception('El GPS está desactivado. Actívalo para continuar.');
    }

    // Comprobar los permisos.
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('No se concedió el permiso de ubicación.');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'El permiso de ubicación está denegado permanentemente. '
        'Actívalo desde los ajustes de la aplicación.',
      );
    }

    // Obtener las coordenadas actuales.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
