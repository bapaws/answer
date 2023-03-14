import 'dart:convert';

class ChatGptModel {
  ChatGptModel({
    this.id,
    this.object,
    this.created,
    this.model,
    this.usage,
    this.choices,
  });

  final String? id;
  final String? object;
  final int? created;
  final String? model;
  final ChatGptUsageModel? usage;
  final List<ChatGptChoiceModel>? choices;

  ChatGptModel copyWith({
    String? id,
    String? object,
    int? created,
    String? model,
    ChatGptUsageModel? usage,
    List<ChatGptChoiceModel>? choices,
  }) =>
      ChatGptModel(
        id: id ?? this.id,
        object: object ?? this.object,
        created: created ?? this.created,
        model: model ?? this.model,
        usage: usage ?? this.usage,
        choices: choices ?? this.choices,
      );

  factory ChatGptModel.fromRawJson(String str) =>
      ChatGptModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatGptModel.fromJson(Map<String, dynamic> json) => ChatGptModel(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        usage: json["usage"] == null
            ? null
            : ChatGptUsageModel.fromJson(json["usage"]),
        choices: json["choices"] == null
            ? []
            : List<ChatGptChoiceModel>.from(
                json["choices"]!.map((x) => ChatGptChoiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "usage": usage?.toJson(),
        "choices": choices == null
            ? []
            : List<dynamic>.from(choices!.map((x) => x.toJson())),
      };
}

class ChatGptChoiceModel {
  ChatGptChoiceModel({
    this.message,
    this.finishReason,
    this.index,
  });

  final ChatGptMessageModel? message;
  final String? finishReason;
  final int? index;

  ChatGptChoiceModel copyWith({
    ChatGptMessageModel? message,
    String? finishReason,
    int? index,
  }) =>
      ChatGptChoiceModel(
        message: message ?? this.message,
        finishReason: finishReason ?? this.finishReason,
        index: index ?? this.index,
      );

  factory ChatGptChoiceModel.fromRawJson(String str) =>
      ChatGptChoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatGptChoiceModel.fromJson(Map<String, dynamic> json) =>
      ChatGptChoiceModel(
        message: json["message"] == null
            ? null
            : ChatGptMessageModel.fromJson(json["message"]),
        finishReason: json["finish_reason"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
        "finish_reason": finishReason,
        "index": index,
      };
}

class ChatGptMessageModel {
  ChatGptMessageModel({
    this.role,
    this.content,
  });

  final String? role;
  final String? content;

  ChatGptMessageModel copyWith({
    String? role,
    String? content,
  }) =>
      ChatGptMessageModel(
        role: role ?? this.role,
        content: content ?? this.content,
      );

  factory ChatGptMessageModel.fromRawJson(String str) =>
      ChatGptMessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatGptMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatGptMessageModel(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}

class ChatGptUsageModel {
  ChatGptUsageModel({
    this.promptTokens,
    this.completionTokens,
    this.totalTokens,
  });

  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;

  ChatGptUsageModel copyWith({
    int? promptTokens,
    int? completionTokens,
    int? totalTokens,
  }) =>
      ChatGptUsageModel(
        promptTokens: promptTokens ?? this.promptTokens,
        completionTokens: completionTokens ?? this.completionTokens,
        totalTokens: totalTokens ?? this.totalTokens,
      );

  factory ChatGptUsageModel.fromRawJson(String str) =>
      ChatGptUsageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatGptUsageModel.fromJson(Map<String, dynamic> json) =>
      ChatGptUsageModel(
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
