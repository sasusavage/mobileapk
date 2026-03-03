import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

/// Service class for handling API calls to CoinGecko
class ApiService {
  // Base URL for CoinGecko API (no API key required)
  static const String _baseUrl = 'api.coingecko.com';

  /// Fetches list of cryptocurrency coins from CoinGecko API
  /// Returns a list of Coin objects sorted by market cap
  Future<List<Coin>> fetchCoins({
    String currency = 'usd',
    int perPage = 50,
    int page = 1,
  }) async {
    // 1. Build the URI properly using Uri.https (not string concatenation)
    final uri = Uri.https(
      _baseUrl,
      '/api/v3/coins/markets',
      {
        'vs_currency': currency,
        'order': 'market_cap_desc',
        'per_page': perPage.toString(),
        'page': page.toString(),
        'sparkline': 'false',
      },
    );

    try {
      // 2. Make the HTTP GET request
      final response = await http.get(uri);

      // 3. Check status code - must be 200 for success
      if (response.statusCode == 200) {
        // 4. Parse JSON response - CoinGecko returns an array directly
        final List<dynamic> jsonData = jsonDecode(response.body);

        // 5. Convert each JSON object to Coin model
        return jsonData.map((json) => Coin.fromJson(json)).toList();
      } else if (response.statusCode == 429) {
        // Rate limit exceeded
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found (404)');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error (${response.statusCode})');
      } else {
        // Handle other HTTP errors
        throw Exception('Failed to load coins: HTTP ${response.statusCode}');
      }
    } on FormatException catch (e) {
      // JSON parsing error
      throw Exception('Invalid data format: ${e.message}');
    } catch (e) {
      // Network or other errors
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }

  /// Fetches details for a single coin by ID
  Future<Coin> fetchCoinById(String coinId) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/v3/coins/markets',
      {
        'vs_currency': 'usd',
        'ids': coinId,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return Coin.fromJson(jsonData.first);
      }
      throw Exception('Coin not found');
    } else {
      throw Exception('Failed to load coin details: ${response.statusCode}');
    }
  }
}
