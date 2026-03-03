/// Coin model representing cryptocurrency data from CoinGecko API
class Coin {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double priceChangePercentage24h;
  final double high24h;
  final double low24h;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.priceChangePercentage24h,
    required this.high24h,
    required this.low24h,
  });

  /// Factory constructor to create Coin from JSON map
  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? 'Unknown',
      image: json['image'],
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] ?? 0).toDouble(),
      high24h: (json['high_24h'] ?? 0).toDouble(),
      low24h: (json['low_24h'] ?? 0).toDouble(),
    );
  }

  /// Convert Coin to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'price_change_percentage_24h': priceChangePercentage24h,
      'high_24h': high24h,
      'low_24h': low24h,
    };
  }

  @override
  String toString() {
    return 'Coin(id: $id, name: $name, price: \$$currentPrice)';
  }
}
