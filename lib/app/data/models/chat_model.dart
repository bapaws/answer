import 'dart:convert';

class Chat {
  Chat({
    required this.id,
    required this.object,
    required this.created,
    required this.choices,
    required this.usage,
  });

  final String id;
  final String object;
  final int created;
  final List<Choice> choices;
  final Usage usage;

  Chat copyWith({
    String? id,
    String? object,
    int? created,
    List<Choice>? choices,
    Usage? usage,
  }) =>
      Chat(
        id: id ?? this.id,
        object: object ?? this.object,
        created: created ?? this.created,
        choices: choices ?? this.choices,
        usage: usage ?? this.usage,
      );

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        usage: Usage.fromJson(json["usage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "usage": usage.toJson(),
      };
}

class Choice {
  Choice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  final int index;
  final Message message;
  final String finishReason;

  Choice copyWith({
    int? index,
    Message? message,
    String? finishReason,
  }) =>
      Choice(
        index: index ?? this.index,
        message: message ?? this.message,
        finishReason: finishReason ?? this.finishReason,
      );

  factory Choice.fromRawJson(String str) => Choice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        index: json["index"],
        message: Message.fromJson(json["message"]),
        finishReason: json["finish_reason"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "message": message.toJson(),
        "finish_reason": finishReason,
      };
}

class Message {
  Message({
    required this.role,
    required this.content,
  });

  final String role;
  final String content;

  Message copyWith({
    String? role,
    String? content,
  }) =>
      Message(
        role: role ?? this.role,
        content: content ?? this.content,
      );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}

class Usage {
  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage copyWith({
    int? promptTokens,
    int? completionTokens,
    int? totalTokens,
  }) =>
      Usage(
        promptTokens: promptTokens ?? this.promptTokens,
        completionTokens: completionTokens ?? this.completionTokens,
        totalTokens: totalTokens ?? this.totalTokens,
      );

  factory Usage.fromRawJson(String str) => Usage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
      );

  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
      };
}
