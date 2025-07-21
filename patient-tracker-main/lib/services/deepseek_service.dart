import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  final String apiKey = 'sk-dc8b0a36c68c4dd3a35c8ed454605b30'; // Ganti dengan API key-mu sendiri

  Future<String> askDeepSeek(String prompt) async {
    final url = Uri.parse('https://api.deepseek.com/v1/chat/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": "deepseek-chat",
      "messages": [
        {
          "role": "system",
          "content":
          "You are a helpful assistant for rawat jalan rumah sakit Hermina."
        },
        {"role": "user", "content": prompt}
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
