import 'package:answer/app/providers/open_ai/chat_gpt.dart';

class ChatGpt4 extends ChatGpt {
  ChatGpt4({
    super.model = 'gpt-4-0314',
  }) : super(
          id: 'open_ai_chat_gpt_4',
          name: 'GPT-4',
          avatar: 'assets/images/ai_avatar.png',
          desc: null,
          block: true,
        );
}
