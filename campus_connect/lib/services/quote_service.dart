import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String _apiUrl = 'https://api.quotable.io/random';
  static const String _fallbackApiUrl = 'https://zenquotes.io/api/random';

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Quote.fromJson(data);
      }
    } catch (_) {}

    try {
      final fallbackResponse = await http.get(Uri.parse(_fallbackApiUrl));
      if (fallbackResponse.statusCode == 200) {
        final data = jsonDecode(fallbackResponse.body);
        if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
          final quoteData = data.first as Map<String, dynamic>;
          return Quote(
            text: quoteData['q']?.toString() ?? 'Keep moving forward.',
            author: quoteData['a']?.toString() ?? 'Unknown',
          );
        }
      }
    } catch (_) {}

    return Quote(
      text: 'Success is the sum of small efforts, repeated day in and day out.',
      author: 'Robert Collier',
    );
  }
}
