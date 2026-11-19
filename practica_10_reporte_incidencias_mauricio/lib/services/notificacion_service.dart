import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacionService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _canal = AndroidNotificationChannel(
    'canal_reportes',
    'Reportes de incidencias',
    description: 'Notificaciones cuando se registra una incidencia',
    importance: Importance.high,
  );

  static Future<void> inicializar() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_canal);

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> mostrarReporteGuardado({
    required String tituloReporte,
  }) async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_reportes',
        'Reportes de incidencias',
        channelDescription: 'Notificaciones cuando se registra una incidencia',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      title: 'Reporte registrado correctamente',
      body: 'Se guardó la incidencia: $tituloReporte',
      notificationDetails: detalles,
    );
  }
}
