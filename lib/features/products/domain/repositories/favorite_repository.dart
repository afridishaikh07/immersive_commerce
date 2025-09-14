import '../entities/favorite.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getFavorites(String userId);
  Future<void> addToFavorites(String userId, String productId);
  Future<void> removeFromFavorites(String userId, String productId);
  Future<bool> isFavorite(String userId, String productId);
}
