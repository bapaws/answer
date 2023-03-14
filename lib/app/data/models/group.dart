// {
// 	"id": 0,
// 	"name": "Chat",
// 	"avatar": "open_ai_chat_gpt.svg",
// 	"title": "open_ai_chat_gpt.svg"
// }

import 'dart:convert';

class Group {
  Group({
    required this.id,
    required this.name,
    required this.avatar,
    required this.title,
  });

  final int id;
  final String name;
  final String avatar;
  final String title;

  Group copyWith({
    int? id,
    String? name,
    String? avatar,
    String? title,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        title: title ?? this.title,
      );

  factory Group.fromRawJson(String str) => Group.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "title": title,
      };
}
