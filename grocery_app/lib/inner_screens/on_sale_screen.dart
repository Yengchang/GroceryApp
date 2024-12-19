import 'package:flutter/material.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_products_widget.dart';
import 'package:grocery_app/widgets/on_sale_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // bool _isEmpty = false;
    final ProductProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> ProductsOnsale = ProductProviders.getOnSaleProducts;
    // final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: ProductsOnsale.isEmpty
          // ignore: dead_code
          ? const EmptyProWidget(
              text: 'No products on sale yet! \n Stay tuned',
            )
          : GridView.count(
              /*  shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), */
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.46),
              children: List.generate(
                ProductsOnsale.length,
                (index) {
                  return ChangeNotifierProvider.value(
                    value: ProductsOnsale[index],
                    child: const OnSaleWidget(),
                  );
                },
              ),
            ),
    );
  }
}
