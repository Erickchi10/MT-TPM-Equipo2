import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'providers/tareas_provider.dart';
import 'screens/home_screen.dart';
import 'services/tareas_service.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContadorProvider()),
        ChangeNotifierProvider(
          create: (_) => TareasProvider(TareasService())..cargar(),
        ),
      ],
      child: MaterialApp(
        title: 'Práctica 7',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
