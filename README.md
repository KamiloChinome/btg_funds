# BTG Pactual Fund Management App

Flutter mobile application for managing FPV/FIC investment funds. Allows users to subscribe to funds, cancel subscriptions, and view transaction history.

## Features

- **Portfolio Overview** — View available balance and active subscriptions
- **Fund Browsing** — Browse 5 available FPV/FIC funds with category badges
- **Subscribe to Funds** — Subscribe with amount validation and notification method selection (Email/SMS)
- **Cancel Subscriptions** — Cancel with confirmation dialog and automatic balance refund
- **Transaction History** — Complete record of all subscriptions and cancellations
- **Error Handling** — Clear error messages for insufficient balance, minimum amount violations, and duplicate subscriptions

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
└── transactions/           # Transaction history module
    ├── application/        # TransactionsNotifier
    ├── domain/             # FundTransaction model, TransactionType enum
    ├── infrastructure/     # FundTransactionDTO
    ├── presentation/       # TransactionsScreen, TransactionTile
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

## Assumptions

- Single user with initial balance of COP $500,000
- No backend authentication or deployment required
- Mock data simulates REST API with artificial latency
