import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Surround inline widgets (WidgetSpan) with Unicode embeddings so they behave
/// as isolated LTR runs when mixed inside RTL paragraphs. Additionally, pull
/// adjacent neutral characters like parentheses and spaces into the same
/// embedding so they render with the intended order.
InlineSpan applyBidiIsolation(InlineSpan span) {
  if (span is! TextSpan) return span;

  // First, recursively transform nested children
  final List<InlineSpan> children =
      (span.children ?? const <InlineSpan>[]).map(applyBidiIsolation).toList();

  // Rebuild and wrap WidgetSpan with nearby neutral characters
  final newChildren = <InlineSpan>[];
  int i = 0;
  while (i < children.length) {
    final current = children[i];
    if (current is WidgetSpan) {
      String fromPrev = '';
      String fromNext = '';

      // Steal trailing neutrals from previous TextSpan in newChildren
      if (newChildren.isNotEmpty && newChildren.last is TextSpan) {
        final prev = newChildren.removeLast() as TextSpan;
        final text = prev.text ?? '';
        final m = RegExp(r'[\s\(\[\{]+$').firstMatch(text);
        if (m != null) {
          final keep = text.substring(0, m.start);
          fromPrev = text.substring(m.start);
          if (keep.isNotEmpty) {
            newChildren.add(TextSpan(
              text: keep,
              style: prev.style,
              recognizer: prev.recognizer,
              semanticsLabel: prev.semanticsLabel,
              locale: prev.locale,
              spellOut: prev.spellOut,
              onEnter: prev.onEnter,
              onExit: prev.onExit,
              children: prev.children,
            ));
          }
        } else {
          newChildren.add(prev);
        }
      }

      // Steal leading neutrals from next TextSpan in children (peek)
      if (i + 1 < children.length && children[i + 1] is TextSpan) {
        final next = children[i + 1] as TextSpan;
        final text = next.text ?? '';
        final m = RegExp(r'^[\s\)\]\}\:;,\.]+').firstMatch(text);
        if (m != null && m.end > 0) {
          fromNext = text.substring(0, m.end);
          final remain = text.substring(m.end);
          // replace the next child with its remainder
          children[i + 1] = TextSpan(
            text: remain,
            style: next.style,
            recognizer: next.recognizer,
            semanticsLabel: next.semanticsLabel,
            locale: next.locale,
            spellOut: next.spellOut,
            onEnter: next.onEnter,
            onExit: next.onExit,
            children: next.children,
          );
        }
      }

      newChildren.add(const TextSpan(text: '\u202A')); // LRE
      if (fromPrev.isNotEmpty) newChildren.add(TextSpan(text: fromPrev));
      newChildren.add(current);
      if (fromNext.isNotEmpty) newChildren.add(TextSpan(text: fromNext));
      newChildren.add(const TextSpan(text: '\u202C')); // PDF

      i += 1;
      continue;
    }

    newChildren.add(current);
    i += 1;
  }

  return TextSpan(
    text: span.text,
    children: newChildren,
    style: span.style,
    recognizer: span.recognizer,
    semanticsLabel: span.semanticsLabel,
    locale: span.locale,
    spellOut: span.spellOut,
    onEnter: span.onEnter,
    onExit: span.onExit,
  );
}

