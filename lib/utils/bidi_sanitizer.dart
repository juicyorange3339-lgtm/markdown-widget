/// Utility helpers to temporarily replace Unicode bidirectional control
/// characters with HTML numeric entities so that the markdown parser does not
/// strip them out. After parsing, we decode the entities back to their
/// original characters before rendering.
const Map<String, String> _bidiPlaceholders = {
  '\u200E': '&#x200E;', // Left-to-Right Mark
  '\u200F': '&#x200F;', // Right-to-Left Mark
  '\u202A': '&#x202A;', // Left-to-Right Embedding
  '\u202B': '&#x202B;', // Right-to-Left Embedding
  '\u202C': '&#x202C;', // Pop Directional Formatting
  '\u202D': '&#x202D;', // Left-to-Right Override
  '\u202E': '&#x202E;', // Right-to-Left Override
  '\u2066': '&#x2066;', // Left-to-Right Isolate
  '\u2067': '&#x2067;', // Right-to-Left Isolate
  '\u2068': '&#x2068;', // First Strong Isolate
  '\u2069': '&#x2069;', // Pop Directional Isolate
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
