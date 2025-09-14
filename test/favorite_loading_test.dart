import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:immersive_commerce/features/products/presentation/providers/favorite_provider.dart';
import 'package:immersive_commerce/features/auth/presentation/providers/auth_provider.dart';

void main() {
  group('Favorite Loading State Tests', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should track loading state for individual products', () {
      // Arrange
      const productId = 'test_product';
      final favoritesNotifier = container.read(favoritesProvider.notifier);

      // Act & Assert
      expect(favoritesNotifier.isProductLoading(productId), false);
    });

    test('should provide loading state through provider', () {
      // Arrange
      const productId = 'test_product';

      // Act
      final isLoading = container.read(isFavoriteLoadingProvider(productId));

      // Assert
      expect(isLoading, false);
    });
  });
}
