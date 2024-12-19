import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  String id, productId;
  final int quantity;

  CartModel({
    required this.id,
    required this.productId,
    required this.quantity,
  });
}
