import 'package:flutter/material.dart';

import 'chat_base_item_view.dart';

class ChatLoadingItemView extends ChatBaseItemView {
  const ChatLoadingItemView({
    super.key,
    required super.message,
    required super.onAvatarClicked,
  }) : super();

  @override
  Widget buildContent(BuildContext context) => SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 2,
        ),
      );
}
