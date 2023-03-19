// {
//   "id": 0,
//   "title": "",
//   "content": ""
// }

import 'dart:convert';

class Prompt {
  Prompt({
    this.id,
    this.title,
    this.content,
  });

  final String? id;
  final String? title;
  final String? content;

  Prompt copyWith({
    String? id,
    String? title,
    String? content,
  }) =>
      Prompt(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
      );

  factory Prompt.fromRawJson(String str) => Prompt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prompt.fromJson(Map<String, dynamic> json) => Prompt(
        id: json["id"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
      };
}
