import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';

// Providers for dependencies
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDataSourceImpl();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Product state providers
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return await productRepository.getProducts();
});

final productByIdProvider = FutureProvider.family<Product, String>((
  ref,
  id,
) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return await productRepository.getProductById(id);
});

final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, category) async {
    final productRepository = ref.watch(productRepositoryProvider);
    return await productRepository.getProductsByCategory(category);
  },
);

final searchProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  query,
) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return await productRepository.searchProducts(query);
});

// Categories provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final products = await ref.watch(productsProvider.future);

  // Extract unique category names
  final categorySet = <String>{};
  for (final product in products) {
    categorySet.add(product.category);
  }

  return ['All', ...categorySet.toList()];
});
