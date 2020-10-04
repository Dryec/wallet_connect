// To parse this JSON data, do
//
//     final peerMeta = peerMetaFromMap(jsonString);

import 'dart:convert';

class PeerMeta {
  PeerMeta({
    this.description,
    this.icons,
    this.name,
    this.url,
  });

  final String description;
  final List<String> icons;
  final String name;
  final String url;

  PeerMeta copyWith({
    String description,
    List<String> icons,
    String name,
    String url,
  }) =>
      PeerMeta(
        description: description ?? this.description,
        icons: icons ?? this.icons,
        name: name ?? this.name,
        url: url ?? this.url,
      );

  factory PeerMeta.fromJson(String str) => PeerMeta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PeerMeta.fromMap(Map<String, dynamic> json) => PeerMeta(
        description: json["description"] == null ? null : json["description"],
        icons: json["icons"] == null
            ? null
            : List<String>.from(json["icons"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "description": description == null ? null : description,
        "icons": icons == null ? null : List<dynamic>.from(icons.map((x) => x)),
        "name": name == null ? null : name,
        "url": url == null ? null : url,
      };
}
