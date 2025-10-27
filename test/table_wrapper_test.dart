import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';

void main() {
  group('Table configuration tests', () {
    testWidgets('TableConfig defaultHorizontalScrollWrapper should create horizontal scroll view', (WidgetTester tester) async {
      // Create a test table widget
      final tableWidget = Table(
        children: [
          TableRow(
            children: [
              TableCell(child: Text('Header 1')),
              TableCell(child: Text('Header 2')),
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Text('Data 1')),
              TableCell(child: Text('Data 2')),
            ],
          ),
        ],
      );

      // Test the default wrapper directly
      final wrappedWidget = TableConfig.defaultHorizontalScrollWrapper(tableWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: wrappedWidget,
          ),
        ),
      );

      // Find the SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget, reason: 'SingleChildScrollView should be found');

      // Find the table inside
      expect(find.byType(Table), findsOneWidget, reason: 'Table should be found inside the wrapper');

      // Check scroll direction
      final scrollView = tester.widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
      expect(scrollView.scrollDirection, Axis.horizontal, reason: 'ScrollDirection should be horizontal');
    });

    test('Default TableConfig should use FlexColumnWidth by default', () {
      const config = TableConfig();

      // Default column width should be null, which falls back to FlexColumnWidth in TableNode
      expect(config.defaultColumnWidth, isNull, reason: 'Default should be null, which falls back to FlexColumnWidth in TableNode');
    });

    test('TableConfig can use IntrinsicColumnWidth for no wrapping', () {
      const config = TableConfig(
        defaultColumnWidth: IntrinsicColumnWidth(),
      );

      expect(config.defaultColumnWidth, isA<IntrinsicColumnWidth>(), reason: 'Should allow IntrinsicColumnWidth');
    });

    testWidgets('Custom wrapper should override default behavior', (WidgetTester tester) async {
      // Create a test table widget
      final tableWidget = Table(
        children: [
          TableRow(
            children: [
              TableCell(child: Text('Header 1')),
              TableCell(child: Text('Header 2')),
            ],
          ),
        ],
      );

      // Create a custom wrapper
      Widget customWrapper(Widget table) {
        return Container(
          color: Colors.blue,
          child: Text('Custom Wrapper'),
        );
      }

      // Test with custom wrapper
      final wrappedWidget = customWrapper(tableWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: wrappedWidget,
          ),
        ),
      );

      // Find the custom container
      expect(find.byType(Container), findsOneWidget, reason: 'Custom Container should be found');

      // Find the text widget
      expect(find.text('Custom Wrapper'), findsOneWidget, reason: 'Custom text should be found');
    });

    test('TableConfig with horizontal scroll wrapper for many columns', () {
      final config = TableConfig(
        wrapper: TableConfig.defaultHorizontalScrollWrapper,
      );

      expect(config.wrapper, isNotNull, reason: 'Wrapper should be set');
    });
  });
}