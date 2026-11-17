
import 'package:geolocator/geolocator.dart';

class UbicacionService {
  static Future<Position> obtenerPosicionActual() async {
    // Comprobar si el GPS está activado.
    final servicioActivo =
        await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception('Activa el GPS de tu teléfono.');
    }

    // Comprobar los permisos.
    var permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('Permiso de ubicación denegado.');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'Permiso bloqueado. Actívalo desde los ajustes.',
      );
    }

    // Obtener las coordenadas actuales.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
