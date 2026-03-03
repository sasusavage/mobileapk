import 'package:flutter/foundation.dart';
import '../models/coin.dart';
import '../services/api_service.dart';

/// ViewModel for managing cryptocurrency data state
/// Follows MVVM pattern - separates business logic from UI
class CoinViewModel extends ChangeNotifier {
  // Dependencies
  final ApiService _apiService = ApiService();

  // State variables
  List<Coin> _coins = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCurrency = 'usd';

  // Getters for UI to access state (read-only)
  List<Coin> get coins => _coins;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCurrency => _selectedCurrency;

  // Computed properties
  double get totalMarketCap {
    return _coins.fold(0, (sum, coin) => sum + coin.marketCap);
  }

  /// Load coins from API
  Future<void> loadCoins() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Update UI to show loading indicator

    try {
      _coins = await _apiService.fetchCoins(currency: _selectedCurrency);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners(); // Update UI with fetched data
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners(); // Update UI with error message
    }
  }

  /// Refresh coins (for pull-to-refresh)
  Future<void> refreshCoins() async {
    await loadCoins();
  }

  /// Change currency and reload data
  Future<void> changeCurrency(String currency) async {
    if (_selectedCurrency != currency) {
      _selectedCurrency = currency;
      await loadCoins();
    }
  }

  /// Search coins by name or symbol
  List<Coin> searchCoins(String query) {
    if (query.isEmpty) return _coins;
    final lowerQuery = query.toLowerCase();
    return _coins.where((coin) {
      return coin.name.toLowerCase().contains(lowerQuery) ||
          coin.symbol.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get coin by ID
  Coin? getCoinById(String id) {
    try {
      return _coins.firstWhere((coin) => coin.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
