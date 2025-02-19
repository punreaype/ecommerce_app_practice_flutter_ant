import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_7/utils/extension.dart';

class OrderContainer extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const OrderContainer({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scrnWidth * .05,
        vertical: context.scrnHeight * .005,
      ),
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Image.asset(
                height: context.scrnHeight * .03,
                width: context.scrnWidth * .06,
                iconPath,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          SizedBox(width: context.scrnWidth * .03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              SizedBox(
                width: context.scrnWidth * .75,
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
