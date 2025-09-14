import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';
import '../models/favorite_model.dart';
import '../datasources/product_remote_datasource.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;
  final ProductRemoteDataSource productDataSource;

  FavoriteRepositoryImpl({
    required this.localDataSource,
    required this.productDataSource,
  });

  @override
  Future<List<Favorite>> getFavorites(String userId) async {
    try {
      final favoriteModels = await localDataSource.getCachedFavorites(userId);

      // Fetch product details for each favorite
      final favoritesWithProducts = <Favorite>[];
      for (final favoriteModel in favoriteModels) {
        try {
          final product = await productDataSource.getProductById(
            favoriteModel.productId,
          );
          favoritesWithProducts.add(favoriteModel.copyWith(product: product));
        } catch (e) {
          // If product not found, add favorite without product info
          favoritesWithProducts.add(favoriteModel);
        }
      }

      return favoritesWithProducts;
    } catch (e) {
      throw Exception('Failed to fetch favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      final favorite = FavoriteModel(
        userId: userId,
        productId: productId,
        addedAt: DateTime.now(),
      );
      await localDataSource.addFavorite(userId, favorite);
    } catch (e) {
      throw Exception('Failed to add to favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await localDataSource.removeFavorite(userId, productId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      return await localDataSource.isFavoriteCached(userId, productId);
    } catch (e) {
      return false;
    }
  }
}
