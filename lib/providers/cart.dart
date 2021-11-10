import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartItem(
      {required this.id,
      required this.productId,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              productId: existingCartItem.productId,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem({
    required Product product,
  }) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id!,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              productId: existingCartItem.productId,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          product.id!,
          () => CartItem(
              id: DateTime.now().toString(),
              productId: product.id!,
              title: product.title,
              quantity: 1,
              price: product.price));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
