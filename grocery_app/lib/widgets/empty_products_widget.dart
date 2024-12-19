
import 'package:flutter/material.dart';
import 'package:grocery_app/services/utils.dart';

class EmptyProWidget extends StatelessWidget {
  const EmptyProWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
     final Color color = Utils(context).color;
    return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 40),
                      child: Image.asset(
                        'assets/images/box.png',
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: color,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
  }
}