// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://petdora-578b6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
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
        'imageUrl': imageUrl
      };
}
