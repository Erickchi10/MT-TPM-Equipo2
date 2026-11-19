## Práctica 10: Notificaciones y proyecto móvil integrador

*Rama:* practica-10-integracion-final

### Objetivo
Integrar las competencias del curso en aplicaciones móviles funcionales y configurar notificaciones locales como base para alertas al usuario.

### Proyectos
- practica_10_incidencias: ejemplo guiado Reporte Móvil de Incidencias. Formulario validado (título, descripción y categoría), foto, latitud y longitud, fecha y hora, persistencia local, lista sin conexión, detalle, avisos desde una API REST y notificación local al guardar.
- practica_10_mantenimiento: ejercicio evaluable Órdenes de Mantenimiento. Formulario validado (equipo, descripción, prioridad y técnico), técnicos descargados de una API REST con estados de carga y error, foto con la cámara, persistencia local, cambio de estado de la orden (Pendiente, En proceso, Terminada), filtro por estado, detalle y notificaciones locales.

### Requisitos
- Flutter 3.47.2 (canal stable) y Dart 3.13.2
- Dispositivo Android físico (probado en Huawei Y6p, Android 10) o emulador
- Paquetes: flutter_local_notifications, image_picker, geolocator (solo incidencias), shared_preferences, path_provider, http

### Instalación y ejecución
cd practica_10_incidencias   # o practica_10_mantenimiento
flutter pub get
flutter run
Nota de configuración Android: flutter_local_notifications requiere compileSdk = 37, el desugaring de librerías (isCoreLibraryDesugaringEnabled) y la línea android.suppressUnsupportedCompileSdk=37 en android/gradle.properties.

### Pruebas
dart format lib test
flutter analyze
flutter test
- practica_10_incidencias: 6 pruebas automáticas.
- practica_10_mantenimiento: 8 pruebas automáticas.
- Casos manuales en dispositivo físico (formulario, permisos, API con y sin conexión, notificaciones, persistencia) en docs/evidencias/practica-10/.

### Participantes
- Mauricio Gabriel Cih Koh