import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/presentation/widgets/appbar_sliver.dart';
import 'package:practice_7/presentation/widgets/empty_message.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/file_add_to_cart_helper.dart';
import 'package:practice_7/utils/file_whistlist_helper.dart';

class WhistlistScreen extends StatefulWidget {
  const WhistlistScreen({
    super.key,
  });

  @override
  State<WhistlistScreen> createState() => _WhistlistScreenState();
}

class _WhistlistScreenState extends State<WhistlistScreen> {
  List<ProductModel> whistlist = [];
  @override
  void initState() {
    super.initState();
    loadDataWhistlist();
    _updateCartCount();
  }

  int cartCount = 0;
  Future<void> _updateCartCount() async {
    final count = await AddToCart.countItemsInCart();
    setState(() {
      cartCount = count;
    });
  }

  Future<void> loadDataWhistlist() async {
    final models = await FileWhistlistHelper.readModelsFromFile();
    setState(() {
      whistlist = models.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          AppbarSliver(
            onSearch: (text) {},
            cartCount: '$cartCount',
          ),
          whistlist.isEmpty
              ? const SliverToBoxAdapter(
                  child: EmptyMessage(
                    lottieAssets: 'assets/lottie/wishlist_empty.json',
                    message: 'You have no wishlist',
                    textContent: 'Start a new wishlist',
                  ),
                )
              : SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: context.scrnWidth * .04,
                    mainAxisSpacing: context.scrnWidth * .05,
                    mainAxisExtent: context.scrnHeight * .3,
                  ),
                  itemCount: whistlist.length,
                  itemBuilder: (context, i) {
                    final product = whistlist[i];
                    return buildCart(
                      context,
                      product,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget buildCart(BuildContext context, ProductModel model) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.scrnWidth * .02,
          vertical: context.scrnHeight * .01,
        ),
        child: Bounceable(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.productDetails,
              arguments: model,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                model.images,
                height: context.scrnHeight * .18,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                width: context.scrnWidth * .35,
                height: context.scrnHeight * .08,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      model.description,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Price: \$${double.tryParse(model.price)?.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
