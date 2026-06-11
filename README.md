# BankOS 🏦

App bancaria multitenant construida con Flutter. Permite gestionar cuentas, 
consultar movimientos y realizar operaciones financieras (depósitos, retiros y transferencias).

---

## Stack técnico

- **Flutter** 3.41.9 / **Dart** 3.11.5
- **Riverpod** — manejo de estado
- **GoRouter** — navegación
- **flutter_secure_storage** — almacenamiento seguro de JWT
- **google_fonts** — tipografía Inter
- **uuid** — generación de Idempotency-Keys
- **intl** — formateo de monedas y fechas

---

## Arquitectura
lib/
├── core/
│   ├── theme/          # AppColors + AppTheme
│   ├── router/         # GoRouter con todas las rutas
│   ├── constants/      # URLs, keys, tasas mock
│   └── utils/          # IdempotencyHelper
├── features/
│   ├── auth/           # Login, JWT, secure storage
│   ├── dashboard/      # Cuentas del usuario
│   ├── transactions/   # Historial y detalle
│   └── operations/     # Depósito, retiro, transferencia
└── shared/
└── widgets/        # Componentes reutilizables

Cada feature sigue la estructura:
feature/
├── data/           # Repository (mock → backend)
├── domain/         # Modelos con @immutable
└── presentation/
├── providers/  # Riverpod StateNotifier / FutureProvider
└── screens/    # Widgets de UI

---

## Instalación

```bash
git clone https://github.com/TU_USUARIO/bank_os_repo.git
cd bank_os_repo
flutter pub get
flutter run
```

---

## Usuarios mock

| Email | Contraseña | Rol |
|-------|-----------|-----|
| admin@bancolombia.com | Admin123! | admin |
| cliente@bancolombia.com | Cliente123! | client |

**PIN mock para operaciones:** `1234`

---

## Cuentas mock (Tenant: bancolombia-demo)

| Número | Moneda | Saldo | Estado |
|--------|--------|-------|--------|
| 001-234567 | COP | 5,000,000 | Activa |
| 001-234568 | USD | 1,200 | Activa |
| 001-234569 | COP | 0 | Inactiva |

---

## Flujo de navegación
Login
└── Dashboard
├── Historial
│     └── Detalle transacción
├── Depositar
│     └── Resumen → PIN → Estado
├── Retirar
│     └── Resumen → PIN → Estado
└── Transferir
└── Resumen → PIN → Estado

---

## Integración backend

Los endpoints están documentados en cada repository con el patrón:

```dart
// BACKEND INTEGRATION — HDS-XX
// POST /api/v1/[endpoint]
// Headers: Authorization, X-Tenant-ID, Idempotency-Key, X-Correlation-ID
```

Archivos a modificar:
- `lib/features/auth/data/auth_repository.dart`
- `lib/features/dashboard/data/accounts_repository.dart`
- `lib/features/transactions/data/transactions_repository.dart`
- `lib/features/operations/data/operations_repository.dart`

Token y tenantId disponibles via `flutter_secure_storage` con las keys 
definidas en `AppConstants`.

---

## Tasas y comisiones mock

| Concepto | Valor |
|----------|-------|
| USD → COP | 4,200 |
| COP → USD | 0.000238 |
| Comisión transferencia | 1.5% |