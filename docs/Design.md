# Design System & Guidelines

## 1. Brand Philosophy
WalletMind is not a spreadsheet; it is a smart, calming, and premium financial assistant. The design must evoke **trust, clarity, and peace of mind**. It should feel like a blend of **Google Material You, Apple Wallet, Notion, and Linear** — minimal, elegant, and highly functional.

## 2. Visual Identity & Design Principles
- **Clarity over Density**: Do not cram information. Use whitespace generously to let numbers breathe.
- **Dynamic & Alive**: The app should feel responsive. Use micro-interactions, haptics, and smooth transitions.
- **Aesthetic**: Modern, slightly rounded, premium. Subtle gradients, glassmorphism where appropriate (e.g., sticky headers).

## 3. Color Palette
The color system uses deep purples for brand identity, with clear semantic colors for finance.

### Light Theme
- **Primary Brand**: Deep Purple (`#6C5CE7`)
- **Secondary Brand**: Soft Lavender (`#A29BFE`)
- **Background**: Off-White / Pearl (`#F8F9FA`)
- **Surface (Cards)**: Pure White (`#FFFFFF`)
- **Text Primary**: Midnight Blue/Black (`#2D3436`)
- **Text Secondary**: Slate Gray (`#636E72`)
- **Income (Positive)**: Emerald Green (`#00B894`)
- **Expense (Negative)**: Coral Red (`#FF7675`)

### Dark Theme
- **Background**: Deep Pitch (`#0F0F13`)
- **Surface**: Dark Gray/Blue (`#1C1C24`)
- **Primary Brand**: Bright Neon Purple (`#8C7CFF`)
- **Text Primary**: Pure White (`#FFFFFF`)
- **Text Secondary**: Light Slate (`#B2BEC3`)

## 4. Typography
- **Primary Font**: `Inter` or `Outfit` (Google Fonts).
- **Headings**: Heavy weight (700-800), tight letter spacing.
- **Numbers/Amounts**: Monospaced tabular figures (`FontFeature.tabularFigures()`) so amounts align perfectly in lists.
- **Body**: Regular weight (400), highly legible line height (1.5).

## 5. Spacing & Corner Radius
- **Spacing System**: 4px baseline grid (4, 8, 12, 16, 24, 32, 48, 64).
- **Corner Radius**:
  - Small (Tags, Chips): 8px
  - Medium (Buttons, Inner Cards): 16px
  - Large (Main Cards, Bottom Sheets): 24px - 32px (Apple style)

## 6. Elevation & Shadows
- Avoid harsh drop shadows. Use very soft, highly blurred shadows with low opacity.
- **Light Theme Shadow**: `0px 8px 24px rgba(0,0,0, 0.04)`
- **Dark Theme Elevation**: Rely on surface color lightening rather than shadows, matching Material 3 Dark theme specs.

## 7. UI Components

### Buttons
- **Primary**: Solid brand color, 16px radius, bold text. Provides a soft haptic click.
- **Secondary**: Light background (10% opacity of brand color) with brand color text.
- **Disabled**: Grayed out, unclickable.

### Inputs & Chat Bar
- Chat input should look like a modern messaging app (e.g., iMessage or Telegram). Pill-shaped, subtle border, smooth expansion when typing multi-line.

### Cards
- Clean, borderless (or 1px ultra-light border), relying on shadow for depth.

### Bottom Sheets
- Used extensively instead of full-page routes for quick actions (e.g., editing a parsed transaction).
- Must have a drag handle pill at the top.

## 8. Micro-interactions & Motion
- **Duration**: 200ms - 300ms for UI state changes.
- **Curves**: Use `Curves.easeOutCubic` or spring physics for a natural, non-linear feel.
- **Typing Indicator**: 3 bouncing dots in a chat bubble when AI is processing.
- **Confirmations**: Subtle scale up/down pulse with a success green highlight when a transaction is saved.

## 9. Empty, Error, and Success States
- **Empty States**: High-quality, minimal line-art illustrations. Friendly copy ("No expenses yet! Try saying 'Coffee 5'").
- **Error States**: Inline error messages (never intrusive dialogs). Red text with a subtle background tint.
- **Success States**: Checkmark animations, celebratory haptics.

## 10. Haptics
- **Light Impact**: On button taps, category selections.
- **Medium Impact**: When the AI successfully parses and saves a transaction.
- **Heavy/Error Impact**: If the user tries to save an invalid transaction.

## 11. Accessibility (A11y)
- Ensure a minimum contrast ratio of 4.5:1 for all text.
- Color should never be the *only* indicator of state (e.g., Income/Expense must also have `+` / `-` symbols and distinct icons).
