import 'package:flutter/material.dart';
import '../models/product.dart'; // Import your Product model

class CartProvider with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addProduct(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  int getProductQuantity(Product product) {
    return _cartItems.where((item) => item.id == product.id).length;
  }

  double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + item.price);
  }
}