// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  static const TITLE = 'title';
  static const DESCRIPTION = 'description';
  static const PRICE = 'price';
  static const IMAGE_URL = 'imageURL';
  static const IS_FAVORITE = 'isFavorite';

  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
