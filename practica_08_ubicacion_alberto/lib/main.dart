import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const UbicacionPage(),
  ),
);

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});
  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  Position? posicion;
  String mensaje = 'Sin ubicación';
  bool cargando = false;
  bool permisoBloqueado = false;

  Future<void> obtener() async {
    setState(() {
      cargando = true;
      permisoBloqueado = false;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => mensaje = 'Activa el servicio de ubicación');
        return;
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.deniedForever) {
        setState(() {
          mensaje = 'Permiso bloqueado. Actívalo en Ajustes';
          permisoBloqueado = true;
        });
        return;
      }
      if (permiso == LocationPermission.denied) {
        setState(() => mensaje = 'Permiso de ubicación no disponible');
        return;
      }
      final p = await Geolocator.getCurrentPosition();
      setState(() {
        posicion = p;
        mensaje = 'Ubicación obtenida';
      });
    } catch (e) {
      setState(() => mensaje = 'No se pudo obtener la ubicación: $e');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> abrirMapa() async {
    if (posicion == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${posicion!.latitude},${posicion!.longitude}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mi ubicación')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80),
            const SizedBox(height: 8),
            Text(mensaje, textAlign: TextAlign.center),
            if (posicion != null) ...[
              const SizedBox(height: 12),
              Text('Latitud: ${posicion!.latitude.toStringAsFixed(6)}'),
              Text('Longitud: ${posicion!.longitude.toStringAsFixed(6)}'),
              Text('Precisión: ${posicion!.accuracy.toStringAsFixed(1)} m'),
            ],
            const SizedBox(height: 20),
            if (cargando)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: obtener,
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener ubicación'),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: posicion == null ? null : abrirMapa,
              icon: const Icon(Icons.map),
              label: const Text('Abrir en mapa'),
            ),
            if (permisoBloqueado)
              TextButton(
                onPressed: Geolocator.openAppSettings,
                child: const Text('Abrir ajustes de la app'),
              ),
          ],
        ),
      ),
    ),
  );
}
