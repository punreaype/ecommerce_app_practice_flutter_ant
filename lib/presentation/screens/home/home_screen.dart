import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_7/constant/textstyle.dart';
import 'package:practice_7/data/datasources/product.dart';
import 'package:practice_7/data/datasources/product_type.dart';
import 'package:practice_7/data/datasources/slide.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/model/product_type_model.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/file_add_to_cart_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final scrollController;
  const HomeScreen({
    super.key,
    this.scrollController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int _currentIndex = 0;
TextEditingController textController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> filteredProducts = [];

  int cartCount = 0;
  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    textController.addListener(() {
      searchProducts(textController.text);
    });
    _updateCartCount();
  }

  Future<void> _updateCartCount() async {
    // Fetch the cart count using Add2Cart
    final count = await AddToCart.countItemsInCart();
    setState(() {
      cartCount = count;
    });
  }

  void searchProducts(String query) {
    setState(
      () {
        if (query.isEmpty) {
          filteredProducts = products;
        } else {
          filteredProducts = products.where(
            (product) {
              final name = product['name'].toString().toLowerCase();
              final searchLower = query.toLowerCase();
              return name.contains(searchLower);
            },
          ).toList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            AppbarSliver(
              onSearch: (text) {
                searchProducts(text);
              },
              cartCount: '$cartCount',
            ),
            buildSlider(),
            buildProductType(),
            Buildcontainer(context: context),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scrnWidth * .05,
                  vertical: context.scrnHeight * .01,
                ),
                child: Text(
                  'All Products',
                  style: titleStyle,
                ),
              ),
            ),
            buildAllProducts(),
          ],
        ),
      ),
    );
  }

  Widget buildSlider() {
    return SliverAppBar(
      floating: false, //
      expandedHeight: context.scrnHeight * .25,
      flexibleSpace: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    autoPlay: true,
                    height: 400.0,
                    viewportFraction: 1,
                  ),
                  items: [0, 1, 2, 3, 4].map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            width: double.infinity,
                            slidesCarousel[i],
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const BuildPlaceHolder();
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const BuildPlaceHolder();
                            },
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
                // Positioned(
                //   left: 0,
                //   top: 0,
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: context.scrnWidth * .035,
                //     ),
                //     child: Row(
                //       children: [
                //         AnimSearchBar(
                //           animationDurationInMilli: 777,
                //           width: context.scrnWidth * .9,
                //           helpText: "Search Product",
                //           prefixIcon: const Icon(Icons.search_rounded),
                //           suffixIcon: const Icon(Icons.close),
                //           textController: textController,
                //           boxShadow: true,
                //           autoFocus: true,
                //           onSuffixTap: () {
                //             setState(() {
                //               textController.clear();
                //             });
                //           },
                //           onSubmitted: (String value) {
                //             searchProducts(value);
                //           },
                //         ),
                //         SizedBox(width: context.scrnWidth * .69),
                //         const CircleAvatar(
                //           radius: 25,
                //           backgroundColor: Colors.white,
                //           child: Icon(
                //             Icons.notifications,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Positioned(
                  bottom: 10,
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: slidesCarousel.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      activeDotColor: Color(0xFFF67FAC),
                      dotColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductType() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.scrnHeight * .01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.scrnWidth * .05,
              ),
              child: Text(
                'Product Type',
                style: titleStyle,
              ),
            ),
            Container(
              color: Colors.white,
              height: context.scrnHeight * .125,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scrnWidth * .05,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productType.length,
                  itemBuilder: (context, index) {
                    var productT = ProductTypeModel.fromJson(
                      productType[index],
                    );
                    return Padding(
                      padding: EdgeInsets.only(
                        top: context.scrnHeight * .01,
                        right: context.scrnWidth * .05,
                      ),
                      child: Column(
                        children: [
                          Bounceable(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.productType,
                                arguments: [
                                  products
                                      .where((pro) =>
                                          pro['product_type'].toLowerCase() ==
                                          productT.tag.toLowerCase())
                                      .toList(),
                                  productT.title,
                                ],
                              );
                            },
                            child: SizedBox(
                              height: 75,
                              width: 60,
                              child: SvgPicture.network(
                                  fit: BoxFit.contain,
                                  productT.image,
                                  placeholderBuilder: (context) =>
                                      const BuildPlaceHolder()),
                            ),
                          ),
                          Text(
                            productT.title,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAllProducts() {
    return SliverGrid.builder(
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.scrnWidth * .04,
        mainAxisSpacing: context.scrnWidth * .05,
        mainAxisExtent: context.scrnHeight * .3,
      ),
      itemBuilder: (context, index) {
        var product = ProductModel.fromJson(filteredProducts[index]);
        return Bounceable(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              Routes.productDetails,
              arguments: product,
            ).then((onValue) {
              setState(() {
                _updateCartCount();
              });
            });
          },
          child: Card(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: product.name,
                    child: Image.network(
                      height: context.scrnHeight * .2,
                      product.images,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const BuildPlaceHolder();
                      },
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scrnWidth * .02,
                  ),
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scrnWidth * .02,
                  ),
                  child: Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scrnWidth * .02,
                  ),
                  child: Text(
                    '\$${double.tryParse(product.price)?.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
