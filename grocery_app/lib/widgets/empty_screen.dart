import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screens/feeds_screen.dart';
import 'package:grocery_app/services/global_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText});
  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final themeState = Utils(context).getTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: size.width * 0.6,
              width: size.width * 0.7,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 5,
            ),
            TextWidget(
              text: 'Whoops',
              color: Colors.red,
              textSize: 35,
              isTitle: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.cyan.shade400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.cyan.shade400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.width * 0.18,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                disabledBackgroundColor: color,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                GlobalMethods.navigateTo(
                    ctx: context, routeName: FeedsScreen.routeName);
              },
              child: TextWidget(
                text: buttonText,
                color: themeState ? Colors.grey.shade300 : Colors.grey.shade800,
                textSize: 20,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
