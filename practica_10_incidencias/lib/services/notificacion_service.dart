import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacionService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inicializado = false;

  Future<void> inicializar() async {
    if (_inicializado) return;
    const ajustes = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings: ajustes);
    _inicializado = true;
  }

  /// Pide el permiso de notificaciones (Android 13 o superior).
  /// Devuelve true si el usuario lo concedió.
  Future<bool> pedirPermiso() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final concedido = await android?.requestNotificationsPermission();
    return concedido ?? false;
  }

  /// Muestra una notificación local. Nunca lanza excepciones.
  Future<void> mostrar({required String titulo, required String cuerpo}) async {
    try {
      await inicializar();
      const detalles = NotificationDetails(
        android: AndroidNotificationDetails(
          'incidencias',
          'Incidencias',
          channelDescription: 'Avisos al guardar un reporte',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      await _plugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: titulo,
        body: cuerpo,
        notificationDetails: detalles,
      );
    } catch (_) {
      // Si falla la notificación, la app sigue funcionando.
    }
  }
}
