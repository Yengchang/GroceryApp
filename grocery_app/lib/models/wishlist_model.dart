import 'package:flutter/material.dart';

class WishlistModel with ChangeNotifier {
  String id, productId;

  WishlistModel({
    required this.id,
    required this.productId,
  });
}
