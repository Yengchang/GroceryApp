import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/providers/cart_porvider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  static const routeName = "/ProductDetails";

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productProvider.findProdById(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    // final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        //  viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: [
            FancyShimmerImage(
              imageUrl: getCurrProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
              //  height: size.height * 0.4,
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextWidget(
                              text: getCurrProduct.title,
                              color: color,
                              textSize: 25,
                              isTitle: true,
                            ),
                          ),
                          HeartBTN(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: '\$${usedPrice.toStringAsFixed(2)}',
                            color: color,
                            textSize: 22,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: getCurrProduct.isPiece ? 'Piece' : '/Kg',
                            color: color,
                            textSize: 12,
                            isTitle: false,
                          ),
                          const SizedBox(width: 10),
                          Visibility(
                            visible: getCurrProduct.isOnSale ? true : false,
                            child: Text(
                              '\$${getCurrProduct.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextWidget(
                              text: 'Free delivery',
                              color: Colors.white,
                              textSize: 20,
                              isTitle: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _quantityController(
                          fct: () {
                            if (_quantityTextController.text == '1') {
                              return;
                            } else {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text) -
                                            1)
                                        .toString();
                              });
                            }
                          },
                          color: Colors.red,
                          icon: CupertinoIcons.minus,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _quantityTextController,
                            key: const ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {}
                              });
                            },
                            style: TextStyle(color: color),
                          ),
                        ),
                        const SizedBox(width: 5),
                        _quantityController(
                          fct: () {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) + 1)
                                      .toString();
                            });
                          },
                          color: Colors.green,
                          icon: CupertinoIcons.plus,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Total',
                                  color: Colors.red.shade300,
                                  textSize: 20,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '\$${totalPrice.toStringAsFixed(2)}/',
                                        color: color,
                                        textSize: 20,
                                        isTitle: true,
                                      ),
                                      TextWidget(
                                        text:
                                            '${_quantityTextController.text}Kg',
                                        color: color,
                                        textSize: 16,
                                        isTitle: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: _isInCart
                                    ? null
                                    : () async {
                                        // Add to cart from the product Details
                                        final User? user =
                                            authInstance.currentUser;
                                        if (user == null) {
                                          GlobalMethods.errorDialog(
                                              subtitle:
                                                  'No user found, please login',
                                              context: context);
                                          return;
                                        }
                                        await GlobalMethods.addToCart(
                                            productId: getCurrProduct.id,
                                            quantity: int.parse(
                                                _quantityTextController.text),
                                            context: context);
                                        await cartProvider.fetchCart();
                                        /*   cartProvider.addProductsToCart(
                                            productId: getCurrProduct.id,
                                            quantity: int.parse(
                                                _quantityTextController.text)); */
                                      },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextWidget(
                                        text: _isInCart
                                            ? 'In cart'
                                            : 'Add to cart',
                                        color: Colors.white,
                                        textSize: 18)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //widget to plus and minus quantity  ====>  by : Yeng
  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
