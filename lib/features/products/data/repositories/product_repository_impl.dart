import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      return productModels;
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final productModel = await remoteDataSource.getProductById(id);
      return productModel;
    } catch (e) {
      throw Exception('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final allProducts = await getProducts();
      return allProducts
          .where((product) => product.category == category)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: ${e.toString()}');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final allProducts = await getProducts();
      final lowercaseQuery = query.toLowerCase();
      return allProducts.where((product) {
        return product.title.toLowerCase().contains(lowercaseQuery) ||
            product.description.toLowerCase().contains(lowercaseQuery) ||
            product.category.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: ${e.toString()}');
    }
  }
}
