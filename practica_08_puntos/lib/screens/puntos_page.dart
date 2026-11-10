import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/punto.dart';
import '../services/puntos_service.dart';
import '../services/ubicacion_service.dart';

class PuntosPage extends StatefulWidget {
  const PuntosPage({super.key});

  @override
  State<PuntosPage> createState() => _PuntosPageState();
}

class _PuntosPageState extends State<PuntosPage> {
  final _ubicacionService = UbicacionService();
  final _puntosService = PuntosService();

  List<Punto> _puntos = [];
  Position? _posicion;
  EstadoUbicacion? _estado;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarPuntos();
  }

  Future<void> _cargarPuntos() async {
    final puntos = await _puntosService.cargar();
    if (!mounted) return;
    setState(() => _puntos = puntos);
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _cargando = true);
    final respuesta = await _ubicacionService.obtenerPosicion();
    if (!mounted) return;
    setState(() {
      _cargando = false;
      _estado = respuesta.estado;
      if (respuesta.posicion != null) _posicion = respuesta.posicion;
    });
  }

  Future<void> _guardarUbicacionActual() async {
    final posicion = _posicion;
    if (posicion == null) return;
    final nombre = await showDialog<String>(
      context: context,
      builder: (_) => const _DialogoNombre(),
    );
    if (nombre == null || !mounted) return;
    setState(() {
      _puntos = [
        ..._puntos,
        Punto(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          nombre: nombre,
          latitud: posicion.latitude,
          longitud: posicion.longitude,
        ),
      ];
    });
    await _puntosService.guardar(_puntos);
  }

  Future<void> _eliminar(Punto punto) async {
    setState(() => _puntos = _puntos.where((p) => p.id != punto.id).toList());
    await _puntosService.guardar(_puntos);
  }

  Future<void> _abrirMapa(Punto punto) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${punto.latitud},${punto.longitud}',
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
      appBar: AppBar(title: const Text('Puntos de interés')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: _cargando ? null : _obtenerUbicacion,
                  icon: const Icon(Icons.my_location),
                  label: Text(
                    _cargando ? 'Buscando...' : 'Obtener mi ubicación',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: posicion == null ? null : _guardarUbicacionActual,
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text('Guardar ubicación actual'),
                ),
                if (estado != null && estado != EstadoUbicacion.ok)
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_mensajeEstado(estado)),
                          if (estado == EstadoUbicacion.servicioDesactivado)
                            TextButton(
                              onPressed:
                                  _ubicacionService.abrirAjustesUbicacion,
                              child: const Text('Abrir ajustes de ubicación'),
                            ),
                          if (estado ==
                              EstadoUbicacion.permisoDenegadoParaSiempre)
                            TextButton(
                              onPressed: _ubicacionService.abrirAjustesApp,
                              child: const Text('Abrir ajustes de la app'),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (posicion != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mi posición actual',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            'Lat: ${posicion.latitude.toStringAsFixed(6)}  '
                            'Lon: ${posicion.longitude.toStringAsFixed(6)}',
                          ),
                          Text(
                            'Precisión: ±${posicion.accuracy.toStringAsFixed(1)} m',
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _puntos.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No hay puntos guardados.\n'
                        'Obtén tu ubicación y guárdala con un nombre.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _puntos.length,
                    itemBuilder: (context, i) {
                      final punto = _puntos[i];
                      final distancia = posicion == null
                          ? null
                          : _ubicacionService.distanciaMetros(
                              posicion.latitude,
                              posicion.longitude,
                              punto.latitud,
                              punto.longitud,
                            );
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.place),
                          title: Text(punto.nombre),
                          subtitle: Text(
                            'Lat: ${punto.latitud.toStringAsFixed(6)}\n'
                            'Lon: ${punto.longitud.toStringAsFixed(6)}\n'
                            '${distancia == null ? 'Obtén tu ubicación para ver la distancia' : 'Distancia: ${_formatoDistancia(distancia)}'}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Abrir en el mapa',
                                icon: const Icon(Icons.map),
                                onPressed: () => _abrirMapa(punto),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _eliminar(punto),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Diálogo para pedir el nombre del lugar. Valida que no esté vacío.
class _DialogoNombre extends StatefulWidget {
  const _DialogoNombre();

  @override
  State<_DialogoNombre> createState() => _DialogoNombreState();
}

class _DialogoNombreState extends State<_DialogoNombre> {
  final _controlador = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _aceptar() {
    final nombre = _controlador.text.trim();
    if (nombre.isEmpty) {
      setState(() => _error = 'Escribe un nombre');
      return;
    }
    Navigator.pop(context, nombre);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nombre del lugar'),
      content: TextField(
        controller: _controlador,
        autofocus: true,
        maxLength: 40,
        decoration: InputDecoration(
          hintText: 'Ej. Tecnológico',
          errorText: _error,
        ),
        onSubmitted: (_) => _aceptar(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _aceptar, child: const Text('Guardar')),
      ],
    );
  }
}
