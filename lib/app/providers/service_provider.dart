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
import 'package:answer/app/data/models/service_token.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:answer/app/providers/service_vendor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/models/group.dart';
import '../data/models/message.dart';
import '../data/models/value_serializer.dart';
import '../modules/home/controllers/home_controller.dart';

typedef ServiceProviderCallback = Future<void> Function(Message message);

class ServiceProvider {
  static const loadingIdPrefix = 'loading__';
  static const errorIdPrefix = 'error__';

  String id;
  String vendorId;
  String model;
  String name;
  String avatar;
  String? desc;
  int groupId;
  bool block;

  Message? currentRequestMessage;

  ServiceProvider({
    required this.id,
    required this.vendorId,
    required this.model,
    required this.name,
    required this.avatar,
    required this.desc,
    required this.groupId,
    this.block = false,
  });

  factory ServiceProvider.fromRawJson(String str) =>
      ServiceProvider.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  ServiceProvider copyWith({
    String? id,
    String? vendorId,
    String? model,
    String? name,
    String? avatar,
    String? desc,
    int? groupId,
    bool? block,
    Map<String, dynamic>? map,
  }) =>
      ServiceProvider(
        id: id ?? map?['id'] ?? this.id,
        vendorId: vendorId ?? map?['vendor_id'] ?? this.vendorId,
        model: model ?? map?['model'] ?? this.model,
        name: name ?? map?['name'] ?? this.name,
        avatar: avatar ?? map?['avatar'] ?? this.avatar,
        desc: desc ?? map?['desc'] ?? this.desc,
        groupId: groupId ?? map?['group_id'] ?? this.groupId,
        block: block ?? map?['block'] ?? this.block,
      );

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    const ValueSerializer serializer = ValueSerializer();
    return ServiceProvider(
      id: json["id"],
      vendorId: json["vendor_id"],
      model: json["model"],
      name: json["name"],
      avatar: json["avatar"],
      desc: json['desc'],
      groupId: json["group_id"],
      block: serializer.fromJson<int>(json["block"]) == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": vendorId,
        "model": model,
        "name": name,
        "avatar": avatar,
        "desc": desc,
        "group_id": groupId,
        "block": block ? 1 : 0,
      };

  ServiceVendor get vendor =>
      ServiceProviderManager.instance.vendors.firstWhere(
        (element) => element.id == vendorId,
      );

  Iterable<ServiceToken> get tokens =>
      ServiceProviderManager.instance.tokens.where(
        (element) => element.vendorId == vendorId,
      );

  @mustCallSuper
  Future<void> onInit({
    required Group group,
    required Conversation conversation,
  }) async {
    bool? sent = AppManager.to.get(
      key: AppHiveKeys.serviceProviderIsSendHello + vendorId + conversation.id,
    );
    if (sent == null || !sent) {
      if (vendor.hello != null && vendor.hello!.isNotEmpty) {
        receiveTextMessage(
          content: vendor.hello?.tr,
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
          content: vendor.help,
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
    HomeController.to.onReceived(
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
    HomeController.to.onReceived(
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
    HomeController.to.onReceived(
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

  Future<void> receiveSystemMessage({
    String? content,
    String? conversationId,
  }) async {
    HomeController.to.onReceived(
      Message(
        id: AppUuid.value,
        type: MessageType.vendor,
        serviceAvatar: avatar,
        serviceName: name,
        serviceId: id,
        content: content?.trim(),
        fromType: MessageFromType.receive,
        createAt: DateTime.now(),
        conversationId: conversationId,
      ),
    );
  }
}
