import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificaciones {
  static final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> iniciar() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await plugin.initialize(settings: settings);
  }

  static Future<bool?> solicitarPermiso() async {
    final androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    return await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> mostrar() async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_practica',
        'Práctica móvil',
        channelDescription: 'Alertas de la aplicación',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    
    await plugin.show(
      id: 1,
      title: 'Tópicos de Programación Móvil',
      body: 'Tienes una actividad pendiente',
      notificationDetails: detalles,
    );

  }
}