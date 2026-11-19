
## Práctica 8: GPS, geolocalización y mapas

*Rama:* practica-08-geolocalizacion

### Objetivo
Solicitar permisos de ubicación, obtener las coordenadas del dispositivo, calcular distancias y abrir un mapa externo.

### Proyectos
- practica_08_ubicacion: ejemplo guiado. Pide el permiso en tiempo de ejecución, muestra latitud, longitud y precisión, calcula la distancia a un punto de referencia (Calkiní, Campeche) y abre el mapa.
- practica_08_puntos: ejercicio evaluable. App de puntos de interés: guarda ubicaciones con nombre (se conservan al cerrar la app con shared_preferences), muestra latitud y longitud de cada una, calcula la distancia desde la posición actual con Geolocator.distanceBetween y abre cada punto en un mapa externo.

### Requisitos
- Flutter 3.47.2 (stable) y Dart 3.13.2
- Emulador Android o dispositivo físico con ubicación activa
- Paquetes: geolocator 14.1.2, url_launcher 6.3.3 y shared_preferences 2.5.6 (solo en practica_08_puntos)
- Permisos ACCESS_FINE_LOCATION y ACCESS_COARSE_LOCATION en AndroidManifest.xml, y consultas https y geo para abrir el mapa

### Instalación y ejecución
cd practica_08_puntos
flutter pub get
flutter run -d <id-del-dispositivo>
Lo mismo aplica para practica_08_ubicacion. En el emulador, la ubicación se cambia desde Extended controls > Location.

### Pruebas
flutter analyze
flutter test
Resultado: flutter analyze sin problemas en los dos proyectos y flutter test con 7 pruebas aprobadas en practica_08_puntos. Las pruebas manuales (permisos, GPS apagado, guardado de 3 puntos, distancias, mapa y persistencia) están en docs/evidencias/practica-08/.

### Participantes
- Mauricio Gabriel Cih Koh