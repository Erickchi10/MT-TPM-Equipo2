import 'package:flutter/material.dart';

import 'screens/inicio_page.dart';

void main() {
  runApp(const MantenimientoApp());
}

class MantenimientoApp extends StatelessWidget {
  const MantenimientoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Órdenes de Mantenimiento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}
