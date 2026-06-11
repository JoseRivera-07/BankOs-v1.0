import 'package:uuid/uuid.dart';

abstract final class IdempotencyHelper {
  static const _uuid = Uuid();

  // Genera un UUID v4 único por cada operación financiera
  static String generate() => _uuid.v4();
}