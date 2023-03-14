// {
//   "id": "api-key",
//   "name": "API Key",
//   "value": "",
//   "service_provider_id": 0
// }

import 'dart:convert';

class ServiceToken {
  ServiceToken({
    required this.id,
    required this.name,
    this.value = '',
    required this.serviceProviderId,
  });

  final String id;
  final String name;
  final String value;
  final String serviceProviderId;

  ServiceToken copyWith({
    String? id,
    String? name,
    String? value,
    String? serviceProviderId,
  }) =>
      ServiceToken(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      );

  factory ServiceToken.fromRawJson(String str) =>
      ServiceToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServiceToken.fromJson(Map<String, dynamic> json) => ServiceToken(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        serviceProviderId: json["service_provider_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "service_provider_id": serviceProviderId,
      };
}
