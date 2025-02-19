import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:badges/badges.dart' as badges;

class AppbarSliver extends StatefulWidget {
  final Function(String) onSearch;
  final String cartCount;

  const AppbarSliver({
    super.key,
    required this.onSearch,
    required this.cartCount,
  });

  @override
  State<AppbarSliver> createState() => _AppbarSliverState();
}

class _AppbarSliverState extends State<AppbarSliver> {
  List<ProductModel> cartItems = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: false,
      leadingWidth: context.scrnWidth * 0.21,
      leading: Padding(
        padding: EdgeInsets.only(
          left: context.scrnWidth * 0.04,
        ),
        child: Row(
          children: [
            Text(
              'R S',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.pacifico().fontFamily,
              ),
            ),
            SizedBox(
              width: context.scrnWidth * .03,
            ),
            SizedBox(
              height: context.scrnHeight * 0.025,
              child: const VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      title: SizedBox(
        width: context.scrnWidth * 0.5,
        child: TextField(
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search anything you like',
            hintStyle: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: Colors.grey,
            ),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: context.scrnWidth * 0.04,
          ),
          child: badges.Badge(
            badgeContent: Text(
              widget.cartCount,
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
    );
  }
}
