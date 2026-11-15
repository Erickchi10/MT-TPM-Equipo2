typedef Coordenada = ({double lat, double lng});

class Coordenadas {
  /// Convierte "20.370855, -90.050467" en (lat, lng). Devuelve null si no es válido.
  static Coordenada? leer(String texto) {
    final partes = texto.split(',');
    if (partes.length != 2) return null;
    final lat = double.tryParse(partes[0].trim());
    final lng = double.tryParse(partes[1].trim());
    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
    return (lat: lat, lng: lng);
  }

  static String distancia(double metros) => metros < 1000
      ? '${metros.round()} m'
      : '${(metros / 1000).toStringAsFixed(1)} km';
}
