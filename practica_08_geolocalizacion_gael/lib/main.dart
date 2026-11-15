import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Puntos de Interés GPS',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157A4)),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const HomePage(),
    );
  }
}

class InterestPoint {
  final String name;
  final double latitude;
  final double longitude;

  const InterestPoint({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPosition;
  bool loading = false;
  String status = 'Esperando ubicación';
  String? errorMessage;

  final List<InterestPoint> points = [];

  // Obtiene la ubicación actual del dispositivo.
  Future<void> getCurrentLocation() async {
    setState(() {
      loading = true;
      errorMessage = null;
      status = 'Obteniendo ubicación...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Activa el servicio de ubicación del dispositivo.');
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permiso bloqueado. Actívalo desde la configuración.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        status = 'Ubicación obtenida correctamente';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        status = 'No se pudo obtener la ubicación';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // Registra un punto de interés con nombre y coordenadas.
  Future<void> addPoint() async {
    final nameController = TextEditingController();
    final latitudeController = TextEditingController(
      text: currentPosition?.latitude.toString() ?? '',
    );
    final longitudeController = TextEditingController(
      text: currentPosition?.longitude.toString() ?? '',
    );

    final formKey = GlobalKey<FormState>();

    final newPoint = await showDialog<InterestPoint>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo punto de interés'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del lugar',
                      prefixIcon: Icon(Icons.place_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe el nombre del lugar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Latitud',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final number = double.tryParse(value ?? '');
                      if (number == null || number < -90 || number > 90) {
                        return 'Latitud inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Longitud',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final number = double.tryParse(value ?? '');
                      if (number == null || number < -180 || number > 180) {
                        return 'Longitud inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Puedes utilizar tu ubicación actual '
                    'o introducir otras coordenadas.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(
                    dialogContext,
                    InterestPoint(
                      name: nameController.text.trim(),
                      latitude: double.parse(latitudeController.text),
                      longitude: double.parse(longitudeController.text),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

  // Esperar a que termine la transición de cierre del diálogo.
await Future<void>.delayed(const Duration(milliseconds: 300));

nameController.dispose();
latitudeController.dispose();
longitudeController.dispose();
    if (newPoint != null && mounted) {
      setState(() {
        points.add(newPoint);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Punto de interés guardado correctamente'),
        ),
      );
    }
  }

  // Calcula la distancia entre la posición actual y un punto.
  String calculateDistance(InterestPoint point) {
    if (currentPosition == null) {
      return 'Actualiza tu ubicación para calcular la distancia';
    }

    final meters = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      point.latitude,
      point.longitude,
    );

    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }

    return '${meters.toStringAsFixed(0)} metros';
  }

  // Abre las coordenadas del punto en Google Maps.
  Future<void> openMap(InterestPoint point) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${point.latitude},${point.longitude}',
    );

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && mounted) {
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

  Widget buildLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.my_location, color: Color(0xFF3157A4)),
                SizedBox(width: 10),
                Text(
                  'Mi ubicación actual',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(status),
            if (loading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            if (currentPosition != null) ...[
              const Divider(height: 24),
              Text('Latitud: ${currentPosition!.latitude.toStringAsFixed(6)}'),
              const SizedBox(height: 8),
              Text(
                'Longitud: ${currentPosition!.longitude.toStringAsFixed(6)}',
              ),
              const SizedBox(height: 8),
              Text(
                'Precisión: ${currentPosition!.accuracy.toStringAsFixed(2)} m',
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: loading ? null : getCurrentLocation,
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Obtener ubicación GPS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPointsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Puntos de interés',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(radius: 17, child: Text('${points.length}')),
              ],
            ),
            const SizedBox(height: 12),
            if (points.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Todavía no tienes puntos registrados.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ...points.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;

              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      point.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lat: ${point.latitude.toStringAsFixed(6)}'),
                        Text('Lon: ${point.longitude.toStringAsFixed(6)}'),
                        Text('Distancia: ${calculateDistance(point)}'),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: 'Abrir en Google Maps',
                      icon: const Icon(Icons.map_outlined),
                      onPressed: () => openMap(point),
                    ),
                  ),
                  const Divider(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Puntos de Interés GPS'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Explora y registra ubicaciones',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Consulta tu posición y calcula distancias '
            'a diferentes lugares.',
          ),
          const SizedBox(height: 18),
          buildLocationCard(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: addPoint,
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Agregar punto de interés'),
            ),
          ),
          const SizedBox(height: 12),
          buildPointsList(),
        ],
      ),
    );
  }
}
