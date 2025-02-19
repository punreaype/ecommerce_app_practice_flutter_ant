import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:practice_7/model/invoice_model.dart';
import 'package:practice_7/presentation/screens/cart/order_details_screen.dart';
import 'package:practice_7/presentation/widgets/empty_message.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/invoice_helper.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late Future<List<Invoice>> _invoicesFuture;

  @override
  void initState() {
    super.initState();
    _invoicesFuture = InvoiceHelper().getInvoices().then(
          (invoices) => invoices.reversed.toList(),
        );
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            var isReplace =
                (ModalRoute.of(context)?.settings.arguments ?? true) as bool;
            if (isReplace) {
              Navigator.pushReplacementNamed(
                context,
                '/navBar',
                arguments: true,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: FutureBuilder<List<Invoice>>(
        future: _invoicesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyMessage(
              lottieAssets: 'assets/lottie/NoOrder.json',
              message: 'You have no orders yet',
              textContent: 'Start Shopping',
            );
          } else {
            final invoices = snapshot.data!;
            return isLoading
                ? Center(
                    child: SizedBox(
                      width: context.scrnWidth * .25,
                      height: context.scrnHeight * .125,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          Colors.grey.shade400,
                          Colors.grey.shade500,
                          Colors.grey.shade600,
                          Colors.grey.shade700,
                          Colors.grey.shade800,
                          Colors.grey.shade900,
                        ],
                        strokeWidth: 1,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                              ) {
                                return OrderDetailsScreen(
                                  order: invoice,
                                );
                              },
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          ).then(
                            (_) {
                              setState(
                                () {
                                  _invoicesFuture =
                                      InvoiceHelper().getInvoices().then(
                                            (invoices) =>
                                                invoices.reversed.toList(),
                                          );
                                },
                              );
                            },
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      invoice.invoiceID,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${invoice.total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('hh:mm a, dd MMM yyyy')
                                          .format(
                                            invoice.timestamp,
                                          )
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      invoice.status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: invoice.status != 'Processing'
                                            ? Colors.blue
                                            : Colors.yellow.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: Colors.grey.shade400,
                                  dashRadius: 0.0,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapRadius: 0.0,
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: invoice.products.length,
                                    itemBuilder: (context, index) {
                                      final product = invoice.products[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Image.network(
                                          product.images,
                                          width: 60,
                                          height: 50,
                                          fit: BoxFit.fitHeight,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(Icons.error);
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: LoadingIndicator(
                                                indicatorType: Indicator.pacman,
                                                colors: [
                                                  Colors.grey.shade400,
                                                  Colors.grey.shade500,
                                                  Colors.grey.shade800,
                                                  Colors.grey.shade900,
                                                ],
                                                strokeWidth: 1,
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
