import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notificaciones locales. Si algo falla, la app sigue funcionando.
class NotificacionesService {
  FlutterLocalNotificationsPlugin? _plugin;

  Future<void> iniciar() async {
    try {
      final plugin = FlutterLocalNotificationsPlugin();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await plugin.initialize(
        settings: const InitializationSettings(android: android),
      );
      _plugin = plugin;
    } catch (e) {
      debugPrint('No se pudieron iniciar las notificaciones: $e');
    }
  }

  /// Android 13 o superior pide permiso. Regresa true si se puede notificar.
  Future<bool> pedirPermiso() async {
    final android = _plugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return false;
    return await android.requestNotificationsPermission() ?? false;
  }

  Future<void> mostrar({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    final plugin = _plugin;
    if (plugin == null) return;
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'incidencias',
        'Incidencias',
        channelDescription: 'Aviso cuando se guarda un reporte',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    try {
      await plugin.show(
        id: id,
        title: titulo,
        body: cuerpo,
        notificationDetails: detalles,
      );
    } catch (e) {
      debugPrint('No se pudo mostrar la notificación: $e');
    }
  }
}
