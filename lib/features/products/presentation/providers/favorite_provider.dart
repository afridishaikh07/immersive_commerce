import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/favorite_local_datasource.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../domain/entities/favorite.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'product_provider.dart';

// Providers for dependencies
final favoriteLocalDataSourceProvider = Provider<FavoriteLocalDataSource>((
  ref,
) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return FavoriteLocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final localDataSource = ref.watch(favoriteLocalDataSourceProvider);
  final productDataSource = ref.watch(productRemoteDataSourceProvider);
  return FavoriteRepositoryImpl(
    localDataSource: localDataSource,
    productDataSource: productDataSource,
  );
});

// Favorites state provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Favorite>>>((ref) {
      final favoriteRepository = ref.watch(favoriteRepositoryProvider);
      final authState = ref.watch(authStateProvider);

      return FavoritesNotifier(favoriteRepository, authState);
    });

// Individual favorite status provider
final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  final favoritesAsync = ref.watch(favoritesProvider);
  final authState = ref.watch(authStateProvider);

  if (authState.hasValue &&
      authState.value != null &&
      favoritesAsync.hasValue) {
    final favorites = favoritesAsync.value!;
    return favorites.any((favorite) => favorite.productId == productId);
  }
  return false;
});

// Loading state provider for individual products
final isFavoriteLoadingProvider = Provider.family<bool, String>((
  ref,
  productId,
) {
  final favoritesNotifier = ref.watch(favoritesProvider.notifier);
  return favoritesNotifier.isProductLoading(productId);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Favorite>>> {
  final FavoriteRepository _favoriteRepository;
  final AsyncValue _authState;
  final Set<String> _loadingProducts = {};

  FavoritesNotifier(this._favoriteRepository, this._authState)
    : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  bool isProductLoading(String productId) =>
      _loadingProducts.contains(productId);

  Future<void> _loadFavorites() async {
    if (_authState.hasValue && _authState.value != null) {
      try {
        final favorites = await _favoriteRepository.getFavorites(
          _authState.value!.id,
        );
        state = AsyncValue.data(favorites);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> toggleFavorite(String productId) async {
    if (_authState.hasValue && _authState.value != null) {
      // Add to loading set
      _loadingProducts.add(productId);
      state = state; // Trigger rebuild to show loading state

      try {
        final userId = _authState.value!.id;
        final isFavorite = await _favoriteRepository.isFavorite(
          userId,
          productId,
        );

        if (isFavorite) {
          await _favoriteRepository.removeFromFavorites(userId, productId);
        } else {
          await _favoriteRepository.addToFavorites(userId, productId);
        }

        // Reload favorites
        await _loadFavorites();
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      } finally {
        // Remove from loading set
        _loadingProducts.remove(productId);
        state = state; // Trigger rebuild to hide loading state
      }
    }
  }

  Future<void> addToFavorites(String productId) async {
    if (_authState.hasValue && _authState.value != null) {
      try {
        await _favoriteRepository.addToFavorites(
          _authState.value!.id,
          productId,
        );
        await _loadFavorites();
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    if (_authState.hasValue && _authState.value != null) {
      try {
        await _favoriteRepository.removeFromFavorites(
          _authState.value!.id,
          productId,
        );
        await _loadFavorites();
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }
}
