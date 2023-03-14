import 'package:flutter/material.dart';
import 'package:answer/app/views/chat_loading_item_view.dart';
import 'package:answer/app/views/chat_text_receive_item_view.dart';

import '../data/models/message.dart';

class ChatView extends StatelessWidget {
  final List<Message> messages;
  final ScrollController controller;
  final ValueChanged<Message> onRetried;
  final ValueChanged<Message> onAvatarClicked;
  const ChatView({
    Key? key,
    required this.messages,
    required this.controller,
    required this.onRetried,
    required this.onAvatarClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          controller: controller,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            switch (messages[index].type) {
              case MessageType.loading:
                return ChatLoadingItemView(
                  message: messages[index],
                  onAvatarClicked: onAvatarClicked,
                );
              default:
                return ChatTextItemView(
                  message: messages[index],
                  onRetried: onRetried,
                  onAvatarClicked: onAvatarClicked,
                );
            }
          },
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        ),
      ),
    );
  }
}
