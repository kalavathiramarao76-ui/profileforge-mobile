class Headline {
  final String text;
  final String style;

  Headline({
    required this.text,
    required this.style,
  });

  factory Headline.fromJson(Map<String, dynamic> json) {
    return Headline(
      text: json['text'] as String? ?? '',
      style: json['style'] as String? ?? 'Professional',
    );
  }
}
