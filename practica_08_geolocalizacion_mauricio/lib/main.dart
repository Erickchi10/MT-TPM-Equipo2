import 'package:flutter/material.dart';
import 'screens/ubicacion_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GeoPointsApp());
}

class GeoPointsApp extends StatelessWidget {
  const GeoPointsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 8 - Geolocalización y Mapas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
      ),
      home: const UbicacionPage(),
    );
  }
}
