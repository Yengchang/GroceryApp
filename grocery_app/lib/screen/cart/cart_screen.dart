import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/providers/cart_porvider.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/screen/cart/cart_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/services/global_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make you happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        :
        // ignore: dead_code
        Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Cart (${cartItemList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        title: 'Empty your Wishlist',
                        subtitle: 'Are you sure to clear wishlist?',
                        fct: () async {
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearLocalCart();
                        },
                        context: context);
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                          value: cartItemList[index],
                          child: CartWidget(
                            q: cartItemList[index].quantity,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    Size size = Utils(ctx).getScreenSize;
    final Color color = Utils(ctx).color;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);

    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      //color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  User? user = authInstance.currentUser;
                  final productProvider =
                      Provider.of<ProductsProvider>(ctx, listen: false);

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct =
                        productProvider.findProdById(value.productId);
                    try {
                      final orderId = const Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                                ? getCurrProduct.salePrice
                                : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Your order has been placed",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                      );
                    } catch (error) {
                      // ignore: use_build_context_synchronously
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      TextWidget(text: 'Order Now', color: color, textSize: 20),
                ),
              ),
            ),
            const Spacer(),
            TextWidget(
              text: 'Total: \$${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTitle: true,
            )
          ],
        ),
      ),
    );
  }
}
