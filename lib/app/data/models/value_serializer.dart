import 'package:flutter/foundation.dart';

class ValueSerializer {
  final bool serializeDateTimeValuesAsString;

  const ValueSerializer({this.serializeDateTimeValuesAsString = false});

  T fromJson<T>(dynamic json) {
    if (json == null) {
      return null as T;
    }

    final typeList = <T>[];

    if (typeList is List<DateTime?>) {
      if (json is int) {
        return DateTime.fromMillisecondsSinceEpoch(json) as T;
      } else {
        return DateTime.parse(json.toString()) as T;
      }
    }

    if (typeList is List<double?> && json is int) {
      return json.toDouble() as T;
    }

    // blobs are encoded as a regular json array, so we manually convert that to
    // a Uint8List
    if (typeList is List<Uint8List?> && json is! Uint8List) {
      final asList = (json as List).cast<int>();
      return Uint8List.fromList(asList) as T;
    }

    return json as T;
  }

  dynamic toJson<T>(T value) {
    if (value is DateTime) {
      return serializeDateTimeValuesAsString
          ? value.toIso8601String()
          : value.millisecondsSinceEpoch;
    }

    return value;
  }
}
