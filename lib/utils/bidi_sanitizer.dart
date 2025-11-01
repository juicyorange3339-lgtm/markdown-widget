/// Utility helpers to temporarily replace Unicode bidirectional control
/// characters with ASCII placeholders so that the markdown parser does not
/// strip them out. After parsing, we can restore the original characters
/// before rendering.
const Map<String, String> _bidiPlaceholders = {
  '\u200E': '__MW_BIDI_200E__', // Left-to-Right Mark
  '\u200F': '__MW_BIDI_200F__', // Right-to-Left Mark
  '\u202A': '__MW_BIDI_202A__', // Left-to-Right Embedding
  '\u202B': '__MW_BIDI_202B__', // Right-to-Left Embedding
  '\u202C': '__MW_BIDI_202C__', // Pop Directional Formatting
  '\u202D': '__MW_BIDI_202D__', // Left-to-Right Override
  '\u202E': '__MW_BIDI_202E__', // Right-to-Left Override
  '\u2066': '__MW_BIDI_2066__', // Left-to-Right Isolate
  '\u2067': '__MW_BIDI_2067__', // Right-to-Left Isolate
  '\u2068': '__MW_BIDI_2068__', // First Strong Isolate
  '\u2069': '__MW_BIDI_2069__', // Pop Directional Isolate
};

/// Replaces every supported bidi control character in [input] with a unique
/// ASCII placeholder so the markdown parser can safely process the text.
String protectBidiCharacters(String input) =>
    _swapCharacters(input, forward: true);

/// Restores any bidi control placeholders in [input] back to their original
/// Unicode characters.
String restoreBidiCharacters(String input) =>
    _swapCharacters(input, forward: false);

String _swapCharacters(String input, {required bool forward}) {
  var result = input;
  for (final entry in _bidiPlaceholders.entries) {
    final from = forward ? entry.key : entry.value;
    if (!result.contains(from)) continue;
    final to = forward ? entry.value : entry.key;
    result = result.replaceAll(from, to);
  }
  return result;
}
