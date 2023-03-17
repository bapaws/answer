// {
//   "key": "",
//   "value": "",
//   "value_type": 0,
//   "choices": [
//     "value1",
//     "value2"
//   ],
//   "desc": "",
//   "required": false
// }

import 'dart:convert';

enum ServiceParameterValueType { integer, string, choices, boolean }

class ServiceParameter {
  ServiceParameter({
    this.key,
    this.value,
    this.valueType = ServiceParameterValueType.string,
    this.choices,
    this.desc,
    this.required = false,
  });

  final String? key;
  final String? value;
  final ServiceParameterValueType valueType;
  final List<String>? choices;
  final String? desc;
  final bool? required;

  ServiceParameter copyWith({
    String? key,
    String? value,
    ServiceParameterValueType? valueType,
    List<String>? choices,
    String? desc,
    bool? required,
  }) =>
      ServiceParameter(
        key: key ?? this.key,
        value: value ?? this.value,
        valueType: valueType ?? this.valueType,
        choices: choices ?? this.choices,
        desc: desc ?? this.desc,
        required: required ?? this.required,
      );

  factory ServiceParameter.fromRawJson(String str) =>
      ServiceParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServiceParameter.fromJson(Map<String, dynamic> json) =>
      ServiceParameter(
        key: json["key"],
        value: json["value"],
        valueType: ServiceParameterValueType.values[json["value_type"] ?? 0],
        choices: json["choices"] == null
            ? []
            : List<String>.from(json["choices"]!.map((x) => x)),
        desc: json["desc"],
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "value_type": valueType.index,
        "choices":
            choices == null ? [] : List<dynamic>.from(choices!.map((x) => x)),
        "desc": desc,
        "required": required,
      };
}
