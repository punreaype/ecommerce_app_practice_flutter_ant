import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:practice_7/constant/textstyle.dart';
import 'package:practice_7/model/invoice_model.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/invoice_helper.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Invoice order;
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String status = "";
  String orderId = "";
  bool isClick = false;

  @override
  void initState() {
    super.initState();
    status = widget.order.status;
    orderId = widget.order.invoiceID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.order.invoiceID,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildDetails(context),
          ),
          buildFooterOrderDetail(context),
        ],
      ),
    );
  }

// This is my widget
  Widget buildDetails(BuildContext context) {
    return CustomScrollView(
      slivers: [
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: OrderContainer(
            iconPath: 'assets/icons/Delivery Scooter.png',
            title: 'Delivery Location ',
            description: widget.order.address,
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
            child: OrderContainer(
          iconPath: 'assets/icons/Phone.png',
          title: 'Contact',
          description: widget.order.contactNumber,
        )),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: OrderContainer(
            iconPath: 'assets/icons/Cash in Hand.png',
            title: 'Payment',
            description: widget.order.paymentMethod,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              top: context.scrnHeight * .01,
            ),
            child: Column(
              children: List.generate(
                widget.order.products.length,
                (index) {
                  final product = widget.order.products[index];
                  return Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: context.scrnWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scrnWidth * .035,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: context.scrnHeight * .015,
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  product.images,
                                  width: context.scrnWidth * .25,
                                  height: context.scrnHeight * .12,
                                  fit: BoxFit.fitHeight,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                Container(
                                  height: context.scrnHeight * .1,
                                  width: context.scrnWidth * .45,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: context.scrnWidth * .1,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                          height: context.scrnHeight * .01),
                                      Text(
                                        '\$${double.parse(product.price).toStringAsFixed(2)}  x  ${product.quantity == 0 ? 1 : product.quantity}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index < widget.order.products.length - 1)
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scrnWidth * .035,
                              vertical: context.scrnHeight * .01,
                            ),
                            child: DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashLength: 5.0,
                              dashColor: Colors.grey.shade400,
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Buildcontainer(context: context),
        SliverToBoxAdapter(
          child: Container(
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
                        'Order Summary (${widget.order.products.length} item${widget.order.products.length > 1 ? 's' : ''})',
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
                              'Discount (${(widget.order.discount / widget.order.subtotal * 100).toStringAsFixed(2)} % )',
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
                              'US \$${widget.order.subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade600,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                decoration: widget.order.discount != 0
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              widget.order.discount == 0
                                  ? '.....................'
                                  : 'US \$${widget.order.discount.toStringAsFixed(2)}',
                              style: tsOrderSummar,
                            ),
                          ),
                          SizedBox(
                            height: context.scrnHeight * .03,
                            child: Text(
                              'US \$${widget.order.total.toStringAsFixed(2)}',
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
      ],
    );
  }

  Widget buildFooterOrderDetail(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
              child: Container(
                height: context.scrnHeight * .05,
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isClick
                          ? "Completed".toUpperCase()
                          : status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: status != "Processing"
                            ? Colors.blue
                            : Colors.yellow.shade700,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a, dd MMM yyyy')
                          .format(widget.order.timestamp)
                          .toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 15,
                        color: Colors.grey,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Bounceable(
                onTap: () async {
                  bool isSuccess = false;
                  bool confirm = await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'You want to mark this order as received?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Colors.green,
                    onCancelBtnTap: () {
                      Navigator.pop(context, false);
                    },
                    onConfirmBtnTap: () {
                      Navigator.pop(context, true);
                      isSuccess = true;
                      if (isSuccess) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Order marked as received!',
                        );
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: 'Failed to mark order as received.',
                        );
                      }
                    },
                  );
                  if (confirm == true) {
                    InvoiceHelper invoiceHelper = InvoiceHelper();
                    await invoiceHelper.updateInvoiceStatus(
                      widget.order.invoiceID,
                      'completed',
                    );
                    setState(() {
                      status = 'completed';
                      isClick = true;
                    });
                  }
                },
                child: Container(
                  height: context.scrnHeight * .05,
                  decoration: BoxDecoration(
                    color: isClick || status != "Processing"
                        ? Colors.lightBlue
                        : Colors.white,
                    border: Border.all(
                      width: 2,
                      color: isClick || status != "Processing"
                          ? Colors.lightBlue.shade100
                          : Colors.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isClick || status != "Processing"
                          ? "RECEIVED"
                          : "MARK AS RECEIVED",
                      style: TextStyle(
                        color: isClick || status != "Processing"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
