class AIPrompts {
  static String analyzeProfile(String profile, String targetRole) {
    return '''You are a professional LinkedIn profile analyst. Analyze the following LinkedIn profile for the target role of "$targetRole".

Return a JSON object with this exact structure:
{
  "overallScore": <number 0-100>,
  "sections": {
    "headline": {"score": <0-100>, "feedback": "<1-2 sentences>"},
    "summary": {"score": <0-100>, "feedback": "<1-2 sentences>"},
    "experience": {"score": <0-100>, "feedback": "<1-2 sentences>"},
    "skills": {"score": <0-100>, "feedback": "<1-2 sentences>"},
    "education": {"score": <0-100>, "feedback": "<1-2 sentences>"}
  },
  "recommendations": [
    "<actionable recommendation 1>",
    "<actionable recommendation 2>",
    "<actionable recommendation 3>",
    "<actionable recommendation 4>",
    "<actionable recommendation 5>"
  ]
}

IMPORTANT: Return ONLY the JSON object, no markdown, no explanation.

Profile:
$profile''';
  }

  static String generateHeadlines(String profile, String targetRole) {
    return '''You are a LinkedIn headline optimization expert. Based on the following profile and target role "$targetRole", generate 10 compelling LinkedIn headlines.

Return a JSON array with this exact structure:
[
  {"text": "<headline 1>", "style": "Professional"},
  {"text": "<headline 2>", "style": "Creative"},
  {"text": "<headline 3>", "style": "Keyword-Rich"},
  {"text": "<headline 4>", "style": "Achievement-Based"},
  {"text": "<headline 5>", "style": "Value Proposition"},
  {"text": "<headline 6>", "style": "Industry Expert"},
  {"text": "<headline 7>", "style": "Story-Driven"},
  {"text": "<headline 8>", "style": "Metric-Focused"},
  {"text": "<headline 9>", "style": "Mission-Driven"},
  {"text": "<headline 10>", "style": "Hybrid"}
]

IMPORTANT: Return ONLY the JSON array, no markdown, no explanation.

Profile:
$profile''';
  }

  static String generateSummary(String profile, String targetRole, String tone) {
    return '''You are a LinkedIn summary writing expert. Write a compelling LinkedIn summary based on the following profile for the target role of "$targetRole".

Tone: $tone

Guidelines for $tone tone:
${_toneGuidelines(tone)}

Return a JSON object with this exact structure:
{
  "summary": "<the complete summary text, 150-300 words>",
  "wordCount": <number>,
  "keyStrengths": ["<strength 1>", "<strength 2>", "<strength 3>"]
}

IMPORTANT: Return ONLY the JSON object, no markdown, no explanation.

Profile:
$profile''';
  }

  static String _toneGuidelines(String tone) {
    switch (tone) {
      case 'Professional':
        return '- Formal, authoritative language\n- Focus on achievements and expertise\n- Industry-standard terminology\n- Data-driven statements';
      case 'Creative':
        return '- Engaging, story-driven narrative\n- Personality-forward approach\n- Metaphors and vivid language\n- Memorable opening hook';
      case 'Executive':
        return '- C-suite level gravitas\n- Strategic vision focus\n- Leadership and impact emphasis\n- Concise, powerful statements';
      default:
        return '- Clear and professional';
    }
  }
}
