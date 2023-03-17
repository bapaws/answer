// {
// 	"id": "",
// 	"name": "New Chat",
// 	"avatar": "",
// 	"group_id": 0,
// 	"official_url": "",
// 	"api_url": "",
//   "on_received": "",
//   "help": "Help",
//   "help_url": "Help",
//   "block": false,
//   "tokens": [
//    {
//      "id": "api-key",
//      "name": "API Key",
//      "value": "",
//      "service_provider_id": 0
//    }
//  ]
// }

import 'dart:convert';

import 'package:answer/app/core/app/app_hive_keys.dart';
import 'package:answer/app/core/app/app_manager.dart';
import 'package:answer/app/data/db/app_uuid.dart';
import 'package:answer/app/data/models/conversation.dart';
import 'package:answer/app/providers/service_request_parameter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/models/group.dart';
import '../data/models/message.dart';
import '../data/models/service_token.dart';
import '../data/models/value_serializer.dart';

typedef ServiceProviderCallback = Future<void> Function(Message message);

class ServiceProvider {
  static const loadingIdPrefix = 'loading__';
  static const errorIdPrefix = 'error__';

  String id;
  String name;
  String avatar;
  String? desc;
  int groupId;
  String? officialUrl;
  String? apiUrl;
  String? editApiUrl;
  String? help;
  String? helpUrl;
  String? hello;
  bool block;

  final List<ServiceParameter> parameters;
  final List<ServiceToken> tokens;

  final ServiceProviderCallback? onReceived;

  Message? currentRequestMessage;

  String? get url => editApiUrl ?? apiUrl;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.avatar,
    required this.desc,
    required this.groupId,
    required this.officialUrl,
    required this.apiUrl,
    required this.help,
    required this.helpUrl,
    required this.tokens,
    required this.hello,
    required this.parameters,
    this.onReceived,
    this.block = false,
    this.editApiUrl,
  });

  factory ServiceProvider.fromRawJson(String str) =>
      ServiceProvider.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  ServiceProvider copyWith({
    String? id,
    String? name,
    String? avatar,
    String? desc,
    int? groupId,
    String? officialUrl,
    String? apiUrl,
    ServiceProviderCallback? onReceived,
    String? help,
    String? helpUrl,
    String? hello,
    bool? block,
    String? editApiUrl,
    List<ServiceToken>? tokens,
    List<ServiceParameter>? parameters,
    Map<String, dynamic>? map,
  }) =>
      ServiceProvider(
        id: id ?? map?['id'] ?? this.id,
        name: name ?? map?['name'] ?? this.name,
        avatar: avatar ?? map?['avatar'] ?? this.avatar,
        desc: desc ?? map?['desc'] ?? this.desc,
        groupId: groupId ?? map?['group_id'] ?? this.groupId,
        officialUrl: officialUrl ?? map?['official_url'] ?? this.officialUrl,
        apiUrl: apiUrl ?? map?['api_url'] ?? this.apiUrl,
        onReceived: onReceived ?? this.onReceived,
        help: help ?? map?['help'] ?? this.help,
        helpUrl: helpUrl ?? map?['help_url'] ?? this.helpUrl,
        editApiUrl: editApiUrl ?? map?['edit_api_url'] ?? this.editApiUrl,
        hello: hello ?? map?['hello'] ?? this.hello,
        block: block ?? map?['block'] ?? this.block,
        tokens: tokens ?? this.tokens,
        parameters: parameters ?? this.parameters,
      );

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    const ValueSerializer serializer = ValueSerializer();
    return ServiceProvider(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      desc: json['desc'],
      groupId: json["group_id"],
      officialUrl: json["official_url"],
      apiUrl: json["api_url"],
      help: json["help"],
      helpUrl: json["help_url"],
      hello: json['hello'],
      editApiUrl: json['edit_api_url'],
      block: serializer.fromJson<int>(json["block"]) == 1 ? true : false,
      tokens: json["tokens"] == null
          ? []
          : List<ServiceToken>.from(
              json["tokens"]!.map(
                (x) => ServiceToken.fromJson(x),
              ),
            ),
      parameters: json["parameters"] == null
          ? []
          : List<ServiceParameter>.from(
              json["parameters"]!.map(
                (x) => ServiceParameter.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "desc": desc,
        "group_id": groupId,
        "official_url": officialUrl,
        "api_url": apiUrl,
        "help": help,
        "help_url": helpUrl,
        "hello": hello,
        "edit_api_url": editApiUrl,
        "block": block ? 1 : 0,
        "tokens": List<dynamic>.from(tokens.map((x) => x.toJson())),
        "parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
      };

  @mustCallSuper
  Future<void> onInit({
    required Group group,
    required Conversation conversation,
  }) async {
    bool? sent = AppManager.to.get(
      key: AppHiveKeys.serviceProviderIsSendHello + id + conversation.id,
    );
    if (sent == null || !sent) {
      if (hello != null && hello!.isNotEmpty) {
        receiveTextMessage(
          content: hello,
          conversationId: conversation.id,
        );
      }
      AppManager.to.set(
        key: AppHiveKeys.serviceProviderIsSendHello + id + conversation.id,
        value: true,
      );

      final emptyValueTokens = tokens.where(
        (element) => element.value.isEmpty,
      );
      if (tokens.isNotEmpty && emptyValueTokens.isNotEmpty) {
        return receiveTextMessage(
          content: help,
          conversationId: conversation.id,
        );
      }
    }
  }

  @mustCallSuper
  Future<bool> send({
    required Conversation conversation,
    required Message message,
  }) async {
    currentRequestMessage = message;

    final emptyValueTokens = tokens.where(
      (element) => element.value.isEmpty,
    );
    if (tokens.isNotEmpty && emptyValueTokens.isNotEmpty) {
      receiveErrorMessage(
        error: 'must_type_tokens'.trParams(
          {
            'tokens': emptyValueTokens.map((e) => e.name).join(' & '),
          },
        ),
        requestMessage: message,
      );
      return false;
    }

    receiveLoadingMessage(requestMessage: message);
    return true;
  }

  Future<void> receiveLoadingMessage({required Message requestMessage}) async {
    onReceived?.call(
      Message(
        id: AppUuid.value,
        type: MessageType.loading,
        serviceAvatar: avatar,
        serviceName: name,
        serviceId: id,
        fromType: MessageFromType.receive,
        createAt: DateTime.now(),
        requestMessage: requestMessage,
        conversationId: requestMessage.conversationId,
      ),
    );
  }

  Future<void> receiveErrorMessage({
    required Message requestMessage,
    dynamic error,
  }) async {
    onReceived?.call(
      Message(
        id: AppUuid.value,
        type: MessageType.error,
        serviceAvatar: avatar,
        serviceName: name,
        serviceId: id,
        content: error.toString(),
        fromType: MessageFromType.receive,
        createAt: DateTime.now(),
        requestMessage: requestMessage,
        conversationId: requestMessage.conversationId,
      ),
    );
  }

  Future<void> receiveTextMessage({
    Message? requestMessage,
    String? content,
    String? conversationId,
  }) async {
    assert(requestMessage != null || conversationId != null);
    onReceived?.call(
      Message(
        id: AppUuid.value,
        type: MessageType.text,
        serviceAvatar: avatar,
        serviceName: name,
        serviceId: id,
        content: content?.trim(),
        fromType: MessageFromType.receive,
        createAt: DateTime.now(),
        requestMessage: requestMessage,
        conversationId: conversationId ?? requestMessage?.conversationId,
      ),
    );
  }
}
