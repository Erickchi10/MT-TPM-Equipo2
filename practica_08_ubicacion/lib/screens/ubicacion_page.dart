import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/ubicacion_service.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  // Punto de referencia (aproximado) para calcular la distancia.
  static const double _latDestino = 20.3694;
  static const double _lonDestino = -90.0510;
  static const String _nombreDestino = 'Calkiní, Campeche';

  final _servicio = UbicacionService();
  bool _cargando = false;
  EstadoUbicacion? _estado;
  Position? _posicion;

  Future<void> _obtener() async {
    setState(() => _cargando = true);
    final respuesta = await _servicio.obtenerPosicion();
    if (!mounted) return;
    setState(() {
      _cargando = false;
      _estado = respuesta.estado;
      _posicion = respuesta.posicion;
    });
  }

  Future<void> _abrirMapa(double lat, double lon) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
    );
    var abierto = false;
    try {
      abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      abierto = false;
    }
    if (!abierto && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  String _mensajeEstado(EstadoUbicacion estado) {
    switch (estado) {
      case EstadoUbicacion.ok:
        return 'Ubicación obtenida correctamente';
      case EstadoUbicacion.servicioDesactivado:
        return 'El GPS está desactivado. Actívalo para continuar.';
      case EstadoUbicacion.permisoDenegado:
        return 'Permiso de ubicación denegado. Puedes volver a intentarlo.';
      case EstadoUbicacion.permisoDenegadoParaSiempre:
        return 'Permiso denegado permanentemente. Actívalo en los ajustes de la app.';
      case EstadoUbicacion.error:
        return 'No se pudo obtener la ubicación. Intenta de nuevo.';
    }
  }

  String _formatoDistancia(double metros) {
    if (metros >= 1000) {
      return '${(metros / 1000).toStringAsFixed(2)} km';
    }
    return '${metros.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    final posicion = _posicion;
    final estado = _estado;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi ubicación')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: _cargando ? null : _obtener,
            icon: const Icon(Icons.my_location),
            label: Text(_cargando ? 'Buscando...' : 'Obtener mi ubicación'),
          ),
          const SizedBox(height: 16),
          if (estado != null && estado != EstadoUbicacion.ok)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_mensajeEstado(estado)),
                    if (estado == EstadoUbicacion.servicioDesactivado)
                      TextButton(
                        onPressed: _servicio.abrirAjustesUbicacion,
                        child: const Text('Abrir ajustes de ubicación'),
                      ),
                    if (estado == EstadoUbicacion.permisoDenegadoParaSiempre)
                      TextButton(
                        onPressed: _servicio.abrirAjustesApp,
                        child: const Text('Abrir ajustes de la app'),
                      ),
                  ],
                ),
              ),
            ),
          if (posicion != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posición actual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Latitud: ${posicion.latitude.toStringAsFixed(6)}'),
                    Text('Longitud: ${posicion.longitude.toStringAsFixed(6)}'),
                    Text(
                      'Precisión: ±${posicion.accuracy.toStringAsFixed(1)} m',
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _abrirMapa(posicion.latitude, posicion.longitude),
                      icon: const Icon(Icons.map),
                      label: const Text('Ver mi posición en el mapa'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distancia a $_nombreDestino',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatoDistancia(
                        _servicio.distanciaMetros(
                          posicion.latitude,
                          posicion.longitude,
                          _latDestino,
                          _lonDestino,
                        ),
                      ),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _abrirMapa(_latDestino, _lonDestino),
                      icon: const Icon(Icons.place),
                      label: const Text('Abrir destino en el mapa'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
