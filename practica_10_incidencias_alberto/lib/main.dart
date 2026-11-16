import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/incidencias_provider.dart';
import 'screens/incidencias_screen.dart';
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
      create: (_) => IncidenciasProvider(notificaciones: notificaciones)
        ..cargar()
        ..cargarAvisos()
        ..pedirPermisoNotificaciones(),
      child: MaterialApp(
        title: 'Incidencias - Alberto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.deepOrange,
          useMaterial3: true,
        ),
        home: const IncidenciasScreen(),
      ),
    );
  }
}
