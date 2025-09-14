import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:immersive_commerce/features/products/data/datasources/favorite_local_datasource.dart';
import 'package:immersive_commerce/features/products/data/models/favorite_model.dart';

void main() {
  group('Favorites Tests', () {
    late FavoriteLocalDataSourceImpl dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      dataSource = FavoriteLocalDataSourceImpl(sharedPreferences: prefs);
    });

    test('should add favorite successfully', () async {
      // Arrange
      const userId = 'test_user';
      const productId = 'test_product';
      final favorite = FavoriteModel(
        userId: userId,
        productId: productId,
        addedAt: DateTime.now(),
      );

      // Act
      await dataSource.addFavorite(userId, favorite);

      // Assert
      final favorites = await dataSource.getCachedFavorites(userId);
      expect(favorites.length, 1);
      expect(favorites.first.productId, productId);
    });

    test('should remove favorite successfully', () async {
      // Arrange
      const userId = 'test_user';
      const productId = 'test_product';
      final favorite = FavoriteModel(
        userId: userId,
        productId: productId,
        addedAt: DateTime.now(),
      );
      await dataSource.addFavorite(userId, favorite);

      // Act
      await dataSource.removeFavorite(userId, productId);

      // Assert
      final favorites = await dataSource.getCachedFavorites(userId);
      expect(favorites.length, 0);
    });

    test('should check if favorite exists', () async {
      // Arrange
      const userId = 'test_user';
      const productId = 'test_product';
      final favorite = FavoriteModel(
        userId: userId,
        productId: productId,
        addedAt: DateTime.now(),
      );
      await dataSource.addFavorite(userId, favorite);

      // Act & Assert
      final isFavorite = await dataSource.isFavoriteCached(userId, productId);
      expect(isFavorite, true);

      final isNotFavorite = await dataSource.isFavoriteCached(
        userId,
        'other_product',
      );
      expect(isNotFavorite, false);
    });
  });
}
