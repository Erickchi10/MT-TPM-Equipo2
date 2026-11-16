import 'package:flutter/material.dart';

import 'screens/sensores_screen.dart';
import 'services/camara_service.dart';
import 'services/sensores_service.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 9 - Alberto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: SensoresScreen(
        camara: CamaraService(),
        sensores: SensoresService(),
      ),
    );
  }
}
