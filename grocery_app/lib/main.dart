import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/consts/theme_data.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/inner_screens/cat_screen.dart';
import 'package:grocery_app/inner_screens/feeds_screen.dart';
import 'package:grocery_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_app/inner_screens/product_details.dart';
import 'package:grocery_app/providers/dark_theme_provider.dart';
import 'package:grocery_app/providers/cart_porvider.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/viewed_prod_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screen/auth/forget_pass.dart';
import 'package:grocery_app/screen/auth/login.dart';
import 'package:grocery_app/screen/auth/register.dart';
import 'package:grocery_app/screen/orders/orders_screen.dart';
import 'package:grocery_app/screen/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBl4lQhXWA6_4iCSn7IOoB3NupTb2mBr-g",
      appId: "1:62702406146:android:7b4cc424cda10958b5f51b",
      messagingSenderId: "62702406146",
      projectId: "grocery-flutter-course-81699",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),

        ),
        
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const FetchScreen(),
            routes: {
              OnSaleScreen.routeName: (context) => const OnSaleScreen(),
              FeedsScreen.routeName: (context) => const FeedsScreen(),
              ProductDetails.routeName: (context) => const ProductDetails(),
              WishlistScreen.routeName: (context) => const WishlistScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              ViewedRecentlyScreen.routeName: (context) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              LoginScreen.routeName: (context) => const LoginScreen(),
              ForgetPasswordScreen.routeName: (context) =>
                  const ForgetPasswordScreen(),
              CategoryScreen.routeName: (context) => const CategoryScreen(),
            },
          );
        },
      ),
    );
  }
}
