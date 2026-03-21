import 'dart:convert';

enum FavoriteType { headline, summary, analysis }

class Favorite {
  final String id;
  final FavoriteType type;
  final String content;
  final String label;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.type,
    required this.content,
    required this.label,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'label': label,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      type: FavoriteType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FavoriteType.headline,
      ),
      content: json['content'] as String,
      label: json['label'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String encode() => jsonEncode(toJson());

  static Favorite decode(String source) =>
      Favorite.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
