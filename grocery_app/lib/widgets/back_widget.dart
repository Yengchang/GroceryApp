import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/services/utils.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({super.key});

  @override
  Widget build(BuildContext context) {
   // Size size = Utils(context).getScreenSize;   // I comment it I think it not be use in the widget  Yeng
    final Color color = Utils(context).color;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        IconlyLight.arrowLeft2,
        color: color,
      ),
    );
  }
}
