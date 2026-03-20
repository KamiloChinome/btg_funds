import 'package:flutter/services.dart';

/// A [TextInputFormatter] that formats numeric input with period (.)
/// thousand separators, following the Colombian Peso convention.
///
/// Example: user types "75000" and sees "75.000".
///
/// Use [stripFormatting] to remove the dots before parsing the value.
class CopInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Strip non-digit characters from the new input.
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = _addThousandSeparators(digitsOnly);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Formats a digit string with period separators.
  /// Example: "1250000" -> "1.250.000"
  String _addThousandSeparators(String digits) {
    final buffer = StringBuffer();
    final length = digits.length;

    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Removes formatting dots from a formatted value.
  /// Use this before parsing the amount as a number.
  static String stripFormatting(String formatted) {
    return formatted.replaceAll('.', '');
  }
}
