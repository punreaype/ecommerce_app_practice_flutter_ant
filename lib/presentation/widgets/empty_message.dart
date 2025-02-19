import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:practice_7/constant/textstyle.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';

class EmptyMessage extends StatelessWidget {
  final String lottieAssets;
  final String message;
  final String textContent;

  const EmptyMessage({
    super.key,
    required this.lottieAssets,
    required this.message,
    required this.textContent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.scrnHeight * .8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            lottieAssets,
            repeat: false,
            height: context.scrnHeight * .3,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scrnWidth * 0.2,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.navBar,
                  (route) => false,
                );
              },
              style: eleBttnStyle(context),
              child: Text(
                textContent,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
