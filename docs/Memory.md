# Development Memory

> **Purpose**: This document serves as the living memory for the AI and engineering team. It maintains context across development sessions, ensuring continuity without needing to reread the entire codebase. **Update this document at the end of every work session.**

---

## 1. Current Status
- **Current Phase**: Phase 5 (Voice Input) completed. Preparing for Phase 6 (Categories & Analytics).
- **Current Branch**: `main` (Last merge completed successfully).
- **Current Sprint Goal**: Deliver complete AI Chat functionality with Voice input and ensure stable local database storage.

## 2. Feature Tracker

### Completed Features
- Project Setup & Clean Architecture scaffolding.
- `app_theme.dart` and `app_colors.dart` implementation.
- `Transaction`, `Category`, `ChatMessage` data models.
- Isar local database setup.
- `AiParser` service (Regex/Heuristic based).
- Chat Interface UI (Bubbles, input bar, auto-scroll).
- **Voice Input**: `speech_to_text` integration, animated mic button, OS permissions configured.

### Pending Features
- **Phase 6**: Analytics Dashboard (Income vs Expense bar charts), Category Grid screen.
- **Phase 7**: Budgets & Proactive Alerts.
- **Phase 8**: OCR Receipt Scanning.
- **Phase 10**: Cloud Sync Backend.

## 3. Known Bugs & Technical Debt
- **Tech Debt**: The `AiParser` currently relies on hardcoded regex patterns. As transaction variety increases, this will become brittle. Need to plan migration to a lightweight on-device ML model or Cloud LLM fallback.
- **Tech Debt**: `chat_screen.dart` is getting large. Consider breaking out `_buildMessageBubble` and `_buildTypingIndicator` into their own files in `features/chat/presentation/widgets/`.
- **Bug**: Voice input might cut off early in noisy environments. Needs continuous listening configuration tune-up.

## 4. Architecture Decisions Log (ADR)
- **ADR-001**: Chose **Isar** over Hive/SQLite for the local database due to superior query capabilities, full-text search, and multi-isolate support.
- **ADR-002**: Chose **Riverpod** for state management to ensure compile-time safety and easy testing.
- **ADR-003**: Voice input runs directly in the Chat interface rather than a separate screen to minimize user friction.

## 5. Next Immediate Task
**Start Phase 6: Analytics & Dashboard**
1. Implement `fl_chart` for visual spending data.
2. Build the Dashboard Screen with the gradient header from the reference design.
3. Wire the Dashboard to read aggregated totals from the Isar `TransactionRepository`.

## 6. Open Questions
- Do we want to implement multi-currency support in the MVP, or hardcode to a single base currency (e.g., INR/USD) for V1?
- Should we allow users to delete messages from the chat history, or just delete the associated transaction?

## 7. Session Summary (Last Updated)
- **Date**: [Current Date]
- **Summary**: Resolved merge conflict in `README.md`. Successfully implemented Phase 5 (Voice Input) including iOS/Android permissions, animated microphone UI, and fixed a compile error (`void` vs `Future<void>`) in `chat_screen.dart`. Merged all changes to `main`.
