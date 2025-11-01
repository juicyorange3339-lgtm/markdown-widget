import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:markdown/markdown.dart' as m;
import 'package:markdown_widget/markdown_widget.dart';
import 'package:path/path.dart' as p;

void main() {
  test('test widget_visitor', () {
    final list = getTestJsonList();
    final generator = MarkdownGenerator();
    for (var i = 0; i < list.length; ++i) {
      _checkWithIndex(i);
      _checkWithIndex(
        i,
        config: MarkdownConfig.darkConfig,
        generator: generator,
      );
    }
  });

  test('input tag', () {
    transformMarkdown('''- [ ] I'm input
    - [x] I' input too''');
  });

  test('table tag', () {
    transformMarkdown('''| align left | centered | align right |
| :-- | :-: | --: |
| a | b | c | ''');
  });

  test('code block builder', () {
    final spans = transformMarkdown(
      '''```html
    asdasdasdasd
    ```''',
      config: MarkdownConfig(
        configs: [PreConfig(builder: (code, language) => Text(code))],
      ),
    );
    final textSpans = spans.map((e) => e.build()).toList();
    assert(textSpans.length == 1);
  });

  test('getNodeByElement', () {
    final visitor = WidgetVisitor();
    visitor.getNodeByElement(
      m.Element("aaa", []),
      MarkdownConfig.defaultConfig,
    );
  });

  test('preserves bidi control characters', () {
    const markdown =
        '\u05E9\u05DC\u05D5\u05DD \u2066Left to Right\u2069 \u05D1\u05D3\u05D9\u05E7\u05EA \u200E123\u200F.';
    final widgets = MarkdownGenerator().buildWidgets(markdown);
    expect(widgets, isNotEmpty);
    final padding = widgets.firstWhere((w) => w is Padding) as Padding;
    final textWidget = padding.child as Text;
    final plainText = textWidget.textSpan?.toPlainText() ?? '';
    expect(plainText.contains('\u2066Left to Right\u2069'), isTrue);
    expect(plainText.contains('\u200E123\u200F'), isTrue);
  });
}

List<Widget> testMarkdownGenerator(
  String markdown, {
  MarkdownConfig? config,
  MarkdownGenerator? generator,
}) {
  return generator?.buildWidgets(
        markdown,
        onTocList: (list) {},
        config: config,
      ) ??
      [];
}

List<SpanNode> transformMarkdown(String markdown, {MarkdownConfig? config}) {
  final m.Document document = m.Document(
    extensionSet: m.ExtensionSet.gitHubFlavored,
    encodeHtml: false,
    inlineSyntaxes: [],
  );
  final lines = markdown.replaceAll('\r\n', '\n').split('\n');
  final nodes = document.parseLines(lines);
  List<HeadingNode> headings = [];
  final visitor = WidgetVisitor(
    onNodeAccepted: (node, index) {
      if (node is HeadingNode) {
        headings.add(node);
      }
    },
    config: config,
  );
  return visitor.visit(nodes);
}

void _checkWithIndex(
  int index, {
  MarkdownConfig? config,
  MarkdownGenerator? generator,
}) {
  final list = getTestJsonList();
  assert(index >= 0 && index < list.length);
  String current = list[index]['markdown'];
  testMarkdownGenerator(current, config: config, generator: generator);
}

List<dynamic> getTestJsonList() {
  if (_mdList != null) return _mdList;
  final current = Directory.current;
  final jsonPath = p.join(current.path, 'test', 'test_markdowns', 'test.json');
  File jsonFile = File(jsonPath);
  final content = jsonFile.readAsStringSync();
  final json = jsonDecode(content);
  _mdList = json;
  return _mdList;
}

dynamic _mdList;
