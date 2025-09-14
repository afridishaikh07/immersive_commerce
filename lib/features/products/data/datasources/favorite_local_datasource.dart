import 'dart:convert';
import 'package:immersive_commerce/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_model.dart';

abstract class FavoriteLocalDataSource {
  Future<List<FavoriteModel>> getCachedFavorites(String userId);
  Future<void> cacheFavorites(String userId, List<FavoriteModel> favorites);
  Future<void> addFavorite(String userId, FavoriteModel favorite);
  Future<void> removeFavorite(String userId, String productId);
  Future<bool> isFavoriteCached(String userId, String productId);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavoriteLocalDataSourceImpl({required this.sharedPreferences});

  String _getFavoritesKey(String userId) =>
      '${AppConstants.favoritesKey}_$userId';

  @override
  Future<List<FavoriteModel>> getCachedFavorites(String userId) async {
    final favoritesJson = sharedPreferences.getString(_getFavoritesKey(userId));
    if (favoritesJson != null) {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.map((json) => FavoriteModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheFavorites(
    String userId,
    List<FavoriteModel> favorites,
  ) async {
    final favoritesJson = json.encode(
      favorites.map((f) => f.toJson()).toList(),
    );
    await sharedPreferences.setString(_getFavoritesKey(userId), favoritesJson);
  }

  @override
  Future<void> addFavorite(String userId, FavoriteModel favorite) async {
    final favorites = await getCachedFavorites(userId);
    favorites.add(favorite);
    await cacheFavorites(userId, favorites);
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    final favorites = await getCachedFavorites(userId);
    favorites.removeWhere((favorite) => favorite.productId == productId);
    await cacheFavorites(userId, favorites);
  }

  @override
  Future<bool> isFavoriteCached(String userId, String productId) async {
    final favorites = await getCachedFavorites(userId);
    return favorites.any((favorite) => favorite.productId == productId);
  }
}
