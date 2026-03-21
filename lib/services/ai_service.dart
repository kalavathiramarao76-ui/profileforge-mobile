import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String endpoint;
  final String model;

  AIService({required this.endpoint, required this.model});

  Future<String> chat(String prompt) async {
    final uri = Uri.parse(endpoint);
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
      'temperature': 0.7,
      'max_tokens': 2048,
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final message = choices[0]['message'] as Map<String, dynamic>?;
        return message?['content'] as String? ?? '';
      }
      throw Exception('No choices in response');
    } else {
      throw Exception('API error: ${response.statusCode} — ${response.body}');
    }
  }

  /// Extracts JSON from a response that might contain markdown code blocks
  static String extractJson(String raw) {
    // Try to find JSON in code blocks
    final codeBlockRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
    final match = codeBlockRegex.firstMatch(raw);
    if (match != null) {
      return match.group(1)!.trim();
    }
    // Otherwise return trimmed raw
    return raw.trim();
  }
}
