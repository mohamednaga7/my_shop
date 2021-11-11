import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> _items = [];

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product getProductById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://petdora-578b6-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken$filterString');
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.containsKey('error')) {
        throw HttpException(extractedData['error']);
      }
      final favoriteUrl = Uri.parse(
          'https://petdora-578b6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> products = [];
      extractedData
          .forEach((prodId, prodData) => products.add(Product.fromJson({
                'id': prodId,
                ...prodData,
                'isFavorite':
                    favoriteData == null ? false : favoriteData[prodId] ?? false
              })));
      _items = products;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://petdora-578b6-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({...product.toJson(), 'creatorId': userId}));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == productId);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://petdora-578b6-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authToken');
      try {
        await http.patch(url, body: json.encode(newProduct.toJson()));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://petdora-578b6-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authToken');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException("Could not delete product.");
      }
      _items.removeWhere((element) => element.id == productId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
