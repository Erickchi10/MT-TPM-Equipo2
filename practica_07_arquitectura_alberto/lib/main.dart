import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'screens/contador_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContadorProvider(),
      child: const AppContador(),
    ),
  );
}

class AppContador extends StatelessWidget {
  const AppContador({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador con Provider',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const ContadorScreen(),
    );
  }
}
