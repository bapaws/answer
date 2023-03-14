import 'package:flutter/cupertino.dart';

import '../../../data/models/conversation.dart';

class HomeDrawerController {
  final Conversation conversation;

  late final TextEditingController textEditingController =
      TextEditingController(
    text: conversation.displayName,
  );
  late final FocusNode focusNode = FocusNode();

  bool editing = false;

  HomeDrawerController(this.conversation);
}
