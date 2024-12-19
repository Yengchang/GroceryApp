import 'package:flutter/material.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_products_widget.dart';
import 'package:grocery_app/widgets/feed_items.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreen";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];

  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productsProviders = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCat = productsProviders.findByCategory(catName);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: catName,
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: productByCat.isEmpty
          ? const EmptyProWidget(
              text: 'No products on this \n category yet!',
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        focusNode: _searchTextFocusNode,
                        controller: _searchTextController,
                        onChanged: (valuee) {
                          setState(() {
                            listProductSearch =
                                productsProviders.searchQuery(valuee);
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          hintText: "what's in your mind",
                          prefixIcon: const Icon(Icons.search),
                          suffix: IconButton(
                            onPressed: () {
                              _searchTextController!.clear();
                              _searchTextFocusNode.unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              color: _searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _searchTextController!.text.isNotEmpty &&
                          listProductSearch.isEmpty
                      ? const EmptyProWidget(
                          text: 'No found any product like this keyword')
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.zero,
                          //crossAxisSpacing: 10,
                          childAspectRatio: size.width / (size.height * 0.61),
                          children: List.generate(
                              _searchTextController.text.isNotEmpty
                                  ? listProductSearch.length
                                  : productByCat.length, (index) {
                            return ChangeNotifierProvider.value(
                              value: _searchTextController.text.isNotEmpty
                                  ? listProductSearch[index]
                                  : productByCat[index],
                              child: const FeedsWidget(),
                            );
                          }),
                        ),
                ],
              ),
            ),
    );
  }
}
