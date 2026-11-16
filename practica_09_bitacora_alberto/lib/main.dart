import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/bitacora_provider.dart';
import 'screens/bitacora_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BitacoraProvider()..cargar(),
      child: MaterialApp(
        title: 'Bitácora de inspección - Alberto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const BitacoraScreen(),
      ),
    );
  }
}
