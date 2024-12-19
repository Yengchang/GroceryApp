import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/dark_theme_provider.dart';
import 'package:grocery_app/providers/cart_porvider.dart';
import 'package:grocery_app/screen/cart/cart_screen.dart';
import 'package:grocery_app/screen/categories.dart';
import 'package:grocery_app/screen/home_screen.dart';
import 'package:grocery_app/screen/user.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class ButtomBarScreen extends StatefulWidget {
  const ButtomBarScreen({super.key});

  @override
  State<ButtomBarScreen> createState() => _ButtomBarState();
}

class _ButtomBarState extends State<ButtomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': const CartScreen(), 'title': 'Cart Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'}
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    //  Size size = Utils(context).getScreenSize;  // not use yet
    // final Color color = Utils(context).color;

    return Scaffold(
      /* appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
      ), */
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        currentIndex: _selectedIndex,
        unselectedItemColor: _isDark ? Colors.white : Colors.black,
        selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
              label: "Categories"),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_, myCart, ch) {
                  return badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -12, end: -12),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        shape: badges.BadgeShape.circle,
                      ),
                      badgeContent: FittedBox(
                        child: Flexible(
                            child: TextWidget(
                                text: myCart.getCartItems.length
                                    .toString(), // this is the quantity in cart icon
                                color: Colors.white,
                                textSize: 15)),
                      ),
                      child: Icon(_selectedIndex == 2
                          ? IconlyBold.buy
                          : IconlyLight.buy));
                },
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? IconlyBold.profile
                  : IconlyLight.profile),
              label: "User")
        ],
      ),
    );
  }
}
