import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Primarios ──────────────────────────────
  static const primary = Color(0xFF00515F);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF006B7D);
  static const onPrimaryContainer = Color(0xFF9BE9FE);
  static const inversePrimary = Color(0xFF84D2E6);

  // ── Secundarios ────────────────────────────
  static const secondary = Color(0xFF545F73);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD5E0F8);
  static const onSecondaryContainer = Color(0xFF586377);

  // ── Terciarios ─────────────────────────────
  static const tertiary = Color(0xFF3A4A60);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF526278);
  static const onTertiaryContainer = Color(0xFFCDDEF8);

  // ── Superficies ────────────────────────────
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDim = Color(0xFFD8DADC);
  static const surfaceBright = Color(0xFFF7F9FB);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2F4F6);
  static const surfaceContainer = Color(0xFFECEEF0);
  static const surfaceContainerHigh = Color(0xFFE6E8EA);
  static const surfaceContainerHighest = Color(0xFFE0E3E5);

  // ── Texto sobre superficies ────────────────
  static const onSurface = Color(0xFF191C1E);
  static const onSurfaceVariant = Color(0xFF3F484B);
  static const inverseSurface = Color(0xFF2D3133);
  static const onInverseSurface = Color(0xFFEFF1F3);

  // ── Fondos ─────────────────────────────────
  static const background = Color(0xFFF7F9FB);
  static const onBackground = Color(0xFF191C1E);

  // ── Bordes ─────────────────────────────────
  static const outline = Color(0xFF6F797C);
  static const outlineVariant = Color(0xFFBEC8CB);

  // ── Error ──────────────────────────────────
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // ── Semánticos ─────────────────────────────
  static const success = Color(0xFF006B7D);
  static const successText = Color(0xFF00515F);
  static const debitRed = Color(0xFFBA1A1A);
  static const creditGreen = Color(0xFF006B7D);

  // ── Tint de superficie ─────────────────────
  static const surfaceTint = Color(0xFF006879);

  // ── Action buttons background ──────────────
  static const actionBackground = Color(0xFFDCEBF8);
}