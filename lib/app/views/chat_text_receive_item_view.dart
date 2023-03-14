import 'package:answer/app/views/chat_base_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'code_element_builder.dart';

class ChatTextItemView extends ChatBaseItemView {
  const ChatTextItemView({
    super.key,
    required super.message,
    required super.onRetried,
    required super.onAvatarClicked,
  }) : super();

  // @override
  // Widget buildContent(BuildContext context) => SelectableText(
  //       message.content ?? '',
  //       style: Theme.of(context).textTheme.titleMedium,
  //     );

  @override
  Widget buildContent(BuildContext context) => MarkdownBody(
        data: message.content ?? '',
        selectable: true,
        extensionSet: md.ExtensionSet.gitHubWeb,
        builders: {
          'code': CodeElementBuilder(),
        },
        // md.ExtensionSet(
        //       md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        //       [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
        //     ),
      );
}
