# FRB · Arquitectura de integración (borrador técnico)

Fecha de revisión: 2026-11-04. Aplicación independiente aún sin nombre oficial. No confundir con Catalogía ni con el catálogo público. Este documento no aprueba diseños ni altera originales.

## Evidencia revisada
- Repositorio `lokojomby777/flutter-starter-app`, rama `main`: `pubspec.yaml` declara Flutter, Riverpod, GoRouter, Supabase, almacenamiento seguro, preferencias, Dio y localización; `lib/main.dart` inicializa errores, preferencias y ProviderScope. La declaración de dependencias **no** demuestra que las funciones estén implementadas.
- No se verificó una compilación ni prueba en dispositivos en esta revisión.

## Fronteras de módulos
1. **Shell/navegación**: rutas tipadas, estado de sesión, pantalla principal, controles accesibles; las plantillas y assets visuales requieren aprobación independiente.
2. **Identidad y permisos**: autenticación mediante contraseña y credenciales seguras; voz y patrones de uso solo como señales auxiliares, nunca autenticación única. Consentimiento por función y permisos solicitados al usarse.
3. **Voz**: captura con micrófono, STT, comandos, respuesta TTS, cancelación y control de errores; proveedor reemplazable detrás de interfaces.
4. **Traducción**: detector de idioma, traducción texto/voz, manejo de idioma origen/destino y modo sin conexión si proveedor lo soporta.
5. **OCR/cámara**: selección de imagen, captura opcional, extracción local o servicio autorizado, borrado de datos temporales.
6. **Ventanilla asistente**: widget dentro de la app en ambas plataformas; overlay sobre otras apps solo con permiso y API Android donde proceda. En iOS no prometer una burbuja flotante general sobre otras aplicaciones.
7. **Archivos/assets**: manifiesto con ID, fuente, versión, hash, estado aprobado/borrador y permiso de uso; no sobrescribir ni borrar Jomby, stickers ni diseños originales.
8. **Integraciones**: adaptadores de servicios externos, manejo de tokens seguro, degradación cuando una conexión no esté disponible.
9. **Telemetría y pruebas**: diagnósticos sin datos sensibles, pruebas unitarias, de widgets, de integración y manuales iPhone/Motorola.

## Contratos de integración
- `PermissionGateway.request(capability)` devuelve granted/denied/restricted/unavailable; nunca infiere permiso concedido.
- `VoiceService.listen(locale)` emite partial/final/error/cancelled; interrupciones y silencio no bloquean navegación.
- `TranslationService.translate(text,source,target)` devuelve resultado y procedencia, o error recuperable.
- `OcrService.extract(image)` devuelve texto con metadatos y estado de consentimiento.
- `AssistantOverlay.show()` comprueba capacidad de plataforma antes de mostrar; fallback en pantalla para iOS.
- `ApprovedAssetRepository.get(id,version)` solo resuelve assets aprobados, sin mutar originales.

## Matriz mínima de pruebas cruzadas
- Navegación ↔ voz: iniciar, detener, perder permiso y recuperar; comprobar que botones sigan funcionando.
- Voz ↔ traducción ↔ TTS: idiomas distintos, cancelación, latencia, desconexión y errores del proveedor.
- Cámara ↔ OCR ↔ traducción: imagen válida, acceso denegado, rotación, idioma mixto, datos temporales.
- Overlay ↔ navegación ↔ teclado: minimizar, restaurar, orientación y accesibilidad; iOS fallback obligatorio.
- Identidad ↔ almacenamiento ↔ integraciones: cierre de sesión, revocación, token caducado, dispositivo nuevo.
- Assets ↔ UI: hash y versiones de logos aprobados, tipografía correcta, no duplicados ni reemplazos.

## Gates antes de declarar versión lista
1. `flutter pub get`, `flutter analyze` y `flutter test` exitosos con logs verificables.
2. Prueba de arranque, navegación y permisos en emulador Android y simulador iOS (o hardware cuando aplique).
3. Pruebas en Motorola y iPhone reales para micrófono, cámara, interrupciones, background y restricciones de overlay.
4. Aprobación visual de plantillas/identidad y verificación de licencias/proveedores antes de incluir assets.
5. No fusionar PR ni publicar sin revisión del propietario.

## Dependencias del propietario (solo solicitar cuando sean imprescindibles)
- Assets y pantallas aprobadas; credenciales de proveedores solo mediante flujo seguro, nunca en chats o código.
- Cuenta Apple Developer y firma iOS solo cuando sea necesario distribuir en dispositivo/TestFlight; configuración Android de firma cuando llegue la fase de distribución.
- Aclarar expectativas de uso de overlay fuera de la app en iOS antes de comprometer diseño.

## Estado
Arquitectura documentada; implementación y pruebas cruzadas **pendientes de evidencia**. No se ha modificado código, tareas, diseños aprobados ni archivos originales.
