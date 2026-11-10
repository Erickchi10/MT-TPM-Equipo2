
# Práctica 05: Consumo de API REST y procesamiento JSON

## Descripción

Aplicación desarrollada en Flutter que consume información de la API REST de JSONPlaceholder para consultar y visualizar usuarios y publicaciones.

El proyecto permite obtener datos desde internet, procesarlos mediante modelos y mostrarlos en una interfaz gráfica.

## Objetivo

Implementar el consumo de servicios web mediante solicitudes HTTP, procesar respuestas en formato JSON y presentar la información obtenida utilizando Flutter.

## Tecnologías utilizadas

- Flutter
- Dart
- HTTP
- API REST
- JSONPlaceholder

## Funcionalidades

- Consulta y visualización de usuarios.
- Consulta y visualización de publicaciones.
- Visualización de los detalles de una publicación.
- Navegación entre las diferentes pantallas.
- Indicadores de carga durante las solicitudes.
- Manejo de errores de conexión y respuestas vacías.
- Actualización de información mediante el gesto Pull-to-Refresh.
- Botón para reintentar la carga de publicaciones cuando ocurre un error.

## API utilizada

**JSONPlaceholder**

https://jsonplaceholder.typicode.com/

Endpoints utilizados:

- `/users`: consulta de usuarios.
- `/posts`: consulta de publicaciones.

## Estructura del proyecto

```text
practica_05_api_gael/
├── lib/
│   └── main.dart
├── test/
│   └── widget_test.dart
├── android/
├── web/
├── windows/
├── pubspec.yaml
└── README.md
```

## Requisitos

- Flutter SDK instalado.
- Dart SDK.
- Visual Studio Code o un editor compatible.
- Conexión a internet para consumir la API.

## Instalación y ejecución

1. Clonar el repositorio.
2. Abrir la carpeta del proyecto.
3. Instalar las dependencias:

```bash
flutter pub get
```

4. Ejecutar la aplicación:

```bash
flutter run
```

## Pruebas y validación

Para revisar el formato del código:

```bash
dart format lib test
```

Para analizar el proyecto:

```bash
flutter analyze
```

Para ejecutar las pruebas:

```bash
flutter test
```

## Autor

**Gael Can**

Práctica 05 - Consumo de API REST y procesamiento JSON.
