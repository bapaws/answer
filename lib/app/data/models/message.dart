// {
// 	"id": "",
// 	"type": 0,
// 	"from_type": 0,
// 	"content": "",
// 	"create_at": 1,
//  "request_message": "",
// 	"response_data": "",
// 	"conversation_id": 1
// 	"service_id": 1
// }

import 'dart:convert';

import 'package:answer/app/data/models/value_serializer.dart';

enum MessageType { text, image, loading, error }

enum MessageFromType { receive, send }

class Message {
  static const loadingIdPrefix = 'loading__';
  static const errorIdPrefix = 'error__';

  final String? id;
  final MessageType? type;
  final MessageFromType? fromType;
  final String? serviceName;
  final String? serviceAvatar;
  final String? content;
  final DateTime? createAt;
  final Message? requestMessage;
  final String? responseData;
  final String? conversationId;
  final String? serviceId;

  String get loadingId => '$loadingIdPrefix$id';
  String get errorId => '$errorIdPrefix$id';

  const Message({
    this.id,
    this.type,
    this.fromType,
    this.serviceName,
    this.serviceAvatar,
    this.content,
    this.createAt,
    this.requestMessage,
    this.responseData,
    required this.conversationId,
    this.serviceId,
  });

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) {
    const serializer = ValueSerializer();
    final requestMessageJson =
        serializer.fromJson<String?>(json["request_message"]);
    return Message(
      id: serializer.fromJson<String?>(json['id']),
      type: MessageType.values[serializer.fromJson<int?>(json['type']) ?? 0],
      fromType: MessageFromType
          .values[serializer.fromJson<int?>(json['from_type']) ?? 0],
      serviceName: serializer.fromJson<String?>(json['service_name']),
      serviceAvatar: serializer.fromJson<String?>(json['service_avatar']),
      content: serializer.fromJson<String?>(json['content']),
      createAt: serializer.fromJson<DateTime?>(json['create_at']),
      requestMessage: requestMessageJson == null
          ? null
          : Message.fromRawJson(requestMessageJson),
      responseData: serializer.fromJson<String?>(json["response_data"]),
      conversationId: serializer.fromJson<String?>(json['conversation_id']),
      serviceId: serializer.fromJson<String?>(json['service_id']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    const serializer = ValueSerializer();
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'type': serializer.toJson<int?>(type?.index),
      'from_type': serializer.toJson<int?>(fromType?.index),
      'service_name': serializer.toJson<String?>(serviceName),
      'service_avatar': serializer.toJson<String?>(serviceAvatar),
      'content': serializer.toJson<String?>(content),
      'create_at': serializer.toJson<DateTime?>(createAt),
      'request_message':
          serializer.toJson<String?>(requestMessage?.toRawJson()),
      'response_data': serializer.toJson<String?>(responseData),
      'conversation_id': serializer.toJson<String?>(conversationId),
      'service_id': serializer.toJson<String?>(serviceId),
    };
  }

  Message copyWith({
    String? id,
    MessageType? type,
    MessageFromType? fromType,
    String? serviceName,
    String? serviceAvatar,
    String? content,
    DateTime? createAt,
    Message? requestMessage,
    String? responseData,
    String? conversationId,
    String? serviceId,
  }) =>
      Message(
        id: id ?? this.id,
        type: type ?? this.type,
        fromType: fromType ?? this.fromType,
        serviceName: serviceName ?? this.serviceName,
        serviceAvatar: serviceAvatar ?? this.serviceAvatar,
        content: content ?? this.content,
        createAt: createAt ?? this.createAt,
        requestMessage: requestMessage ?? this.requestMessage,
        responseData: responseData ?? this.responseData,
        conversationId: conversationId ?? this.conversationId,
        serviceId: serviceId ?? this.serviceId,
      );

  @override
  String toString() {
    return (StringBuffer('MessageMetadata(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('fromType: $fromType, ')
          ..write('serviceName: $serviceName, ')
          ..write('serviceAvatar: $serviceAvatar, ')
          ..write('content: $content, ')
          ..write('createAt: $createAt, ')
          ..write('data: $requestMessage, ')
          ..write('data: $responseData, ')
          ..write('conversationId: $conversationId')
          ..write('serviceId: $serviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        fromType,
        serviceName,
        serviceAvatar,
        content,
        createAt,
        requestMessage,
        responseData,
        conversationId,
        serviceId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == id &&
          other.type == type &&
          other.fromType == fromType &&
          other.serviceName == serviceName &&
          other.serviceAvatar == serviceAvatar &&
          other.content == content &&
          other.createAt == createAt &&
          other.requestMessage == requestMessage &&
          other.responseData == responseData &&
          other.conversationId == conversationId &&
          other.serviceId == serviceId);
}
