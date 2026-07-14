import 'package:flutter/material.dart';

/// Curated color palette for the AI Finance Assistant.
/// Inspired by the reference UI: purple gradients, clean whites, accent greens/reds.
abstract final class AppColors {
  // ─── Brand Gradient ────────────────────────────────────────────────
  static const primaryPurple = Color(0xFF7B61FF);
  static const primaryPurpleLight = Color(0xFFB8A9FF);
  static const primaryPurpleDark = Color(0xFF5A3FD9);
  static const gradientStart = Color(0xFF7B61FF);
  static const gradientEnd = Color(0xFFCFC0FF);

  // ─── Surfaces ──────────────────────────────────────────────────────
  static const surface = Color(0xFFFAFAFC);
  static const surfaceWhite = Color(0xFFFFFFFF);
  static const surfaceCard = Color(0xFFF7F5FF);
  static const surfaceDark = Color(0xFF1A1A2E);

  // ─── Text ──────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFF3F4F6);

  // ─── Financial ─────────────────────────────────────────────────────
  static const income = Color(0xFF10B981);
  static const incomeLight = Color(0xFFD1FAE5);
  static const expense = Color(0xFFEF4444);
  static const expenseLight = Color(0xFFFEE2E2);

  // ─── Category Colors ───────────────────────────────────────────────
  static const categoryFood = Color(0xFFFF9F43);
  static const categoryTransport = Color(0xFF54A0FF);
  static const categoryBills = Color(0xFFFF6B6B);
  static const categorySalary = Color(0xFF10B981);
  static const categoryInvestment = Color(0xFF5F27CD);
  static const categoryEntertainment = Color(0xFFFF9FF3);
  static const categoryMedical = Color(0xFFEE5A24);
  static const categoryShopping = Color(0xFF0ABDE3);
  static const categoryTravel = Color(0xFF3DC1D3);
  static const categoryEducation = Color(0xFF6C5CE7);
  static const categoryTaxes = Color(0xFFA29BFE);
  static const categoryInsurance = Color(0xFF00B894);
  static const categoryFamily = Color(0xFFFDAA5E);
  static const categoryPets = Color(0xFFE17055);
  static const categorySubscriptions = Color(0xFFA855F7);
  static const categoryRent = Color(0xFFEC4899);
  static const categoryGym = Color(0xFF14B8A6);
  static const categoryInternet = Color(0xFF6366F1);
  static const categoryWater = Color(0xFF06B6D4);
  static const categoryOther = Color(0xFF9CA3AF);

  // ─── UI Accents ────────────────────────────────────────────────────
  static const border = Color(0xFFE5E7EB);
  static const borderLight = Color(0xFFF3F4F6);
  static const divider = Color(0xFFF3F4F6);
  static const shadow = Color(0x0D000000);
  static const shimmerBase = Color(0xFFE5E7EB);
  static const shimmerHighlight = Color(0xFFF9FAFB);

  // ─── Status ────────────────────────────────────────────────────────
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // ─── Gradients ─────────────────────────────────────────────────────
  static const headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientStart, gradientEnd],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B61FF), Color(0xFF9B8AFF)],
  );
}
