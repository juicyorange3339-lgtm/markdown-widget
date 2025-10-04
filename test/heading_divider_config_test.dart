import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';

void main() {
  group('Heading divider configuration tests', () {
    testWidgets('H1 should have default divider', (WidgetTester tester) async {
      const config = H1Config();

      expect(config.divider, isNotNull, reason: 'H1 should have a default divider');
      expect(config.divider?.color, const Color(0xFFd7dde3), reason: 'Default divider color');
      expect(config.divider?.height, 1.0, reason: 'Default divider height');
      expect(config.divider?.space, 4.8, reason: 'Default divider space');
    });

    testWidgets('H1 custom divider configuration', (WidgetTester tester) async {
      final customDivider = HeadingDivider(
        color: Colors.red,
        height: 3.0,
        space: 10.0,
      );

      final config = H1Config(divider: customDivider);

      expect(config.divider?.color, Colors.red, reason: 'Custom divider color should be red');
      expect(config.divider?.height, 3.0, reason: 'Custom divider height should be 3.0');
      expect(config.divider?.space, 10.0, reason: 'Custom divider space should be 10.0');
    });

    testWidgets('H2 custom divider configuration', (WidgetTester tester) async {
      final customDivider = HeadingDivider(
        color: Colors.blue,
        height: 2.0,
        space: 8.0,
      );

      final config = H2Config(divider: customDivider);

      expect(config.divider?.color, Colors.blue, reason: 'Custom divider color should be blue');
      expect(config.divider?.height, 2.0, reason: 'Custom divider height should be 2.0');
      expect(config.divider?.space, 8.0, reason: 'Custom divider space should be 8.0');
    });

    testWidgets('H3 custom divider configuration', (WidgetTester tester) async {
      final customDivider = HeadingDivider(
        color: Colors.green,
        height: 1.5,
        space: 6.0,
      );

      final config = H3Config(divider: customDivider);

      expect(config.divider?.color, Colors.green, reason: 'Custom divider color should be green');
      expect(config.divider?.height, 1.5, reason: 'Custom divider height should be 1.5');
      expect(config.divider?.space, 6.0, reason: 'Custom divider space should be 6.0');
    });

    testWidgets('H4 can have custom divider (default is null)', (WidgetTester tester) async {
      const configWithoutDivider = H4Config();
      expect(configWithoutDivider.divider, isNull, reason: 'H4 should not have a divider by default');

      final customDivider = HeadingDivider(
        color: Colors.purple,
        height: 1.0,
        space: 5.0,
      );

      final configWithDivider = H4Config(divider: customDivider);

      expect(configWithDivider.divider?.color, Colors.purple, reason: 'H4 can have custom divider');
      expect(configWithDivider.divider?.height, 1.0);
      expect(configWithDivider.divider?.space, 5.0);
    });

    testWidgets('H1 with no divider (explicit null)', (WidgetTester tester) async {
      // Create a special divider that acts as "no divider"
      const config = H1Config(divider: null);

      // Since H1Config uses ?? HeadingDivider.h1, it will fall back to default
      expect(config.divider, isNotNull, reason: 'H1 falls back to default when null is passed');
    });

    testWidgets('HeadingDivider copy method works correctly', (WidgetTester tester) async {
      final original = HeadingDivider(
        color: Colors.red,
        height: 2.0,
        space: 5.0,
      );

      final copied = original.copy(color: Colors.blue);

      expect(copied.color, Colors.blue, reason: 'Copied divider should have new color');
      expect(copied.height, 2.0, reason: 'Copied divider should keep original height');
      expect(copied.space, 5.0, reason: 'Copied divider should keep original space');
    });

    test('MarkdownConfig with custom heading dividers', () {
      final customH1Divider = HeadingDivider(
        color: Colors.orange,
        height: 3.0,
        space: 12.0,
      );

      final customH2Divider = HeadingDivider(
        color: Colors.blue,
        height: 2.0,
        space: 8.0,
      );

      final config = MarkdownConfig(configs: [
        H1Config(divider: customH1Divider),
        H2Config(divider: customH2Divider),
      ]);

      // Verify the configs are properly stored
      expect(config.h1.divider?.color, Colors.orange);
      expect(config.h1.divider?.height, 3.0);
      expect(config.h2.divider?.color, Colors.blue);
      expect(config.h2.divider?.height, 2.0);
    });
  });
}