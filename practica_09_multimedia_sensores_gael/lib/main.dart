import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cámara y sensores',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SensoresPage(),
    );
  }
}

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  XFile? foto;
  DateTime? fechaCaptura;

  double x = 0, y = 0, z = 0;
  double gx = 0, gy = 0, gz = 0;

  double? fotoX, fotoY, fotoZ;
  double? fotoGx, fotoGy, fotoGz;

  StreamSubscription<AccelerometerEvent>? acelerometro;
  StreamSubscription<GyroscopeEvent>? giroscopio;

  @override
  void initState() {
    super.initState();

    acelerometro = accelerometerEventStream().listen((e) {
      if (mounted) {
        setState(() {
          x = e.x;
          y = e.y;
          z = e.z;
        });
      }
    });

    giroscopio = gyroscopeEventStream().listen((e) {
      if (mounted) {
        setState(() {
          gx = e.x;
          gy = e.y;
          gz = e.z;
        });
      }
    });
  }

  Future<void> tomarFoto() async {
    try {
      final archivo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (!mounted) return;

      if (archivo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Captura de fotografía cancelada')),
        );
        return;
      }

      setState(() {
        foto = archivo;
        fechaCaptura = DateTime.now();

        fotoX = x;
        fotoY = y;
        fotoZ = z;

        fotoGx = gx;
        fotoGy = gy;
        fotoGz = gz;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al abrir la cámara: $e')));
    }
  }

  @override
  void dispose() {
    acelerometro?.cancel();
    giroscopio?.cancel();
    super.dispose();
  }

  Widget sensorTexto(String nombre, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '$nombre: ${valor.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara y sensores'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FilledButton.icon(
            onPressed: tomarFoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar fotografía'),
          ),

          const SizedBox(height: 20),

          if (foto != null) ...[
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Bitácora de inspección',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Image.file(
                    File(foto!.path),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha y hora: ${fechaCaptura.toString().split('.').first}',
                        ),

                        const Divider(),

                        const Text(
                          'Acelerómetro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        Text('X: ${fotoX!.toStringAsFixed(2)}'),
                        Text('Y: ${fotoY!.toStringAsFixed(2)}'),
                        Text('Z: ${fotoZ!.toStringAsFixed(2)}'),

                        const Divider(),

                        const Text(
                          'Giroscopio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        Text('X: ${fotoGx!.toStringAsFixed(2)}'),
                        Text('Y: ${fotoGy!.toStringAsFixed(2)}'),
                        Text('Z: ${fotoGz!.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Divider(height: 35),

          const Text(
            'Acelerómetro en tiempo real',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          sensorTexto('X', x),
          sensorTexto('Y', y),
          sensorTexto('Z', z),

          const Divider(height: 35),

          const Text(
            'Giroscopio en tiempo real',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          sensorTexto('X', gx),
          sensorTexto('Y', gy),
          sensorTexto('Z', gz),
        ],
      ),
    );
  }
}
