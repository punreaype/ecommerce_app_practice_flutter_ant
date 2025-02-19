import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/presentation/widgets/empty_message.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/file_add_to_cart_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _offsetAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadCartItems();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlaceOrderVisibility() {
    if (selectedIcons.isNotEmpty) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  List<ProductModel> cartItems = [];
  List<int> selectedIcons = [];
  double totalPrice = 0.0;
  int badges = 0;
  void _loadCartItems() async {
    var cart = await AddToCart.readModelsFromFile();

    setState(() {
      cartItems = cart.reversed.toList();
    });
  }

  void _selectAllItems() {
    setState(() {
      if (selectedIcons.length == cartItems.length) {
        selectedIcons.clear();
      } else {
        selectedIcons = List.generate(
          cartItems.length,
          (index) => index,
        );
      }
      totalPrice = cartItems.fold(
        0.0,
        (sum, item) {
          if (selectedIcons.contains(cartItems.indexOf(item))) {
            return sum + (double.tryParse(item.price) ?? 0) * item.quantity;
          }
          return sum;
        },
      );
    });
  }

  void updateQty(int index, int qty) {
    setState(() {
      cartItems[index].quantity = qty;
    });
  }

  Widget buildList(BuildContext context) {
    if (cartItems.isEmpty) {
      return Center(
        child: EmptyMessage(
          lottieAssets: 'assets/lottie/Animation - 1734670774929.json',
          message: 'No Item In Cart',
          textContent: 'Order Now'.toUpperCase(),
        ),
      );
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final product = cartItems[index];
        return buildProductItem(
          context,
          product,
          index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _togglePlaceOrderVisibility();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        centerTitle: true,
        actions: [
          if (selectedIcons.isEmpty)
            Padding(
              padding: EdgeInsets.only(
                right: context.scrnWidth * 0.02,
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/svg/trash.svg',
                  width: context.scrnWidth * .06,
                ),
                onPressed: () async {},
              ),
            ),
          if (selectedIcons.isNotEmpty)
            GestureDetector(
              onTap: _selectAllItems,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: context.scrnWidth * 0.02,
                    ),
                    child: Text(
                      selectedIcons.length == cartItems.length
                          ? "Deselect All"
                          : "Select All",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: context.scrnWidth * 0.02,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        selectedIcons.length == cartItems.length
                            ? 'assets/svg/Group 67-2.svg'
                            : 'assets/svg/Group 67.svg',
                        width: context.scrnWidth * .06,
                      ),
                      onPressed: _selectAllItems,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: buildList(context),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            height: selectedIcons.isNotEmpty ? context.scrnHeight * .08 : 0,
            child: SlideTransition(
              position: _offsetAnimation,
              child: buildPlaceOrder(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductItem(
    BuildContext context,
    ProductModel product,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productDetails,
          arguments: product,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: context.scrnHeight * .01,
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: context.scrnWidth * .035,
          ),
          child: Dismissible(
            key: ValueKey(
              product.name,
            ), // Use a unique key for each item
            direction:
                DismissDirection.endToStart, // Slide only from right to left
            background: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onDismissed: (direction) async {
              var itemToRemove = cartItems[index];
              setState(() {
                cartItems.removeAt(index);
                selectedIcons.clear();
                totalPrice = cartItems.fold(
                  0.0,
                  (sum, item) =>
                      sum + (double.tryParse(item.price) ?? 0) * item.quantity,
                );
              });
              await AddToCart.removeFromCart(
                itemToRemove,
                itemToRemove.selectedColor,
              );
            },
            child: SizedBox(
              height: context.scrnHeight * .15,
              child: Row(
                children: [
                  SizedBox(
                    height: context.scrnHeight,
                    width: context.scrnWidth * .3,
                    child: Image.network(
                      product.images,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(width: context.scrnWidth * .01),
                  Container(
                    margin: EdgeInsets.only(
                      top: context.scrnHeight * .01,
                      bottom: context.scrnHeight * .01,
                    ),
                    width: context.scrnWidth * .36,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        SizedBox(
                          height: context.scrnHeight * .01,
                        ),
                        Text(
                          "Price: \$${double.tryParse(product.price)?.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        if (product.productColors.isNotEmpty &&
                            index < product.productColors.length)
                          Text(
                            'Colors: ${product.selectedColor}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      right: context.scrnWidth * .01,
                      top: context.scrnHeight * .01,
                      bottom: context.scrnHeight * .01,
                    ),
                    width: context.scrnWidth * .25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Bounceable(
                          onTap: () {
                            setState(() {
                              if (selectedIcons.contains(index)) {
                                selectedIcons.remove(index);
                              } else {
                                selectedIcons.add(index);
                              }
                              totalPrice = cartItems.fold(
                                0.0,
                                (sum, item) {
                                  if (selectedIcons
                                      .contains(cartItems.indexOf(item))) {
                                    return sum +
                                        (double.tryParse(item.price) ?? 0) *
                                            (item.quantity);
                                  }
                                  return sum;
                                },
                              );
                            });
                          },
                          child: SvgPicture.asset(
                            selectedIcons.contains(index)
                                ? 'assets/svg/Group 67-2.svg'
                                : 'assets/svg/Group 67.svg',
                            width: context.scrnWidth * .06,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (cartItems[index].quantity > 1) {
                                    updateQty(
                                      index,
                                      cartItems[index].quantity - 1,
                                    ); // Decrement quantity
                                  }
                                  AddToCart.updateQuantity(
                                    cartItems[index],
                                    cartItems[index].selectedColor,
                                    cartItems[index].quantity,
                                  );
                                },
                                child: Container(
                                  width: context.scrnWidth * .076,
                                  height: context.scrnHeight * .035,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                  ),
                                ),
                              ),
                              Container(
                                width: context.scrnWidth * .076,
                                height: context.scrnHeight * .035,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    product.quantity.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  updateQty(
                                    index,
                                    cartItems[index].quantity + 1,
                                  ); // Increment quantity
                                  AddToCart.updateQuantity(
                                    cartItems[index],
                                    cartItems[index].selectedColor,
                                    cartItems[index].quantity,
                                  );
                                },
                                child: Container(
                                  width: context.scrnWidth * .076,
                                  height: context.scrnHeight * .035,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlaceOrder(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.scrnHeight * .015,
          horizontal: context.scrnWidth * .035,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      selectedIcons.isEmpty
                          ? "USD \$0.0"
                          : "USD \$${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                  if (selectedIcons.isNotEmpty)
                    Expanded(
                      child: Text(
                        "${selectedIcons.length} item${selectedIcons.length > 1 ? 's' : ''} selected",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Text(
                        "${cartItems.length} item${cartItems.length > 1 ? 's' : ''}",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: context.scrnWidth * .05,
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  String invoiceID =
                      '#${DateTime.now().millisecondsSinceEpoch}';
                  if (selectedIcons.isNotEmpty) {
                    var selectedItems =
                        selectedIcons.map((index) => cartItems[index]).toList();
                    Navigator.pushNamed(
                      context,
                      Routes.orders,
                      arguments: [
                        selectedItems,
                        invoiceID,
                      ],
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select items to checkout'),
                      ),
                    );
                  }
                },
                child: Container(
                  height: context.scrnHeight * .05,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "checkout".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
