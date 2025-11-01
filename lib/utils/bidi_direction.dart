import 'package:flutter/widgets.dart';

/// Very lightweight detection of base text direction based on the first
/// strong character encountered in [text]. This is not a full Unicode
/// BiDi implementation, but works well enough for common cases.
TextDirection detectTextDirectionFromText(String text) {
  for (final rune in text.runes) {
    // Hebrew + Arabic blocks (including Arabic Extended-A)
    if ((rune >= 0x0590 && rune <= 0x08FF) ||
        (rune >= 0xFB1D && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF)) {
      return TextDirection.rtl;
    }
    // Basic Latin and Latin-1 Supplement letters
    if ((rune >= 0x0041 && rune <= 0x005A) || // A-Z
        (rune >= 0x0061 && rune <= 0x007A) || // a-z
        (rune >= 0x00C0 && rune <= 0x02AF)) { // Latin-1 + Extended
      return TextDirection.ltr;
    }
  }
  // default to ambient LTR to avoid surprises
  return TextDirection.ltr;
}

TextDirection detectTextDirectionFromSpan(InlineSpan span) {
  final plain = span.toPlainText();
  return detectTextDirectionFromText(plain);
}

