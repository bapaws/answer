import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

class CodeHighlightView extends StatelessWidget {
  /// The original code to be highlighted
  final String source;

  /// Highlight language
  ///
  /// It is recommended to give it a value for performance
  ///
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  final String? language;

  /// Highlight theme
  ///
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  final Map<String, TextStyle> theme;

  /// Padding
  final EdgeInsetsGeometry? padding;

  CodeHighlightView({
    super.key,
    required String code,
    this.language,
    this.theme = const {},
    this.padding,
    int tabSize = 8, // TODO: https://github.com/flutter/flutter/issues/50087
  }) : source = code.replaceAll('\t', ' ' * tabSize);

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className!]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans
            .add(TextSpan(children: tmp, style: theme[node.className!]));
        stack.add(currentSpans);
        currentSpans = tmp;

        for (var n in node.children!) {
          _traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }

  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);
  static const _defaultBackgroundColor = Color(0xffffffff);

  // TODO: dart:io is not available at web platform currently
  // See: https://github.com/flutter/flutter/issues/39998
  // So we just use monospace here for now
  static const _defaultFontFamily = 'monospace';

  @override
  Widget build(BuildContext context) {
    final result = highlight.parse(source, language: language);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme[_rootKey]?.backgroundColor ?? _defaultBackgroundColor,
      ),
      width: MediaQuery.of(context).size.width,
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: _defaultFontFamily,
              color: theme[_rootKey]?.color ?? _defaultFontColor,
            ),
            children: _convert(result.nodes!),
          ),
        ),
      ),
    );
  }
}
