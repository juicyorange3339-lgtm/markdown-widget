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

/// Some text engines may not fully support isolate controls (U+2066..U+2069).
/// To preserve intended directionality, map isolates to the older embedding
/// controls that enjoy broader support: LRI->LRE, RLI->RLE, FSI->LRE, PDI->PDF.
String normalizeBidiForRendering(String input) {
  return input
      .replaceAll('\u2066', '\u202A') // LRI -> LRE
      .replaceAll('\u2067', '\u202B') // RLI -> RLE
      .replaceAll('\u2068', '\u202A') // FSI -> LRE (best-effort)
      .replaceAll('\u2069', '\u202C'); // PDI -> PDF
}
