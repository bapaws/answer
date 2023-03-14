import 'dart:io';

import 'package:answer/app/core/app/app_http.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/models/message.dart';
import 'package:answer/app/providers/open_ai/chat_gpt_model.dart';
import 'package:answer/app/providers/service_provider.dart';
import 'package:answer/flavors/build_config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/models/service_token.dart';

class ChatGpt extends ServiceProvider {
  final List<Map<String, String>> messages = [];

  ChatGpt({
    super.onReceived,
  }) : super(
          id: 'open_ai_chat_gpt',
          name: 'ChatAI',
          avatar: 'assets/images/ai_avatar.png',
          desc: null,
          groupId: 0,
          officialUrl: 'https://www.bapaws.com/chat/completions',
          apiUrl: 'https://api.openai.com/v1/chat/completions',
          help: 'chat_gpt_help'.tr,
          helpUrl: 'https://www.bapaws.com/answer/help/chat_gpt.html',
          hello: 'chat_gpt_hello'.tr,
          tokens: [
            ServiceToken(
              id: 'chat_gpt_api_key',
              name: 'API Key',
              value: BuildConfig.instance.config.openAIApiKey ?? '',
              serviceProviderId: 'open_ai_chat_gpt',
            ),
          ],
        );

  @override
  Future<bool> send({required Message message}) async {
    bool success = await super.send(message: message);
    if (!success) return false;

    try {
      final messages = <Map<String, String>>[];
      if (message.conversationId != null) {
        final list = await AppDatabase.instance.messagesDao.get(
          conversationId: message.conversationId!,
          serviceId: id,
          type: MessageType.text,
          limit: 8,
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

      final response = await AppHttp.post(
        apiUrl!,
        data: {
          'model': 'gpt-3.5-turbo-0301',
          'messages': messages,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokens.first.value}'
        }),
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
}
