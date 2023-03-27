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

class RequestParameter {
  RequestParameter({
    this.key,
    this.value,
    this.valueType = ServiceParameterValueType.string,
    this.desc,
    this.required = false,
    this.vendorId,
  });

  final String? key;
  final String? value;
  final ServiceParameterValueType valueType;
  final String? desc;
  final bool? required;
  final String? vendorId;

  RequestParameter copyWith({
    String? key,
    String? value,
    ServiceParameterValueType? valueType,
    List<String>? choices,
    String? desc,
    bool? required,
    String? vendorId,
  }) =>
      RequestParameter(
        key: key ?? this.key,
        value: value ?? this.value,
        valueType: valueType ?? this.valueType,
        desc: desc ?? this.desc,
        required: required ?? this.required,
        vendorId: vendorId ?? this.vendorId,
      );

  factory RequestParameter.fromRawJson(String str) =>
      RequestParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestParameter.fromJson(Map<String, dynamic> json) =>
      RequestParameter(
        key: json["key"],
        value: json["value"],
        valueType: ServiceParameterValueType.values[json["value_type"] ?? 0],
        desc: json["desc"],
        required: json["required"] == 1,
        vendorId: json["vendor_id"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "value_type": valueType.index,
        "desc": desc,
        "required": required == true ? 1 : 0,
        "vendor_id": vendorId,
      };
}
