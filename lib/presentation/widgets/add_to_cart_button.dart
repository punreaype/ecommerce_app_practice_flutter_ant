import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/file_add_to_cart_helper.dart';

class AddToCartButton extends StatefulWidget {
  final ProductModel product;
  final String selectedColor;
  final int quantity;

  const AddToCartButton({
    super.key,
    required this.product,
    required this.selectedColor,
    required this.quantity,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.success,
          direction: DismissDirection.down,
          label: 'Added to cart',
        );
        await AddToCart.addToCart(
          widget.product,
          widget.selectedColor,
          widget.quantity,
        );
      },
      child: Container(
        height: context.scrnHeight * .05,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: const Center(
          child: Text(
            "Add to Cart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
