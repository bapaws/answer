// {
//   "id": 0,
//   "name": "New Chat",
//   "plugin_key": "Chat",
//   "group_id": 0,
//   "messages": {
//     "id": "",
//     "type": 0,
//     "from_type": 0,
//     "service_provider": {
//       "id": 0,
//       "name": "New Chat",
//       "avatar": "",
//       "group_id": 0
//     },
//     "content": "",
//     "create_at": 1,
//     "data": "",
//     "conversation_id": 1
//   }
// }

import 'package:answer/app/data/models/value_serializer.dart';

class Conversation {
  final String id;
  final String? name;
  final String? editName;
  final int? groupId;
  final int autoQuote;
  final int timeout;
  final int maxTokens;
  final String? promptId;

  String? get displayName => name ?? editName;

  const Conversation({
    required this.id,
    this.name,
    this.editName,
    this.groupId,
    this.autoQuote = 0,
    this.timeout = 60,
    this.maxTokens = 800,
    this.promptId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    const serializer = ValueSerializer();
    return Conversation(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      editName: serializer.fromJson<String?>(json['edit_name']),
      groupId: serializer.fromJson<int>(json['group_id']),
      autoQuote: serializer.fromJson<int?>(json['auto_quote']) ?? 0,
      timeout: serializer.fromJson<int?>(json['timeout']) ?? 60,
      maxTokens: serializer.fromJson<int?>(json['max_tokens']) ?? 800,
      promptId: serializer.fromJson<String?>(json['prompt_id']),
    );
  }

  Map<String, dynamic> toJson() {
    const serializer = ValueSerializer();
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'edit_name': serializer.toJson<String?>(editName),
      'group_id': serializer.toJson<int?>(groupId),
      'auto_quote': serializer.toJson<int?>(autoQuote) ?? 0,
      'timeout': serializer.toJson<int?>(timeout),
      'max_tokens': serializer.toJson<int?>(maxTokens),
      'prompt_id': serializer.toJson<String?>(promptId),
    };
  }

  Conversation copyWith({
    String? id,
    String? name,
    String? editName,
    String? pluginKey,
    int? groupId,
    int? autoQuote,
    int? timeout,
    int? maxTokens,
    String? promptId,
  }) =>
      Conversation(
        id: id ?? this.id,
        name: name ?? this.name,
        editName: editName ?? this.editName,
        groupId: groupId ?? this.groupId,
        autoQuote: autoQuote ?? this.autoQuote,
        timeout: timeout ?? this.timeout,
        maxTokens: maxTokens ?? this.maxTokens,
        promptId: promptId ?? this.promptId,
      );
  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('editName: $editName')
          ..write('groupId: $groupId')
          ..write('autoQuote: $autoQuote')
          ..write('timeout: $timeout')
          ..write('maxTokens: $maxTokens')
          ..write('promptId: $promptId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        editName,
        groupId,
        autoQuote,
        timeout,
        maxTokens,
        promptId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversation &&
          other.id == id &&
          other.name == name &&
          other.editName == editName &&
          other.autoQuote == autoQuote &&
          other.groupId == groupId &&
          other.maxTokens == maxTokens &&
          other.promptId == promptId &&
          other.timeout == timeout);
}
