import 'dart:io';

import 'package:answer/app/core/app/app_http.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/models/message.dart';
import 'package:answer/app/providers/open_ai/chat_gpt_model.dart';
import 'package:answer/app/providers/service_provider.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:dio/dio.dart';

import '../../data/models/conversation.dart';

class ChatGpt extends ServiceProvider {
  final List<Map<String, String>> messages = [];

  ChatGpt({
    required String id,
    String model = 'gpt-3.5-turbo-0301',
    String name = 'ChatAI',
    String avatar = 'assets/images/ai_avatar.png',
    String? desc,
    bool block = false,
  }) : super(
          id: id,
          vendorId: 'open_ai_chat_gpt',
          model: model,
          name: name,
          avatar: avatar,
          desc: desc,
          groupId: 0,
          block: block,
        );

  @override
  Future<bool> send({
    required Conversation conversation,
    required Message message,
  }) async {
    bool success = await super.send(
      conversation: conversation,
      message: message,
    );
    if (!success) return false;

    try {
      List<Map<String, String>> messages = await _appendMessages(
        conversation,
        message,
      );

      final response = await AppHttp.post(
        vendor.url!,
        data: {
          'model': model,
          'max_tokens': conversation.maxTokens,
          'messages': messages,
        },
        options: Options(
          sendTimeout: Duration(seconds: conversation.timeout),
          receiveTimeout: Duration(seconds: conversation.timeout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${ServiceProviderManager.instance.getTokens(
                      vendorId: vendorId,
                    ).first.value}',
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        final model = ChatGptModel.fromJson(response.data);
        if (model.choices != null) {
          for (final element in model.choices!) {
            receiveTextMessage(
              requestMessage: message,
              content: element.message?.content ?? '',
            );
          }
        }
      } else {
        throw AppHttp.networkError;
      }

      return true;
    } catch (e) {
      receiveErrorMessage(
        requestMessage: message,
        error: AppHttp.networkError,
      );
      return false;
    }
  }

  Future<List<Map<String, String>>> _appendMessages(
    Conversation conversation,
    Message message,
  ) async {
    final messages = <Map<String, String>>[];

    if (conversation.promptId != null) {
      final prompt = await AppDatabase.instance.promptDao.get(
        id: conversation.promptId!,
      );
      if (prompt?.content != null) {
        messages.add({
          'role': 'system',
          'content': prompt!.content!,
        });
      }
    }

    Message? quoteMessage = message.quoteMessage;
    bool quoted = false;
    while (quoteMessage != null) {
      messages.add({
        'role': 'user',
        'content': quoteMessage.requestMessage!.content!,
      });
      messages.add({
        'role': 'assistant',
        'content': quoteMessage.content!,
      });
      quoteMessage = quoteMessage.quoteMessage;
      quoted = true;
    }

    if (!quoted && conversation.autoQuote > 0) {
      final list = await AppDatabase.instance.messagesDao.get(
        conversationId: message.conversationId!,
        serviceId: id,
        type: MessageType.text,
        limit: conversation.autoQuote,
      );
      for (final item in list) {
        if (item.requestMessage != null) {
          messages.add({
            'role': 'user',
            'content': item.requestMessage!.content!,
          });
          messages.add({
            'role': 'assistant',
            'content': item.content!,
          });
        }
      }
    }
    messages.add({'role': 'user', 'content': message.content!});
    return messages;
  }
}
