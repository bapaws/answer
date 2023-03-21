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
    required this.vendorId,
  });

  final String id;
  final String name;
  final String value;
  final String vendorId;

  ServiceToken copyWith({
    String? id,
    String? name,
    String? value,
    String? vendorId,
  }) =>
      ServiceToken(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        vendorId: vendorId ?? this.vendorId,
      );

  factory ServiceToken.fromRawJson(String str) =>
      ServiceToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServiceToken.fromJson(Map<String, dynamic> json) => ServiceToken(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        vendorId: json["service_provider_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "service_provider_id": vendorId,
      };
}
