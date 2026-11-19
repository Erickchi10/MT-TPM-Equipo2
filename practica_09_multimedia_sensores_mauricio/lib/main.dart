import 'package:flutter/material.dart';
import 'screens/inspeccion_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BitacoraApp());
}

class BitacoraApp extends StatelessWidget {
  const BitacoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitácora de Inspección',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const InspeccionPage(),
    );
  }
}
