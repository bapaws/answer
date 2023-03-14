// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': zh_CN,
        'en_US': en_US,
      };

  static const Map<String, String> zh_CN = {
    'app_name': '小答',
    'slogan': '探索答案像聊天一样简单',
    'app_id': 'com.bapaws.answer',
    'typing_a_message': '输入您的疑问',
    'conversations': '会话',
    'new_chat': '新聊天',
    'new_chat_created': '【@name】创建成功',
    'new_chat_deleted': '【@name】删除成功',
    'copied': '复制成功',
    'chat_gpt_help':
        '在使用之前您需要进行简单的配置:\n1. 请点击我的头像，进入我的主页;\n2. 填写您的 API Key。\n\n如果您还没有申请 API Key，请点击我的主页中的 [帮助](https://www.bapaws.com/answer/help/chat_gpt.html) 查看申请方法。',
    'chat_gpt_help_url': 'https://www.bapaws.com/answer/help/chat_gpt.html',
    'chat_gpt_hello':
        '您好！我是 ChatAI，我可以完成很多任务：\n- 文本生成\n- 问答\n- 对话\n- 翻译\n- ...\n\n能够与您进行交互，并准确地理解和回答问题。',
    'type_your_tokens': '请输入您的 @name',
    'must_type_tokens': '请先点击我的头像，输入您的 @tokens',
    'network_error': '网络出现了问题，请稍后重试~',
  };

  static const Map<String, String> en_US = {
    'app_name': 'Chat Answer',
    'slogan': 'Get answer as easy as chatting',
    'app_id': 'com.bapaws.answer',
    'typing_a_message': 'Ask a question',
    'conversations': 'Conversations',
    'new_chat': 'New Chat',
    'new_chat_created': '"@name" created successfully',
    'new_chat_deleted': '"@name" deleted successfully',
    'copied': 'Copied successfully',
    'chat_gpt_help':
        'You need to make a simple configuration for me before using it.\n1. click on my avatar, go to my home page;\n2. fill in your API Key.\n\nIf you haven\'t applied for an API Key, please click [Get Help](https://www.bapaws.com/answer/help/chat_gpt.html) on my home page to see how to apply.',
    'chat_gpt_help_url': 'https://www.bapaws.com/answer/help/chat_gpt.html',
    'chat_gpt_hello':
        'Hello! I\'m ChatAI, I can complete many tasks:\n - text generation\n- question\n- answer\n- dialogue\n- translation\n- ...\n\nBe able to interact with you and understand and answer questions as accurately as possible.',
    'type_your_tokens': 'Type your @name',
    'must_type_tokens': 'Please click on my avatar，type your @tokens',
    'network_error':
        'Oops! The network is unavailable. \n\nPlease try again later.',
  };
}
