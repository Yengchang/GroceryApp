import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screens/product_details.dart';
import 'package:grocery_app/models/wishlist_model.dart';
import 'package:grocery_app/providers/cart_porvider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../consts/firebase_consts.dart';
import '../../services/global_method.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrProduct =
        productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, //.withOpacity(0.5),
            border: Border.all(
              color: color,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrProduct.imageUrl,
                    width: size.width * 0.21,
                    height: size.width * 0.2,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _isInCart
                                ? null
                                : () async {
                                    // Add to cart from the product Details
                                    final User? user = authInstance.currentUser;
                                    if (user == null) {
                                      GlobalMethods.errorDialog(
                                          subtitle:
                                              'No user found, please login',
                                          context: context);
                                      return;
                                    }
                                    await GlobalMethods.addToCart(
                                        productId: getCurrProduct.id,
                                        quantity: 1,
                                        context: context);
                                    await cartProvider.fetchCart();
                                  },
                            icon: _isInCart
                                ? const Icon(
                                    IconlyBold.bag2,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    IconlyLight.bag2,
                                    color: color,
                                  ),
                          ),
                          HeartBTN(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          )
                        ],
                      ),
                    ),
                    TextWidget(
                      text: getCurrProduct.title,
                      color: color,
                      textSize: 20,
                      maxLines: 1,
                      isTitle: true,
                    ),
                    const SizedBox(height: 12),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 18,
                      maxLines: 1,
                      isTitle: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
