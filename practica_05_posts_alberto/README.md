# Práctica 5 — Consumo de API REST y Procesamiento JSON

**Alumno:** Alberto Sánchez Ucan
**Materia:** Tópicos de Programación Móvil — ITESCAM
**Rama:** `practica-05-alberto`

## Objetivo
Consumir un servicio REST mediante HTTP, convertir JSON a objetos Dart y representar los estados de carga, éxito, error y lista vacía.

## Requisitos
- Flutter SDK 3.x y Dart 3.x
- Paquete `http`
- Conexión a Internet
- Chrome o emulador Android

## Instalación y ejecución
```bash
cd practica_05_posts_alberto
flutter pub get
flutter run -d chrome
```

## API utilizada
| Endpoint | Método | Respuesta |
|---|---|---|
| `https://jsonplaceholder.typicode.com/users` | GET | Lista de usuarios (`id`, `name`, `email`) |
| `https://jsonplaceholder.typicode.com/posts` | GET | Lista de 100 publicaciones (`userId`, `id`, `title`, `body`) |

## Proyectos incluidos
- **practica_05_api_alberto** — Ejemplo guiado: lista de usuarios con `FutureBuilder` y `RefreshIndicator`.
- **practica_05_posts_alberto** — Ejercicio evaluable: lista de 100 publicaciones con pantalla de detalle.

## Estructura del ejercicio evaluable
```
lib/
├── models/publicacion.dart          # Modelo y fromJson
├── services/api_publicaciones.dart  # Petición HTTP y validación del status
├── widgets/publicacion_tile.dart    # Widget reutilizable de cada tarjeta
├── screens/lista_publicaciones.dart # Lista con carga, error, vacío y RefreshIndicator
├── screens/detalle_publicacion.dart # Pantalla de detalle
└── main.dart
```

## Pruebas realizadas
- `flutter analyze`: No issues found!
- `flutter test`: 5 pruebas pasadas (fromJson, error HTTP, carga y lista, error con botón Reintentar, navegación al detalle). Se usa `MockClient` para no depender de Internet.
- Manuales en Chrome: carga, lista de 100 publicaciones, detalle, recarga deslizando y error sin conexión con botón Reintentar.

## Evidencias
`docs/evidencias/practica-05-alberto/`

