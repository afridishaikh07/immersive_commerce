import '../../domain/entities/favorite.dart';
import '../../domain/entities/product.dart';

class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.userId,
    required super.productId,
    required super.addedAt,
    super.product,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'addedAt': addedAt.toIso8601String(),
      'product': product?.toJson(),
    };
  }

  factory FavoriteModel.fromEntity(Favorite favorite) {
    return FavoriteModel(
      userId: favorite.userId,
      productId: favorite.productId,
      addedAt: favorite.addedAt,
      product: favorite.product,
    );
  }
}
