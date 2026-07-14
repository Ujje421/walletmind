# Development Phases

This document outlines the entire lifecycle of WalletMind, breaking it down into structured, actionable phases.

## Phase 0: Project Setup & Foundation
**Goal**: Initialize the repository and set up the foundation for scalable development.
- **Deliverables**: Flutter project, folder structure, CI/CD pipelines, linting rules, base theme.
- **Tasks**:
  - `flutter create`
  - Setup Clean Architecture folders.
  - Implement `app_theme.dart` and `app_colors.dart`.
  - Configure `pubspec.yaml` with core dependencies (Riverpod, Isar).
- **Dependencies**: None.
- **Git Branch**: `feature/phase0-setup`
- **Definition of Done**: App builds successfully, `flutter analyze` is clean, theme displays correctly on a dummy screen.

## Phase 1: Core Models & Local Database
**Goal**: Implement the data layer for offline-first functionality.
- **Deliverables**: Isar database setup, Transaction & Category entities.
- **Tasks**:
  - Define `Transaction` and `Category` models (Isar collections).
  - Create `TransactionRepository` and `CategoryRepository`.
  - Write CRUD unit tests.
- **Git Branch**: `feature/phase1-database`

## Phase 2: AI Transaction Parser Engine (Local)
**Goal**: Build the core magic of the app — parsing natural language into structured data.
- **Deliverables**: `AiParser` service, regex/keyword heuristic engine.
- **Tasks**:
  - Build NLP rules to extract Amount, Date, Category, and Merchant.
  - Write 50+ unit test cases representing user inputs ("Coffee 5", "Uber yesterday 20").
- **Acceptance Criteria**: Minimum 90% parsing accuracy on test suite.

## Phase 3: The Chat Interface (Primary UI)
**Goal**: Create the conversational UI where users will spend most of their time.
- **Deliverables**: Chat screen, message bubbles, transaction confirmation cards.
- **Tasks**:
  - Build chat UI with auto-scroll.
  - Connect text input to `AiParser`.
  - Connect parser output to `TransactionRepository` (save to DB).
  - Implement typing indicator.

## Phase 4: Dashboard & Navigation
**Goal**: Build the home overview screen and bottom navigation.
- **Deliverables**: Bottom nav bar, Dashboard screen with spending summary.
- **Tasks**:
  - Shell route for bottom navigation.
  - Dashboard header showing "This Month Spend".
  - Recent transactions list fetching from DB.

## Phase 5: Voice Input Integration
**Goal**: Allow hands-free transaction logging.
- **Deliverables**: Animated mic button, speech-to-text pipeline.
- **Tasks**:
  - Integrate `speech_to_text` package.
  - Handle OS microphone permissions.
  - Feed recognized text directly into the chat flow.

## Phase 6: Categories & Analytics
**Goal**: Visual representation of spending data.
- **Deliverables**: Category management, Bar charts.
- **Tasks**:
  - Implement `fl_chart` for Income vs Expense.
  - Create Category management screen (add/edit custom categories).

## Phase 7: Budgets & Alerts
**Goal**: Proactive financial management.
- **Deliverables**: Budget setting screen, progress bars.
- **Tasks**:
  - Create `Budget` model.
  - UI for setting limits per category.
  - Logic to calculate remaining budget based on transactions.

## Phase 8: OCR Receipt Scanning
**Goal**: Extract data from photos.
- **Deliverables**: Camera integration, ML Kit text extraction.
- **Tasks**:
  - Implement camera overlay.
  - Process image with Google ML Kit.
  - Pass extracted text through the `AiParser`.

## Phase 9: Settings, Security & Polish
**Goal**: Make the app production-ready.
- **Deliverables**: App lock, dark mode, export data.
- **Tasks**:
  - Integrate `local_auth` for biometrics.
  - Implement dark mode theme variants.
  - CSV export functionality.

## Phase 10: Cloud Sync (Backend Integration)
**Goal**: Multi-device support and backup.
- **Deliverables**: FastAPI backend, JWT Auth, Sync Engine.
- **Tasks**:
  - Setup backend infra (Postgres/Supabase).
  - Implement REST API endpoints.
  - Build sync queue in Flutter.

## Phase 11: Production Release & MVP
**Goal**: Launch to stores.
- **Deliverables**: iOS App Store and Google Play Store listings.
- **Tasks**:
  - Generate signing keys.
  - Capture store screenshots.
  - Final QA and Beta testing.

## Phase 12: Future AI Features
**Goal**: Post-launch intelligent features.
- **Deliverables**: Predictive forecasting, Subscription detection, Natural language database search.
