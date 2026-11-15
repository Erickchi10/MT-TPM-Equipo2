import 'package:url_launcher/url_launcher.dart';

class MapaService {
  static Uri uri(double lat, double lng) =>
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

  static Future<bool> abrir(double lat, double lng) =>
      launchUrl(uri(lat, lng), mode: LaunchMode.externalApplication);
}
