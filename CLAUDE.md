# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package called `markdown_widget` that provides markdown rendering capabilities with TOC (Table of Contents) support, code highlighting, and cross-platform compatibility. It's a mature package with comprehensive features for rendering markdown content in Flutter applications.

## Development Commands

### Building and Testing
- `flutter test` - Run all tests
- `flutter analyze` - Run static analysis
- `flutter pub get` - Install dependencies
- `flutter pub run build_runner build` - Run code generation (if needed)
- `dart tool/pub` - Package management commands

### Testing
- Tests are located in the `test/` directory
- Use `flutter test test/widget_test.dart` to run specific test files
- Mock files are available in `test/test_markdowns/` for testing markdown rendering

## Architecture

### Core Components

**Main Entry Points:**
- `lib/markdown_widget.dart` - Main export file that re-exports all public APIs
- `lib/widget/markdown.dart` - The main `MarkdownWidget` component for rendering markdown

**Configuration System:**
- `lib/config/configs.dart` - Base configuration classes and interfaces
- `lib/config/all.dart` - Exports all configuration components
- Configuration is based on a tag system where each markdown element has a corresponding config

**Rendering Architecture:**
- `lib/config/markdown_generator.dart` - Core generator that converts markdown to widgets
- `lib/widget/widget_visitor.dart` - Visitor pattern implementation for building widgets
- `lib/widget/span_node.dart` - Span node system for text rendering

**Widget Structure:**
- `lib/widget/blocks/` - Block-level elements (headings, paragraphs, lists, tables, etc.)
  - `container/` - Container blocks that can contain other blocks
  - `leaf/` - Leaf blocks that don't contain other blocks
- `lib/widget/inlines/` - Inline elements (links, images, code, etc.)

### Key Patterns

**Tag-Based Configuration:** Each markdown element type has a tag defined in `MarkdownTag` enum, and corresponding config classes implement `WidgetConfig` interface.

**Visitor Pattern:** The `WidgetVisitor` traverses parsed markdown nodes and creates appropriate widgets based on configuration.

**Modular Design:** Components are split across logical directories (config, widget/blocks, widget/inlines) with clear separation of concerns.

## Dependencies

Core packages used:
- `markdown` - Markdown parsing
- `flutter_highlight` + `highlight` - Code highlighting
- `url_launcher` - Link handling
- `visibility_detector` - Widget visibility tracking
- `scroll_to_index` - ListView scrolling functionality

## Example Usage

The package includes an example app in the `example/` directory that demonstrates:
- Basic markdown rendering
- TOC functionality
- Dark mode support
- Custom configurations
- HTML and LaTeX support extensions

## Testing Strategy

- Unit tests for widget generation and rendering
- Integration tests for complete markdown documents
- Mock files for consistent testing scenarios
- Coverage tracking enabled (shown in README badge)