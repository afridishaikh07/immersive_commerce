import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Product>> searchProducts(String query);
}
