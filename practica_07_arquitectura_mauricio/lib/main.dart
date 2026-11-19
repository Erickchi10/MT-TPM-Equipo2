import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tareas_provider.dart';
import 'screens/tareas_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TareasProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 7 - Arquitectura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TareasScreen(),
    );
  }
}
