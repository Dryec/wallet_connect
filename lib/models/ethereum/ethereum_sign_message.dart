// To parse this JSON data, do
//
//     final ethereumSignMessage = ethereumSignMessageFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class EthereumSignMessage {
  EthereumSignMessage({
    @required this.raw,
    @required this.type,
  });

  final List<String> raw;
  final String type;

  EthereumSignMessage copyWith({
    List<String> raw,
    String type,
  }) =>
      EthereumSignMessage(
        raw: raw ?? this.raw,
        type: type ?? this.type,
      );

  factory EthereumSignMessage.fromJson(String str) =>
      EthereumSignMessage.fromMap(Map.from(json.decode(str)));

  String toJson() => json.encode(toMap());

  factory EthereumSignMessage.fromMap(Map<String, dynamic> json) =>
      EthereumSignMessage(
        raw: json["raw"] == null
            ? null
            : List<String>.from(json["raw"].map((x) => x)),
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "raw": raw == null ? null : List<dynamic>.from(raw.map((x) => x)),
        "type": type == null ? null : type,
      };
}
