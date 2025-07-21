import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // Ganti dengan API Key-mu
  final String apiKey = 'AIzaSyAzY4t6KBiG2dm9NbiB66N5TVcfFr1gx3A';

  // Pilih model Gemini yang tersedia
  static const String model = 'gemini-1.5-pro-latest';

  Future<String> askGemini(String prompt) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text;
      } else {
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
