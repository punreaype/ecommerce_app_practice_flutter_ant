import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_7/utils/extension.dart';

TextStyle tsOrderSummar = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w300,
  color: Colors.grey.shade600,
  fontFamily: GoogleFonts.poppins().fontFamily,
);
TextStyle tsTotal = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  fontFamily: GoogleFonts.poppins().fontFamily,
);

TextStyle pfnameStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  fontFamily: GoogleFonts.poppins().fontFamily,
);

TextStyle pfdobStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w300,
  color: Colors.black,
  fontFamily: GoogleFonts.poppins().fontFamily,
);
TextStyle titleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: GoogleFonts.poppins().fontFamily,
);

ButtonStyle eleBttnStyle(BuildContext context) => ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      minimumSize: Size(
        double.infinity,
        context.scrnHeight * 0.055, // Added height
      ),
    );
