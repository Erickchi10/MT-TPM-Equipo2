import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/objetos_provider.dart';
import 'screens/objetos_screen.dart';
import 'services/notificaciones_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificaciones = NotificacionesService();
  await notificaciones.iniciar();
  runApp(App(notificaciones: notificaciones));
}

class App extends StatelessWidget {
  const App({super.key, required this.notificaciones});

  final NotificacionesService notificaciones;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObjetosProvider(notificaciones: notificaciones)
        ..cargar()
        ..cargarResguardantes()
        ..pedirPermisoNotificaciones(),
      child: MaterialApp(
        title: 'Objetos perdidos ITESCAM - Alberto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
        home: const ObjetosScreen(),
      ),
    );
  }
}
