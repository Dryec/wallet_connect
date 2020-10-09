// To parse this JSON data, do
//
//     final ethereumTransaction = ethereumTransactionFromMap(jsonString);

import 'dart:convert';

class EthereumTransaction {
  EthereumTransaction({
    this.from,
    this.to,
    this.nonce,
    this.gasPrice,
    this.gas,
    this.gasLimit,
    this.value,
    this.data,
  });

  final String from;
  final String to;
  final String nonce;
  final String gasPrice;
  final String gas;
  final String gasLimit;
  final String value;
  final String data;

  EthereumTransaction copyWith({
    String from,
    String to,
    String nonce,
    String gasPrice,
    String gas,
    String gasLimit,
    String value,
    String data,
  }) =>
      EthereumTransaction(
        from: from ?? this.from,
        to: to ?? this.to,
        nonce: nonce ?? this.nonce,
        gasPrice: gasPrice ?? this.gasPrice,
        gas: gas ?? this.gas,
        gasLimit: gasLimit ?? this.gasLimit,
        value: value ?? this.value,
        data: data ?? this.data,
      );

  factory EthereumTransaction.fromJson(String str) =>
      EthereumTransaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EthereumTransaction.fromMap(Map<String, dynamic> json) =>
      EthereumTransaction(
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        nonce: json["nonce"] == null ? null : json["nonce"],
        gasPrice: json["gasPrice"] == null ? null : json["gasPrice"],
        gas: json["gas"] == null ? null : json["gas"],
        gasLimit: json["gasLimit"] == null ? null : json["gasLimit"],
        value: json["value"] == null ? null : json["value"],
        data: json["data"] == null ? null : json["data"],
      );

  Map<String, dynamic> toMap() => {
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "nonce": nonce == null ? null : nonce,
        "gasPrice": gasPrice == null ? null : gasPrice,
        "gas": gas == null ? null : gas,
        "gasLimit": gasLimit == null ? null : gasLimit,
        "value": value == null ? null : value,
        "data": data == null ? null : data,
      };
}
