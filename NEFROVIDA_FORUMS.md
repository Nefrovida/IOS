# Foros (Forums) - NEFROVida iOS

Este documento resume la interfaz y la integración con la API para la funcionalidad de foros de pacientes (role_id: 3).

Pantallas:
- `Tus Foros` (lista de foros) — `ForumsListScreen`
- `Foro x` (detalle con posts) — `ForumDetailScreen`

Arquitectura:
- MVVM similar al módulo `AgendaScreen` existente.
- `Domain/Entity` contiene `Forum` y `Post`.
- `Domain/Repository/ForumRepository` define la interfaz.
- `Data/Repository` contiene `MockForumRepository` para pruebas y `RemoteForumRepository` (Alamofire) para llamadas reales al backend.
- `Domain/UseCases` contiene `GetForumsUseCase`, `GetMyForumsUseCase`, `GetForumDetailsUseCase`, `JoinForumUseCase`.

Endpoints:
- GET /api/forums — listar foros públicos (y filtrado opcional). Paginación y búsqueda. Usado para llenar la pantalla `Tus Foros`.
- GET /api/forums/me — lista de foros donde el paciente es miembro. Usado para marcar tarjetas con "Miembro".
- GET /api/forums/:forumId — obtiene detalles y posts del foro para `ForumDetailScreen`.
- POST /api/forums/:forumId/join — manejar unión a foros públicos.

Autenticación:
- JWT en header: Authorization: Bearer {token}. Todos los endpoints deben autenticarse.

UI y diseño:
- Tipografía: Sans-serif; títulos en `fontWeight(.bold)`; cuerpo `regular`.
- Paleta: `nvBrand` como azul oscuro para textos y `nvLightBlue` para botones/acentos.
- Tarjetas con `cornerRadius(16)` y sombreado sutil.

Comportamiento:
- Loading: `ProgressView` y skeleton locales (más adelante se puede completar con Shimmer).
- Error: mensaje y botón "Reintentar" como en `AgendaScreen`.
- Empty: "No hay foros disponibles".
- Truncar nombres largos: UI muestra nombre abreviado si es muy largo.
- Posts: multilinea, soporte de URLs (autolink) y truncado si necesario.

Futuras mejoras:
- Implementar cache y pull-to-refresh.
- Habilitar WebSockets para updates en tiempo real.
- Implementar aislamiento de token seguro (Keychain) y manejo de expiración.
- Añadir tests unitarios y UI tests para los flujos de join y error.

Cómo probar en desarrollo:
1. Abrir `ForumsListScreen` en `Preview` (SwiftUI) desde Xcode: selecciona el archivo y el Preview.
2. Por defecto usa `MockForumRepository` y mocked posts.
3. Para probar requests reales, inicializa `ForumsViewModel` y `ForumDetailViewModel` con `RemoteForumRepository` y un `tokenProvider` funcional que retorne un JWT.

Ejemplo de uso en código (para testing):
```swift
let repo = MockForumRepository()
let listVM = ForumsViewModel(getForumsUC: GetForumsUseCase(repository: repo), getMyForumsUC: GetMyForumsUseCase(repository: repo))
```

---

Si deseas, puedo:
- Añadir soporte para la unión automática cuando se presiona "Entrar" en un foro público.
- Implementar un botón de "Reintentar" con manejo de errores más rico (mapeo de 401/403/404).
- Agregar pruebas unitarias para `ForumsViewModel` y `ForumDetailViewModel`.
