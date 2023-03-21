import 'dart:convert';

class ServiceVendor {
  String id;
  String name;
  String? avatar;
  String? officialUrl;
  String? apiUrl;
  String? editApiUrl;
  String? hello;
  String? help;
  String? helpUrl;

  String? get url => editApiUrl ?? apiUrl;

  ServiceVendor({
    required this.id,
    required this.name,
    required this.avatar,
    required this.officialUrl,
    required this.apiUrl,
    required this.hello,
    this.editApiUrl,
    required this.help,
    required this.helpUrl,
  });

  factory ServiceVendor.fromRawJson(String str) =>
      ServiceVendor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  ServiceVendor copyWith({
    String? id,
    String? name,
    String? avatar,
    String? officialUrl,
    String? apiUrl,
    String? help,
    String? helpUrl,
    String? hello,
    String? editApiUrl,
    Map<String, dynamic>? map,
  }) =>
      ServiceVendor(
        id: id ?? map?['id'] ?? this.id,
        name: name ?? map?['name'] ?? this.name,
        avatar: avatar ?? map?['avatar'] ?? this.avatar,
        officialUrl: officialUrl ?? map?['official_url'] ?? this.officialUrl,
        apiUrl: apiUrl ?? map?['api_url'] ?? this.apiUrl,
        help: help ?? map?['help'] ?? this.help,
        hello: hello ?? map?['hello'] ?? this.hello,
        helpUrl: helpUrl ?? map?['help_url'] ?? this.helpUrl,
        editApiUrl: editApiUrl ?? map?['edit_api_url'] ?? this.editApiUrl,
      );

  factory ServiceVendor.fromJson(Map<String, dynamic> json) {
    return ServiceVendor(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      officialUrl: json["official_url"],
      apiUrl: json["api_url"],
      editApiUrl: json['edit_api_url'],
      hello: json['hello'],
      help: json["help"],
      helpUrl: json["help_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    "avatar": avatar,
        "official_url": officialUrl,
        "api_url": apiUrl,
        "hello": hello,
        "help": help,
        "help_url": helpUrl,
        "edit_api_url": editApiUrl,
      };
}
