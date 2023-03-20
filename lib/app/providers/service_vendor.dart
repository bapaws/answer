import 'dart:convert';

import 'package:answer/app/providers/service_request_parameter.dart';

import '../data/models/service_token.dart';

class ServiceVendor {
  String id;
  String name;
  String? officialUrl;
  String? apiUrl;
  String? editApiUrl;
  String? hello;
  String? help;
  String? helpUrl;

  final List<ServiceToken> tokens;

  String? get url => editApiUrl ?? apiUrl;

  ServiceVendor({
    required this.id,
    required this.name,
    required this.officialUrl,
    required this.apiUrl,
    required this.tokens,
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
    String? providerId,
    String? name,
    String? officialUrl,
    String? apiUrl,
    String? help,
    String? helpUrl,
    String? hello,
    String? editApiUrl,
    List<ServiceToken>? tokens,
    List<ServiceParameter>? parameters,
    Map<String, dynamic>? map,
  }) =>
      ServiceVendor(
        id: id ?? map?['id'] ?? this.id,
        name: name ?? map?['name'] ?? this.name,
        officialUrl: officialUrl ?? map?['official_url'] ?? this.officialUrl,
        apiUrl: apiUrl ?? map?['api_url'] ?? this.apiUrl,
        help: help ?? map?['help'] ?? this.help,
        hello: hello ?? map?['hello'] ?? this.hello,
        helpUrl: helpUrl ?? map?['help_url'] ?? this.helpUrl,
        editApiUrl: editApiUrl ?? map?['edit_api_url'] ?? this.editApiUrl,
        tokens: tokens ?? this.tokens,
      );

  factory ServiceVendor.fromJson(Map<String, dynamic> json) {
    return ServiceVendor(
      id: json["id"],
      name: json["name"],
      officialUrl: json["official_url"],
      apiUrl: json["api_url"],
      editApiUrl: json['edit_api_url'],
      hello: json['hello'],
      help: json["help"],
      helpUrl: json["help_url"],
      tokens: json["tokens"] == null
          ? []
          : List<ServiceToken>.from(
              json["tokens"]!.map(
                (x) => ServiceToken.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "official_url": officialUrl,
        "api_url": apiUrl,
        "hello": hello,
        "help": help,
        "help_url": helpUrl,
        "edit_api_url": editApiUrl,
        "tokens": List<dynamic>.from(tokens.map((x) => x.toJson())),
      };
}
