import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:practice_7/constant/textstyle.dart';
import 'package:practice_7/data/datasources/coupons_code.dart';
import 'package:practice_7/model/invoice_model.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/presentation/widgets/order_success.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';
import 'package:practice_7/utils/file_add_to_cart_helper.dart';
import 'package:practice_7/utils/invoice_helper.dart';
import 'package:practice_7/utils/validator/validator.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

final globalKeyFom = GlobalKey<FormState>();

class _OrdersState extends State<Orders> {
  var getAddress = 'Enter your address';
  var getContactNumber = 'Enter your contact number';
  late List<ProductModel> products;
  bool isSingleProduct = true;
  String? couponCode;
  double discount = 0.0;
  var invoiceID = "";
  var paymentMethod = "Select a payment method";

  var isclick = false;

  void loading() async {
    setState(() {
      isclick = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    setState(() {
      isclick = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final args = data[0];
    invoiceID = data[1];

    if (args is ProductModel) {
      products = [args];
      isSingleProduct = true;
    } else if (args is List<ProductModel>) {
      products = args;
      isSingleProduct = false;
    } else {
      throw ArgumentError(
        'Expected either a ProductModel or List<ProductModel>',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(invoiceID),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildOrders(
              context,
              products,
            ),
          ),
          buildPlaceOrder(context, products),
        ],
      ),
    );
  }

  Widget buildOrders(BuildContext context, List<ProductModel> products) {
    double subtotal = products.fold(
      0.0,
      (sum, product) =>
          sum +
          (double.parse(product.price) *
              (product.quantity == 0 ? 1 : product.quantity)),
    );
    double total = subtotal - discount;

    return CustomScrollView(
      slivers: [
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () => pushdeliveryLocation(context),
            child: OrderContainer(
              iconPath: 'assets/icons/Delivery Scooter.png',
              title: 'Delivery Location ',
              description: getAddress,
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {
              _showContactDialog(context);
            },
            child: OrderContainer(
              iconPath: 'assets/icons/Phone.png',
              title: 'Contact',
              description: getContactNumber,
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () async {
              var resultPayment = await Navigator.pushNamed(
                context,
                Routes.paymentscreen,
              );

              if (resultPayment is String) {
                setState(() {
                  paymentMethod = resultPayment;
                });
              }
            },
            child: OrderContainer(
              iconPath: 'assets/icons/Cash in Hand.png',
              title: 'Payment',
              description: paymentMethod,
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              top: context.scrnHeight * .01,
            ),
            child: Column(
              children: products.map((product) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scrnWidth * .035,
                  ),
                  color: Colors.white,
                  height: context.scrnHeight * .15,
                  margin: EdgeInsets.only(
                    bottom: context.scrnHeight * .01,
                  ),
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
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: context.scrnHeight * .01,
                            ),
                            Text(
                              "Price: \$${double.parse(product.price).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (product.productColors.isNotEmpty)
                              Text(
                                'Colors: ${product.productColors[0].colorName}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
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
                            const Spacer(),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => decrementQty(product),
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
                                        product.quantity == 0
                                            ? "1"
                                            : product.quantity.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => incrementQty(product),
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
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {
              _showCouponDialog(context);
            },
            child: OrderContainer(
              iconPath: 'assets/icons/Voucher.png',
              title: 'Coupon',
              description: couponCode != null
                  ? 'Applied: $couponCode'
                  : 'Enter to get discount',
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scrnWidth * .05,
                vertical: context.scrnHeight * .005,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/Purchase Order.png',
                        height: context.scrnHeight * .03,
                        width: context.scrnWidth * .06,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(width: context.scrnWidth * .03),
                      Text(
                        'Order Summary (${products.length} item${products.length > 1 ? 's' : ''})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              'Subtotal',
                              style: tsOrderSummar,
                            ),
                          ),
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              'Discount (${(discount / subtotal * 100).toStringAsFixed(2)}%)',
                              style: tsOrderSummar,
                            ),
                          ),
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              'Total',
                              style: tsTotal,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              'US \$${subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade600,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                decoration: discount == 0.0
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              discount == 0.0
                                  ? '....................'
                                  : 'US \$${discount.toStringAsFixed(2)}',
                              style: tsOrderSummar,
                            ),
                          ),
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              'US \$${total.toStringAsFixed(2)}',
                              style: tsTotal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.grey.shade100,
            height: context.scrnHeight * .17,
          ),
        )
      ],
    );
  }

  Widget buildPlaceOrder(BuildContext context, List<ProductModel> products) {
    double subtotal = products.fold(
      0.0,
      (sum, product) =>
          sum +
          (double.parse(product.price) *
              (product.quantity == 0 ? 1 : product.quantity)),
    );
    double total = subtotal - discount;

    return Container(
      color: Colors.white,
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
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: context.scrnHeight * .05,
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        total == 0.0
                            ? 'Free'
                            : 'US \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            SizedBox(
              width: context.scrnWidth * .05,
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  // Validate required fields
                  if (getAddress == "Enter your address" &&
                      getContactNumber == "Enter your contact number" &&
                      paymentMethod == "Select a payment method") {
                    Flushbar(
                      message:
                          "Please fill in the required fields to place an order",
                      icon: const Icon(
                        Icons.info_outline,
                        size: 28.0,
                        color: Colors.white,
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      borderRadius: BorderRadius.circular(8),
                      margin: const EdgeInsets.all(8),
                      duration: const Duration(
                        seconds: 3,
                      ),
                      leftBarIndicatorColor: Colors.pinkAccent,
                      backgroundColor: const Color.fromARGB(255, 234, 0, 0),
                    ).show(context);
                    loading();

                    return;
                  }

                  // Create an invoice object
                  final invoice = Invoice(
                    invoiceID: invoiceID,
                    address: getAddress,
                    contactNumber: getContactNumber,
                    paymentMethod: paymentMethod,
                    products: products,
                    subtotal: subtotal,
                    discount: discount,
                    total: total,
                    timestamp: DateTime.now(),
                  );

                  try {
                    final dbHelper = InvoiceHelper();
                    await dbHelper.insertInvoice(invoice);

                    loading();

                    for (var pro in products) {
                      AddToCart.removeFromCart(
                        pro,
                        pro.selectedColor,
                      );
                    }
                    loading();
                    showSuccessDialog(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to place order: $e',
                        ),
                      ),
                    );
                    loading();
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
                    child: isclick
                        ? const LoadingIndicator(
                            indicatorType: Indicator.lineScale,
                            colors: [Colors.white],
                            strokeWidth: 2,
                            backgroundColor: Colors.black,
                          )
                        : const Text(
                            "PLACE ORDER",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            //
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.zero,
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: context.scrnWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                    key: globalKeyFom,
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Enter Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      validateMobile(value!);
                      return null;
                    }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    String contactNumber = controller.text;
                    setState(
                      () {
                        getContactNumber = contactNumber;
                      },
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: context.scrnHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCouponDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.zero,
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: context.scrnWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Coupon Code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Coupon Code',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    String code = controller.text.trim().toUpperCase();
                    var coupon = coupons.firstWhere(
                      (c) => c["code"] == code,
                      orElse: () => {},
                    );

                    if (coupon.isNotEmpty) {
                      double subtotal = products.fold(
                        0.0,
                        (sum, product) =>
                            sum +
                            (double.parse(product.price) * product.quantity),
                      );
                      double discountValue = (coupon["value"] / 100) * subtotal;

                      setState(() {
                        couponCode = code;
                        discount = discountValue;
                      });

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Invalid coupon code'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0x62424242),
                          margin: EdgeInsets.only(
                            bottom: context.scrnHeight - 100,
                            left: context.scrnWidth * .05,
                            right: context.scrnWidth * .05,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: context.scrnHeight * 0.05,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: const Center(
                      child: Text(
                        "APPLY",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void incrementQty(ProductModel product) {
    setState(() {
      product.quantity += 1;
    });
  }

  void decrementQty(ProductModel product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity -= 1;
      }
    });
  }

  void pushdeliveryLocation(BuildContext context) async {
    var result = await Navigator.pushNamed(
      context,
      Routes.deliveryLocation,
    );
    if (result is String) {
      setState(
        () {
          getAddress = result;
        },
      );
    }
  }
}
