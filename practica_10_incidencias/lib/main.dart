import 'package:flutter/material.dart';

import 'screens/inicio_page.dart';

void main() {
  runApp(const IncidenciasApp());
}

class IncidenciasApp extends StatelessWidget {
  const IncidenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reporte Móvil de Incidencias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}
