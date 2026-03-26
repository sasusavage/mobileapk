import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';

class QuoteViewModel extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();

  Quote? _currentQuote;
  bool _isLoading = false;
  String? _errorMessage;

  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRandomQuote() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final quote = await _quoteService.fetchRandomQuote();
      _currentQuote = quote;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
