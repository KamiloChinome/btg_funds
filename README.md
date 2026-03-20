# BTG Pactual Fund Management App

Flutter mobile application for managing FPV/FIC investment funds. Allows users to subscribe to funds, cancel subscriptions, and view transaction history.

## 🎬 Video Demo

<div align="center">

[![Ver Video Demo](https://img.shields.io/badge/%E2%96%B6%EF%B8%8F_Ver_Demo_en_Video-FF0000?style=for-the-badge&logo=google-drive&logoColor=white&labelColor=333333)](https://drive.google.com/file/d/18PfIIP_pyM2zPSKR66P4-1Ke2R6SHiKo/view?usp=sharing)

> **📱 Mira la app en acción** — Navegación, suscripción a fondos, cancelación, historial de transacciones, modo oscuro e idiomas.

</div>

---

## Features

- **Portfolio Overview** — Animated balance card, investment summary, and active subscriptions
- **Fund Browsing** — Browse 5 FPV/FIC funds with category filter chips (All / FPV / FIC) and pull-to-refresh
- **Subscribe to Funds** — Bottom sheet form with COP currency formatting, amount validation, and notification method selection (Email/SMS)
- **Cancel Subscriptions** — Confirmation bottom sheet with automatic balance refund
- **Transaction History** — Timeline of all subscriptions and cancellations with type indicators
- **Dark Mode** — Toggle between light and dark themes, persisted via SharedPreferences
- **Localization (i18n)** — Full English and Spanish support with runtime language switching (easy_localization)
- **Shimmer Loading** — Skeleton placeholders while funds load from the mock API
- **Error Handling** — Sealed `Failure` union type with localized messages for insufficient balance, minimum amount violations, and duplicate subscriptions

## Architecture

Clean Architecture + Domain-Driven Design (DDD) with feature-based modules:

```
lib/
├── app/                    # App-level: router, theme, scaffold
├── core/                   # Shared domain (Failure, typedefs, extensions)
├── funds/                  # Fund catalog module
│   ├── application/        # FundsNotifier (state management)
│   ├── domain/             # Fund model, FundCategory enum
│   ├── infrastructure/     # FundDTO, FundRepository (mock API)
│   ├── presentation/       # Screens, FundCard, SubscribeBottomSheet
│   └── shared/             # Module providers
├── portfolio/              # User portfolio module
│   ├── application/        # PortfolioNotifier (subscribe/cancel logic)
│   ├── domain/             # Subscription model, PortfolioState
│   ├── presentation/       # PortfolioScreen, SubscriptionCard
│   └── shared/             # Module providers
├── transactions/           # Transaction history module
│   ├── application/        # TransactionsNotifier
│   ├── domain/             # FundTransaction model, TransactionType enum
│   ├── infrastructure/     # FundTransactionDTO
│   ├── presentation/       # TransactionsScreen, TransactionTile
│   └── shared/             # Module providers
└── preferences/            # User preferences module
    ├── application/        # AppPreferencesNotifier, state
    ├── domain/             # AppPreferences model
    ├── infrastructure/     # SharedPreferences repository
    ├── presentation/       # SettingsScreen (theme toggle, language picker)
    └── shared/             # Module providers
```

### Key Patterns

| Pattern | Implementation |
|---|---|
| State Management | Riverpod 2.x with `riverpod_generator` |
| Immutable Models | Freezed sealed classes |
| Error Handling | `Either<Failure, T>` (dartz) with sealed Failure union |
| Data Transfer | DTO layer with `json_serializable` (JSON to Domain) |
| Navigation | GoRouter with ShellRoute for bottom navigation |
| Forms | `flutter_form_builder` with `FormBuilderValidators` |
| Localization | `easy_localization` with JSON translation files (EN/ES) |
| Persistence | `shared_preferences` for theme and language settings |
| Mock API | Repository pattern with simulated network delay |

## Prerequisites

- Flutter SDK 3.10+
- Android SDK (API 21+)

## Setup and Run

```bash
# Install dependencies
flutter pub get

# Generate code (freezed, riverpod, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Run on connected Android device
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Available Funds

| ID | Name | Minimum Amount | Category |
|---|---|---|---|
| 1 | FPV_BTG_PACTUAL_RECAUDADORA | COP $75.000 | FPV |
| 2 | FPV_BTG_PACTUAL_ECOPETROL | COP $125.000 | FPV |
| 3 | DEUDAPRIVADA | COP $50.000 | FIC |
| 4 | FDO-ACCIONES | COP $250.000 | FIC |
| 5 | FPV_BTG_PACTUAL_DINAMICA | COP $100.000 | FPV |

## Testing

```bash
flutter test
```

| Suite | Covers |
|---|---|
| `portfolio_notifier_test` | Subscribe/cancel logic, balance updates, business rule validation, transaction recording |
| `fund_repository_test` | Mock API fetch, DTO-to-domain mapping, error handling |
| `fund_dto_test` | JSON deserialization, domain conversion, category mapping |

## Assumptions

- Single user with initial balance of COP $500,000
- No backend authentication or deployment required
- Mock data simulates REST API with artificial latency
