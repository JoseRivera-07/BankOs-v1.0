import 'package:flutter/material.dart';

// Todas las constantes de color del design system BankOS.
// Nunca escribas un color hardcodeado en un widget,
// siempre referencia esta clase.

abstract final class AppColors {
  // ── Primarios ──────────────────────────────
  static const primary = Color(0xFF006B7D);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF006B7D);
  static const onPrimaryContainer = Color(0xFF9BE9FE);

  // ── Secundarios ────────────────────────────
  static const secondary = Color(0xFF545F73);

  // ── Fondos y superficies ───────────────────
  static const background = Color(0xFFF7F9FB);
  static const surface = Color(0xFFFFFFFF);

  // ── Texto sobre superficies ────────────────
  static const onSurface = Color(0xFF191C1E);
  static const onSurfaceVariant = Color(0xFF3F484B);

  // ── Bordes ─────────────────────────────────
  static const outline = Color(0xFF6F797C);

  // ── Error ──────────────────────────────────
  static const error = Color(0xFFBA1A1A);
}