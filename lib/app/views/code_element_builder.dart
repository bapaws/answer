import 'package:answer/app/core/app/app_manager.dart';
import 'package:answer/app/views/code_highlight_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    final theme =
        AppManager.to.isLightMode ? atomOneLightTheme : atomOneDarkTheme;
    return CodeHighlightView(
      code: element.textContent,
      language: language,
      theme: theme,
      padding: const EdgeInsets.all(8),
    );
  }
}
