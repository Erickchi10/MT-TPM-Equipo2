## Práctica 9: Cámara, multimedia y sensores de movimiento

*Objetivo:* integrar captura de imágenes y lectura de sensores para crear interacción con el hardware del dispositivo.

### Contenido

- practica_09_sensores: ejemplo guiado. Toma una foto con image_picker y muestra en vivo el acelerómetro y el giroscopio (X, Y, Z) con sensors_plus.
- practica_09_bitacora: ejercicio evaluable. Bitácora de inspección: cada entrada es una tarjeta de evidencia con foto, fecha, hora y los valores del acelerómetro y del giroscopio. Maneja cancelación de la cámara y permisos denegados, y guarda las inspecciones aunque se cierre la app.

### Requisitos

- Flutter 3.47.2 (canal stable) y Dart 3.13.2.
- Dispositivo Android físico (recomendado) o emulador con cámara y sensores virtuales.
- Paquetes: image_picker 1.2.4 y sensors_plus 7.1.1 (en la bitácora también path_provider y shared_preferences).
- Permiso CAMERA declarado en android/app/src/main/AndroidManifest.xml. El acelerómetro y el giroscopio no necesitan permiso.

### Instalación y ejecución

cd practica_09_bitacora
flutter pub get
flutter run -d <id-del-dispositivo>

Para el ejemplo guiado se hace lo mismo dentro de practica_09_sensores. Los ids de los dispositivos se ven con flutter devices.

### Pruebas

flutter analyze
flutter test

- practica_09_sensores: flutter analyze sin problemas (sin pruebas propias).
- practica_09_bitacora: flutter analyze sin problemas y 11 pruebas automáticas que pasan (formato de fecha y hora, lecturas de sensores, guardado y carga de inspecciones, datos dañados y captura cancelada).
- Casos manuales: permiso de cámara, foto tomada, cancelación, permiso denegado, lectura de acelerómetro, lectura de giroscopio, y que las inspecciones se conserven al cerrar y volver a abrir la app. Las capturas están en docs/evidencias/practica-09/.

### Dispositivos de prueba y limitaciones

- Cámara, permisos y acelerómetro: Huawei Y6p (MED-LX9) físico.
- Ese celular no tiene giroscopio, por lo que la app muestra "No disponible" sin cerrarse. El giroscopio se probó en el emulador Android (Medium_Phone) con Extended controls > Virtual sensors.
- El reloj del emulador va en UTC, por lo que la hora de sus tarjetas difiere de la local.

### Participantes

- Mauricio Gabriel Cih Koh
