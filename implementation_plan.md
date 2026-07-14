# AI-Powered Personal Finance Assistant — Implementation Plan

## Overview

Build a **production-grade Flutter mobile app** that transforms personal finance tracking from form-filling into natural conversation. The primary interface is a **chat-based AI assistant** where users type or speak transactions in natural language. The app auto-extracts amounts, categories, merchants, and dates — making any transaction recordable in under 3 seconds.

**Reference UI**: The provided design shows three screens — Home (dashboard), Categories, and Analytics — with a purple gradient header, clean white cards, bottom navigation, and a FAB for quick actions.

**Tech Stack**: Flutter 3.41.6 · Dart 3.11.4 · Hive/Isar (offline DB) · Provider/Riverpod (state) · fl_chart (charts) · speech_to_text (voice) · Google ML Kit (OCR)

---

## Architecture Decisions

> [!IMPORTANT]  
> **Clean Architecture with Feature-First Modules**: Each feature (chat, dashboard, analytics, budget, etc.) is a self-contained module with its own data/domain/presentation layers. This keeps the codebase navigable even at scale.

### Project Structure
```
lib/
├── core/                    # Shared infrastructure
│   ├── theme/               # Design system, colors, typography
│   ├── constants/           # App-wide constants
│   ├── extensions/          # Dart extensions
│   ├── utils/               # Helpers (formatters, validators)
│   ├── services/            # Shared services (storage, auth, AI)
│   ├── models/              # Shared data models
│   └── widgets/             # Reusable UI components
├── features/
│   ├── chat/                # AI chat interface (PRIMARY)
│   │   ├── data/            # Repository, data sources
│   │   ├── domain/          # Entities, use cases
│   │   └── presentation/   # Screens, widgets, providers
│   ├── dashboard/           # Home overview
│   ├── transactions/        # Transaction list & detail
│   ├── analytics/           # Charts & reports
│   ├── budget/              # Budget management
│   ├── categories/          # Category management
│   ├── insights/            # AI insights
│   ├── goals/               # Financial goals
│   ├── search/              # Natural language search
│   ├── settings/            # App settings & security
│   ├── voice/               # Voice input
│   ├── ocr/                 # Receipt scanning
│   └── health_score/        # Financial health
├── app.dart                 # MaterialApp setup
└── main.dart                # Entry point
```

### State Management
Using **Riverpod** for type-safe, testable, compile-time checked state management. No singletons, no global mutables.

### Database Strategy  
**Isar** for offline-first local database — fast, type-safe, supports complex queries. All transactions stored locally first, synced to cloud when available.

### AI/NLP Engine
A **local rule-based NLP parser** for v1 that handles 95%+ of common transaction patterns (regex + keyword matching + fuzzy category classification). No external API dependency for basic parsing — keeps it fast and offline-capable.

---

## Phased Build Plan

> [!NOTE]
> Each phase is self-contained and produces a working app. We build incrementally — never breaking what already works.

---

### Phase 1 — Foundation & Design System 🏗️

**Goal**: Scaffold the project, establish the design system matching the reference UI, and create the core data models.

#### [NEW] Flutter project scaffold
- `flutter create` with proper package name
- Clean architecture folder structure
- Essential dependencies in `pubspec.yaml`

#### [NEW] `lib/core/theme/app_theme.dart`
- Design tokens from reference UI: purple gradient `#7B61FF → #B8A9FF`, clean whites, accent greens/reds
- Typography scale using Inter/Outfit from Google Fonts
- Light theme (dark mode in later phase)
- Consistent spacing, radius, elevation values

#### [NEW] `lib/core/theme/app_colors.dart`
- Curated color palette — income green, expense red, category colors matching reference

#### [NEW] `lib/core/models/transaction_model.dart`
- Core transaction entity: id, amount, type (income/expense), category, merchant, date, paymentMethod, notes, tags, confidence, isRecurring, currency

#### [NEW] `lib/core/models/category_model.dart`
- Category entity with icon, color, name, isCustom, parentCategory

#### [NEW] `lib/core/models/budget_model.dart`
- Budget entity: category, limit, spent, period

#### [NEW] `lib/core/widgets/` — Reusable components
- `gradient_header.dart` — Purple gradient container from reference
- `transaction_tile.dart` — Transaction list item with icon, name, date, amount
- `category_chip.dart` — Category icon + label
- `stat_card.dart` — Metric display card (income, expense)
- `animated_counter.dart` — Smooth number animations

---

### Phase 2 — Chat-Based AI Transaction Engine 💬

**Goal**: Build the **primary interaction** — the chat interface where users type natural language and the AI parses transactions.

#### [NEW] `lib/core/services/ai_parser.dart`
- NLP engine: regex patterns + keyword matching
- Extracts: amount, type, category, merchant, date, payment method
- Handles patterns like: `Coffee 200`, `Salary 65000`, `Paid rent 15000`, `Dad sent 5000`, `Spent 500 on Uber`, `UPI to Swiggy 420`, `Petrol yesterday 1000`
- Returns `ParsedTransaction` with confidence score
- Auto-categorization using keyword → category mapping
- Date extraction: "today", "yesterday", "tomorrow", "last Monday", specific dates
- **Optimized**: Single-pass parsing, no heavy dependencies

#### [NEW] `lib/features/chat/presentation/chat_screen.dart`
- ChatGPT-style interface
- Message bubbles (user + assistant)
- Quick-confirm cards for parsed transactions
- Typing indicator animation
- Auto-scroll, keyboard management
- Input bar with text field + voice button + attachment button

#### [NEW] `lib/features/chat/presentation/widgets/`
- `chat_bubble.dart` — User/assistant message styling
- `transaction_confirm_card.dart` — Parsed transaction preview with ✅ confirm / ✏️ edit
- `chat_input_bar.dart` — Bottom input with mic + attach buttons
- `typing_indicator.dart` — Three-dot bounce animation

#### [NEW] `lib/features/chat/data/chat_repository.dart`
- Stores chat history locally
- Links messages to transactions

#### [NEW] `lib/core/services/transaction_service.dart`
- CRUD operations on Isar database
- Add, edit, delete, query transactions
- Aggregate queries (totals by category, by period)

---

### Phase 3 — Dashboard (Home Screen) 🏠

**Goal**: Build the dashboard matching the reference UI — spending overview, wallet balance, recent transactions.

#### [NEW] `lib/features/dashboard/presentation/dashboard_screen.dart`
- Purple gradient header with date, settings gear, notifications bell
- "This Month Spend" with large amount + comparison to last month
- Spending wallet card
- Recent transactions list
- Pull-to-refresh
- Smooth scroll with gradient fade

#### [NEW] `lib/features/dashboard/presentation/widgets/`
- `spending_header.dart` — Gradient header with month spend
- `wallet_card.dart` — Balance card with arrow
- `recent_transactions_list.dart` — Scrollable list with "See All"
- `quick_action_fab.dart` — Floating action button opening chat

#### [NEW] `lib/features/dashboard/data/dashboard_repository.dart`
- Aggregated data: total spend, income, balance, recent items

---

### Phase 4 — Categories & Analytics 📊

**Goal**: Category management screen and analytics with charts.

#### [NEW] `lib/features/categories/presentation/categories_screen.dart`
- Grid of categories with icons (matching reference: Groceries, Travel, Car, Home, Insurance, Education, etc.)
- Search bar at top
- "Add" button for custom categories
- Each category shows icon + label in a circle

#### [NEW] `lib/features/analytics/presentation/analytics_screen.dart`
- Monthly/Weekly/Daily toggle
- Income vs Expense bar chart (matching reference — green/purple bars)
- Income & Expense summary cards
- Transaction history list below
- Period selector dropdown

#### [NEW] `lib/features/analytics/presentation/widgets/`
- `income_expense_chart.dart` — Bar chart using fl_chart
- `summary_cards.dart` — Income/Expense stat cards
- `period_selector.dart` — Monthly/Weekly dropdown

---

### Phase 5 — Voice Input 🎤

**Goal**: Voice-first transaction recording.

#### [x] `lib/features/voice/presentation/voice_input_widget.dart`
- Animated mic button with pulsing ring
- Real-time speech-to-text display
- Auto-feeds transcribed text into AI parser
- Haptic feedback on start/stop

#### [x] `lib/features/chat/presentation/widgets/chat_input_bar.dart`
- Integrate voice button that triggers voice input overlay

---

### Phase 6 — AI Insights & Smart Search 🧠

**Goal**: Intelligent insights from spending data and natural language search.

#### [NEW] `lib/features/insights/presentation/insights_screen.dart`
- AI-generated cards: "You spent 22% more on restaurants", "Subscriptions increased by ₹850"
- Actionable recommendations
- Animated insight cards with icons

#### [NEW] `lib/features/insights/data/insights_engine.dart`
- Spending pattern analysis
- Month-over-month comparisons
- Category trend detection
- Weekend vs weekday analysis
- Subscription detection
- Savings projections

#### [NEW] `lib/features/search/presentation/search_screen.dart`
- Natural language search bar
- "How much did I spend on coffee?"
- "Show expenses above ₹5000"
- Instant results with highlighted matches

#### [NEW] `lib/features/search/data/search_engine.dart`
- NLP query parser → database queries
- Handles: date ranges, amounts, categories, merchants

---

### Phase 7 — Budget & Financial Health 💰

**Goal**: Budget creation, tracking, alerts, and financial health score.

#### [NEW] `lib/features/budget/presentation/budget_screen.dart`
- Category budgets with progress bars
- Overspending alerts
- AI predictions: "You'll exceed food budget in 4 days"

#### [NEW] `lib/features/health_score/presentation/health_score_screen.dart`
- Financial wellness score (0-100)
- Radar chart: savings rate, spending habits, budget adherence, etc.
- Actionable recommendations

---

### Phase 8 — Goals & OCR 🎯

**Goal**: Financial goal tracking and receipt scanning.

#### [NEW] `lib/features/goals/presentation/goals_screen.dart`
- Goal cards: Emergency Fund, Buy Car, Europe Trip
- Progress rings with animated fill
- Target amount, saved amount, timeline

#### [NEW] `lib/features/ocr/presentation/ocr_screen.dart`
- Camera capture / gallery pick
- ML Kit text extraction
- Auto-fill transaction from receipt

---

### Phase 9 — Settings, Security & Polish 🔐

**Goal**: Settings screen, biometric auth, PIN lock, dark mode, accessibility.

#### [NEW] `lib/features/settings/presentation/settings_screen.dart`
- Profile, currency, language
- Biometric / PIN lock toggle
- Data export
- Notification preferences
- Theme toggle (dark mode)
- About & help

#### [NEW] `lib/core/services/auth_service.dart`
- Biometric authentication (local_auth)
- PIN lock screen
- App lock on background

#### [NEW] Dark mode theme variant

#### Accessibility pass
- Semantic labels on all interactive elements
- Large font support
- Screen reader compatibility

---

### Phase 10 — Reports, Recurring & Advanced Features 📋

**Goal**: Daily/weekly/monthly reports, recurring transaction detection, family mode foundations.

#### [NEW] Reports — Auto-generated summaries
#### [NEW] Recurring transaction detection & management
#### [NEW] Family/shared wallet foundations

---

## Bottom Navigation Structure

| Tab | Screen | Icon |
|-----|--------|------|
| Home | Dashboard | 🏠 |
| Chat | AI Chat (Primary) | 💬 |
| Analytics | Charts & Reports | 📊 |
| Account | Settings & Profile | 👤 |

> [!IMPORTANT]
> The **Chat tab is the heart** of the app. The FAB on all screens also opens the chat for quick transaction input.

---

## Verification Plan

### After Each Phase
- `flutter analyze` — zero warnings
- `flutter test` — all tests pass
- Manual verification on connected device / emulator
- UI matches reference design fidelity

### Automated Tests
```bash
flutter analyze
flutter test
```

### Manual Verification
- Test NLP parser with 50+ transaction patterns
- Verify UI on different screen sizes
- Test offline scenarios
- Verify smooth 60fps animations

---

## Open Questions

> [!IMPORTANT]
> **Currency**: The reference UI shows `$` but your prompt mentions `₹`. Should I default to **₹ (INR)** with multi-currency support?

> [!IMPORTANT]
> **Backend**: For v1, should everything be **offline-only** (local Isar database), or do you want Firebase/Supabase integration from the start for cloud sync?

> [!IMPORTANT]
> **AI API**: For the chat assistant's conversational abilities (answering "Can I afford an iPhone?"), should I use a **local rule-based engine** for now, or integrate with **Gemini API** from the start?
