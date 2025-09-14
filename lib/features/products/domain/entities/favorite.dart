import 'product.dart';

class Favorite {
  final String userId;
  final String productId;
  final DateTime addedAt;
  final Product? product;

  const Favorite({
    required this.userId,
    required this.productId,
    required this.addedAt,
    this.product,
  });

  Favorite copyWith({
    String? userId,
    String? productId,
    DateTime? addedAt,
    Product? product,
  }) {
    return Favorite(
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'addedAt': addedAt.toIso8601String(),
      'product': product?.toJson(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite &&
        other.userId == userId &&
        other.productId == productId &&
        other.addedAt == addedAt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ productId.hashCode ^ addedAt.hashCode;
  }
}
