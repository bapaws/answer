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
    'open_ai_hello':
        '您好！我是 OpenAI，一家人工智能研究组织，致力于推动人工智能的发展和应用。在会话中，我会通过下面的账号与您对话：\n- [ChatAI](/service?service_id=open_ai_chat_gpt)\n- [ChatAI GPT-4](/service?service_id=open_ai_chat_gpt_4)\n\n我可以完成很多任务：\n- 文本生成\n- 问答\n- 对话\n- 翻译\n- ...\n\n能够与您进行交互，并准确地理解和回答问题。',
    'chat_gpt_help_url': 'https://www.bapaws.com/answer/help/chat_gpt.html',
    'type_your_tokens': '请输入您的 @name',
    'must_type_tokens': '请先点击我的头像，输入您的 @tokens',
    'network_error': '网络出现了问题，请稍后重试~',
    'save': '保存',
    'saved_successfully': '保存成功',
    'reset': '重置',
    'unable_send': '您不能发送空消息',
    'prompt': '提示',
    'conversation_name': '会话名称',
    'service': '服务',
    'max_tokens': 'Max Tokens',
    'timeout': '超时',
    'new': '新建',
    'delete': '删除',
    'system_role': '系统角色',
    'search': '搜索',
    'cancel': '取消',
    'typing_title': '请输入标题',
    'typing_content': '请输入内容，例如：你是个乐于助人的助手。',
    'block': '屏蔽',
    'blocked': '已屏蔽',
    'vendor': '服务商',
    'official_url': '官网',
    'administrator': '系统管理员',
    'model': '模型',
    'auto_quote': '自动引用',
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
    'open_ai_hello':
        'Hi, I\'m OpenAI, an artificial intelligence research organization dedicated to advancing the development and application of AI.  \nDuring the conversation, I will talk to you through the following account:\n- [ChatAI](/service?service_id=open_ai_chat_gpt)\n- [ChatAI GPT-4](/service?service_id=open_ai_chat_gpt_4)\n\n I can complete many tasks:\n - text generation\n- question\n- answer\n- dialogue\n- translation\n- ...\n\nBe able to interact with you and understand and answer questions as accurately as possible.',
    'chat_gpt_help':
        'You need to make a simple configuration for me before using it.\n1. click on my avatar, go to my home page;\n2. fill in your API Key.\n\nIf you haven\'t applied for an API Key, please click [Get Help](https://www.bapaws.com/answer/help/chat_gpt.html) on my home page to see how to apply.',
    'chat_gpt_help_url': 'https://www.bapaws.com/answer/help/chat_gpt.html',
    'type_your_tokens': 'Type your @name',
    'must_type_tokens': 'Please click on my avatar，type your @tokens',
    'network_error':
        'Oops! The network is unavailable. \n\nPlease try again later.',
    'save': 'Save',
    'saved_successfully': 'Saved successfully',
    'reset': 'Reset',
    'unable_send': 'Unable to send blank message',
    'prompt': 'Prompt',
    'conversation_name': 'Conversation Name',
    'service': 'Service',
    'max_tokens': 'Max Tokens',
    'timeout': 'Timeout',
    'new': 'New',
    'delete': 'Delete',
    'system_role': 'System Role',
    'search': 'Search',
    'cancel': 'Cancel',
    'typing_title': 'Typing title',
    'typing_content': 'Typing content, such as: You are a helpful assistant.',
    'block': 'Block',
    'blocked': 'Blocked',
    'vendor': 'Vendor',
    'official_url': 'Official URL',
    'administrator': 'Administrator',
    'model': 'Model',
    'auto_quote': 'Auto Quote',
  };
}
