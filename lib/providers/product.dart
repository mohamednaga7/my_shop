// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String?,
        title: json['title'] as String,
        description: json['description'] as String,
        price: double.parse(json['price']),
        imageUrl: json['imageUrl'] as String,
        isFavorite: json['isFavorite'].toString().toLowerCase() == 'true',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price.toString(),
        'imageUrl': imageUrl,
        'isFavorite': isFavorite.toString(),
      };
}
