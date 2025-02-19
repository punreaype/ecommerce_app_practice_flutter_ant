import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/presentation/widgets/add_to_cart_button.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:badges/badges.dart' as badges;
import 'package:practice_7/utils/file_add_to_cart_helper.dart';
import 'package:practice_7/utils/file_whistlist_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? selectedColor;
  int? borderColor;
  bool isClicked = false;
  int cartCount = 0;
  bool init = true;
  var invoiceID = "";
  @override
  void initState() {
    super.initState();
    _updateCartCount();
    invoiceID = '#${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _updateCartCount() async {
    final count = await AddToCart.countItemsInCart();
    setState(() {
      cartCount = count;
    });
  }

  void loadWhistlist(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    var whishlistItem = prefs.getStringList('whishlist') ?? [];
    if (whishlistItem.contains(product.name)) {
      setState(() {
        isClicked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    if (init) {
      loadWhistlist(product);
      init = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.redAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: context.scrnWidth * 0.04,
            ),
            child: badges.Badge(
              badgeContent: Text(
                '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.cart,
                  );
                },
                child: SvgPicture.asset(
                  'assets/svg/cart 02.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: buildSliverBody(
              product,
              context,
            ),
          ),
          buildButtonFooter(
            context,
            product,
          ),
        ],
      ),
    );
  }

  Widget buildButtonFooter(BuildContext context, ProductModel product) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.scrnHeight * .015,
        horizontal: context.scrnWidth * .035,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: AddToCartButton(
              product: product,
              selectedColor: selectedColor ?? "",
              quantity: 1,
            ),
          ),
          SizedBox(
            width: context.scrnWidth * .05,
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.orders,
                  arguments: [
                    product,
                    invoiceID,
                    product.quantity == 0 ? '1' : product.quantity,
                  ],
                );
              },
              child: Container(
                height: context.scrnHeight * .05,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: const Center(
                  child: Text(
                    "BUY NOW",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliverBody(ProductModel product, BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Hero(
            tag: product.name,
            transitionOnUserGestures: true,
            child: Image.network(
              product.images,
              height: context.scrnHeight * .35,
              width: double.infinity,
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                color: Colors.grey.shade400,
                size: context.scrnHeight * .35,
              ),
            ),
          ),
        ),
        Buildcontainer(context: context),
        // Title
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scrnWidth * .035,
            ),
            child: SizedBox(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Price: \$${double.tryParse(product.price)?.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Bounceable(
                  onTap: () async {
                    var pref = await SharedPreferences.getInstance();
                    var wishlistItem = pref.getStringList("whishlist") ?? [];
                    setState(
                      () {
                        isClicked = !isClicked;
                      },
                    );
                    if (isClicked) {
                      await FileWhistlistHelper.addModelToFile(product);
                      wishlistItem.add(product.name);
                      IconSnackBar.show(
                        context,
                        snackBarType: SnackBarType.success,
                        direction: DismissDirection.down,
                        label: '${product.name} added to wishlist',
                      );
                    } else {
                      await FileWhistlistHelper.removeModelFromFile(product);
                      wishlistItem.remove(product.name);
                      IconSnackBar.show(
                        context,
                        snackBarType: SnackBarType.fail,
                        direction: DismissDirection.down,
                        label: '${product.name} removed from wishlist',
                      );
                    }

                    await pref.setStringList("whishlist", wishlistItem);
                  },
                  child: isClicked
                      ? SvgPicture.asset(
                          'assets/svg/love_solid.svg',
                          // ignore: deprecated_member_use
                          color: Colors.red,
                        )
                      : SvgPicture.asset('assets/svg/love.svg'),
                ),
              ),
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scrnWidth * .035,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productColors.isEmpty
                      ? "No Color "
                      : "Color: $selectedColor",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: context.scrnHeight * .055,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.productColors.isEmpty
                        ? 2
                        : product.productColors.length,
                    itemBuilder: (context, index) {
                      var color = product.productColors.isEmpty
                          ? '0xFFFFFFF'
                          : product.productColors[index].hexValue;
                      return Bounceable(
                        onTap: () {
                          setState(
                            () {
                              selectedColor =
                                  product.productColors[index].colorName;
                              borderColor = index;
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: context.scrnWidth * .03,
                          ),
                          child: Container(
                            width: context.scrnWidth * .125,
                            height: context.scrnHeight * .055,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(int.parse(color
                                  .replaceFirst('#', '0xFF')
                                  .split(',')
                                  .first
                                  .replaceFirst('#', '0xFF'))),
                              border: borderColor == index
                                  ? Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scrnWidth * .035,
            ),
            child: SizedBox(
              height: context.scrnHeight * .08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tag',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: context.scrnHeight * .04,
                    child: product.taglist.isEmpty
                        ? const Text(
                            'No Tag',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.taglist.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.taglist[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scrnWidth * .035,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
