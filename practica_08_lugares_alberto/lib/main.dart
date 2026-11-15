import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/lugares_provider.dart';
import 'screens/lugares_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LugaresProvider()..cargar(),
      child: const AppLugares(),
    ),
  );
}

class AppLugares extends StatelessWidget {
  const AppLugares({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Puntos de interés',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const LugaresScreen(),
    );
  }
}
