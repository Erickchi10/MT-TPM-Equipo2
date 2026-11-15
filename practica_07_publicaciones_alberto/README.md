# Práctica 7 — Arquitectura Flutter, Componentes, Paquetes y Optimización

**Alumno:** Alberto Sánchez Ucan
**Materia:** Tópicos de Programación Móvil — ITESCAM
**Rama:** `practica-07-alberto`

## Objetivo
Estructurar una aplicación Flutter escalable, integrar paquetes externos y aplicar prácticas básicas de rendimiento.

## Requisitos
- Flutter SDK 3.x y Dart 3.x
- Paquetes: `provider`, `intl` (guiado); `provider`, `http`, `share_plus` (evaluable)
- Chrome y/o emulador Android, conexión a Internet

## Instalación y ejecución
```bash
cd practica_07_publicaciones_alberto
flutter pub get
flutter run -d chrome        # o: flutter run -d emulator-5554
```

## Proyectos incluidos
- **practica_07_arquitectura_alberto** — Ejemplo guiado: contador con `ContadorProvider`, historial con fecha y hora (`intl`) y widgets reutilizables.
- **practica_07_publicaciones_alberto** — Ejercicio evaluable: refactorización de `practica_05_posts_alberto` con Provider, búsqueda, favoritos y compartir.

## Estructura del ejercicio evaluable
```
lib/
├── models/publicacion.dart                 # Reutilizado de la práctica 5
├── services/api_publicaciones.dart         # Reutilizado de la práctica 5
├── services/compartir_service.dart         # Compartir con share_plus
├── providers/publicaciones_provider.dart   # Estado: carga, error, búsqueda, favoritos
├── widgets/publicacion_tile.dart           # Tarjeta con favorito
├── widgets/barra_busqueda.dart
├── widgets/boton_filtro_favoritos.dart     # Contador de favoritos (Badge)
├── widgets/estado_error.dart
├── screens/lista_publicaciones.dart
├── screens/detalle_publicacion.dart
└── main.dart                               # ChangeNotifierProvider en la raíz
```

## Paquetes externos y justificación
| Paquete | Uso |
|---|---|
| `provider` | Separa el estado de la interfaz; las pantallas solo leen y muestran |
| `share_plus` | Compartir una publicación con el menú nativo de Android o el del navegador |
| `intl` (guiado) | Formato de fecha/hora y números en el historial |
| `http` | Consumo de la API REST (JSONPlaceholder) |

## Optimización aplicada
- `ListView.builder` en las listas.
- `const` en widgets constantes.
- El filtro se calcula en el provider al cambiar la búsqueda o los favoritos, no dentro de `build()`.
- `context.select` en el encabezado del contador y en el botón de favoritos, para redibujar solo lo necesario.

## Pruebas realizadas
- `flutter analyze`: No issues found! (ambos proyectos)
- `flutter test`: 7 pruebas (guiado) y 6 pruebas (evaluable), con `MockClient` para no depender de Internet.
- Manuales en Chrome y en emulador Android (Pixel_Ligero, API 34).

## Diferencias observadas entre destinos
- Chrome abrió un poco más rápido y se sintió más fluido que el emulador.
- En el emulador (pantalla de 720 px) los botones del contador se partían en dos líneas; se corrigió con `FittedBox`.
- El emulador muestra la hora en UTC (6 horas adelante de la laptop).
- "Compartir" abre el menú nativo de Android en el emulador y la ventana del navegador/Windows en Chrome.

## Flutter frente a una solución nativa hipotética
| Aspecto | Flutter | Nativo (Kotlin + Swift) |
|---|---|---|
| Tiempo de desarrollo | Un solo código para Android, iOS y web | Dos apps separadas, casi el doble de trabajo |
| Portabilidad | La misma app corrió en Chrome y Android sin cambios | Cada plataforma requiere su propio código |
| Desempeño percibido | Fluido en Chrome; aceptable en el emulador con 8 GB de RAM | Ligeramente mejor y más integrado con el sistema |

## Evidencias
`docs/evidencias/practica-07-alberto/`