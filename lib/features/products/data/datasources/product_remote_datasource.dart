import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:immersive_commerce/core/constants/app_constants.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(AppConstants.productsEndpoint));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await http.get(
      Uri.parse('${AppConstants.productsEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ProductModel.fromJson(jsonData);
    } else {
      throw Exception('Product not found');
    }
  }
}
