import 'package:answer/app/providers/open_ai/chat_gpt.dart';

class ChatGpt3 extends ChatGpt {
  ChatGpt3({
    super.model = 'gpt-3.5-turbo-0301',
    super.id = 'open_ai_chat_gpt',
    super.name = 'ChatAI',
    super.avatar = 'assets/images/ai_avatar.png',
  });
}
