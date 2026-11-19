import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/punto_interes.dart';
import '../services/ubicacion_service.dart';
import '../services/puntos_storage_service.dart';
import '../widgets/punto_card.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  final UbicacionService _ubicacionService = UbicacionService();
  final PuntosStorageService _storageService = PuntosStorageService();

  Position? posicionActual;
  bool cargando = false;
  bool cargandoPuntos = true;

  String mensaje = 'Todavía no se ha obtenido la ubicación.';

  final List<PuntoInteres> puntos = [];

  @override
  void initState() {
    super.initState();
    cargarPuntosGuardados();
  }

  Future<void> cargarPuntosGuardados() async {
    try {
      final guardados = await _storageService.cargarPuntos();

      if (!mounted) return;

      setState(() {
        puntos.addAll(guardados);
        cargandoPuntos = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargandoPuntos = false;
      });
    }
  }

  Future<void> guardarPuntos() async {
    try {
      await _storageService.guardarPuntos(puntos);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron guardar los lugares.')),
      );
    }
  }

  Future<void> obtenerUbicacion() async {
    setState(() {
      cargando = true;
      mensaje = 'Obteniendo ubicación...';
    });

    try {
      final posicion = await _ubicacionService.obtenerUbicacion();

      if (!mounted) return;

      setState(() {
        posicionActual = posicion;
        mensaje = 'Ubicación obtenida correctamente.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = e.toString().replaceFirst('Exception: ', '');
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  double? calcularDistancia(PuntoInteres punto) {
    if (posicionActual == null) return null;

    return _ubicacionService.calcularDistancia(
      posicionActual!.latitude,
      posicionActual!.longitude,
      punto.latitud,
      punto.longitud,
    );
  }

  Future<void> agregarPunto() async {
    final resultado = await showDialog<PuntoInteres>(
      context: context,
      builder: (dialogContext) {
        return FormularioPuntoDialog(posicionActual: posicionActual);
      },
    );

    if (resultado != null && mounted) {
      setState(() {
        puntos.add(resultado);
      });

      await guardarPuntos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${resultado.nombre} guardado correctamente.')),
      );
    }
  }

  Future<void> abrirMapa(double latitud, double longitud) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud',
    );

    try {
      final abierto = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el mapa.')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al abrir el mapa: $e')));
    }
  }

  Future<void> eliminarPunto(int indice) async {
    final nombre = puntos[indice].nombre;

    setState(() {
      puntos.removeAt(indice);
    });

    await guardarPuntos();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$nombre eliminado.')));
  }

  Widget construirInformacionGPS() {
    if (posicionActual == null) {
      return const Text(
        'Presiona el botón para consultar las coordenadas de tu dispositivo.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latitud: ${posicionActual!.latitude.toStringAsFixed(6)}'),
        const SizedBox(height: 8),
        Text('Longitud: ${posicionActual!.longitude.toStringAsFixed(6)}'),
        const SizedBox(height: 8),
        Text(
          'Precisión: ${posicionActual!.accuracy.toStringAsFixed(2)} metros',
        ),
        const SizedBox(height: 8),
        Text('Altitud: ${posicionActual!.altitude.toStringAsFixed(2)} metros'),
        const SizedBox(height: 8),
        Text('Velocidad: ${posicionActual!.speed.toStringAsFixed(2)} m/s'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoPoints'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: agregarPunto,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Agregar lugar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.my_location,
                    size: 55,
                    color: Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Mi ubicación actual',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  construirInformacionGPS(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: cargando ? null : obtenerUbicacion,
                      icon: cargando
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.gps_fixed),
                      label: Text(
                        cargando
                            ? 'Obteniendo ubicación...'
                            : 'Obtener ubicación',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  if (posicionActual != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => abrirMapa(
                        posicionActual!.latitude,
                        posicionActual!.longitude,
                      ),
                      icon: const Icon(Icons.map),
                      label: const Text('Ver mi ubicación en Google Maps'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Mis puntos de interés',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Chip(
                label: Text('${puntos.length} lugares'),
                avatar: const Icon(Icons.place, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (cargandoPuntos)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (puntos.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.location_off, size: 45, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Todavía no tienes lugares guardados.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Presiona "Agregar lugar" para registrar tu primer punto de interés.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(puntos.length, (indice) {
              final punto = puntos[indice];

              return PuntoCard(
                punto: punto,
                distancia: calcularDistancia(punto),
                onAbrirMapa: () => abrirMapa(punto.latitud, punto.longitud),
                onEliminar: () => eliminarPunto(indice),
              );
            }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class FormularioPuntoDialog extends StatefulWidget {
  final Position? posicionActual;

  const FormularioPuntoDialog({super.key, required this.posicionActual});

  @override
  State<FormularioPuntoDialog> createState() => _FormularioPuntoDialogState();
}

class _FormularioPuntoDialogState extends State<FormularioPuntoDialog> {
  final GlobalKey<FormState> formularioKey = GlobalKey<FormState>();

  late final TextEditingController nombreController;
  late final TextEditingController latitudController;
  late final TextEditingController longitudController;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController();

    latitudController = TextEditingController(
      text: widget.posicionActual?.latitude.toString() ?? '',
    );

    longitudController = TextEditingController(
      text: widget.posicionActual?.longitude.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    latitudController.dispose();
    longitudController.dispose();
    super.dispose();
  }

  void guardarPunto() {
    if (!formularioKey.currentState!.validate()) {
      return;
    }

    final punto = PuntoInteres(
      nombre: nombreController.text.trim(),
      latitud: double.parse(latitudController.text.trim()),
      longitud: double.parse(longitudController.text.trim()),
    );

    Navigator.of(context).pop(punto);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo punto de interés'),
      content: Form(
        key: formularioKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del lugar',
                  prefixIcon: Icon(Icons.place),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre del lugar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: latitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final numero = double.tryParse(value ?? '');

                  if (numero == null || numero < -90 || numero > 90) {
                    return 'Latitud inválida (-90 a 90)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: longitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final numero = double.tryParse(value ?? '');

                  if (numero == null || numero < -180 || numero > 180) {
                    return 'Longitud inválida (-180 a 180)';
                  }
                  return null;
                },
              ),
              if (widget.posicionActual != null) ...[
                const SizedBox(height: 10),
                const Text(
                  'Las coordenadas actuales se han colocado automáticamente. Puedes modificarlas.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: guardarPunto, child: const Text('Guardar')),
      ],
    );
  }
}
