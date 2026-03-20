import 'package:intl/intl.dart';

/// Extension on [double] to format values as Colombian Pesos (COP).
extension CurrencyFormat on double {
  /// Formats the value as COP currency.
  /// Example: 500000.0 → "COP \$500.000"
  String toCOP() {
    final formatter = NumberFormat('#,###', 'es_CO');
    return 'COP \$${formatter.format(toInt())}';
  }
}
