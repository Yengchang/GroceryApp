import 'package:flutter/material.dart';

class ViewedProdModel with ChangeNotifier {
  String id, productId;

  ViewedProdModel({
    required this.id,
    required this.productId,
  });
}
