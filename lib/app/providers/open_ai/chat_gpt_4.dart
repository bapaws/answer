import 'package:answer/app/providers/open_ai/chat_gpt.dart';

class ChatGpt4 extends ChatGpt {
  ChatGpt4({
    super.model = 'gpt-4-0314',
    super.id = 'open_ai_chat_gpt_4',
    super.name = 'GPT-4',
    super.avatar = 'assets/images/ai_avatar.png',
    super.block = true,
  });
}
