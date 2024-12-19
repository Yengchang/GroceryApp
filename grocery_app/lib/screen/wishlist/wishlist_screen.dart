import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screen/wishlist/wishlist_widget.dart';
import 'package:grocery_app/services/global_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  Size size = Utils(context).getScreenSize;  // not use yet

    final Color color = Utils(context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/wishlist.png',
            title: 'You did not place any order yet',
            subtitle: 'order something and make happy :)',
            buttonText: 'shop now',
          )
        :
        // ignore: dead_code
        Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: const BackWidget(),
              title: TextWidget(
                text: 'Wishlist (${wishlistItemList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        title: 'Clear Wishlist',
                        subtitle: 'Are you sure?',
                        fct: () async {
                          await wishlistProvider.clearOnlineWishlist();
                          wishlistProvider.clearLocalWishlist();
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
            body: MasonryGridView.count(
              itemCount: wishlistItemList.length,
              crossAxisCount: 2,
              //  mainAxisSpacing: 4,
              //  crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: wishlistItemList[index],
                  child: const WishlistWidget(),
                );
              },
            ),
          );
  }
}
