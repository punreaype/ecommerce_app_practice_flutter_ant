import 'package:flutter/material.dart';

extension Extension on BuildContext {
  double get scrnWidth => MediaQuery.sizeOf(this).width;
  double get scrnHeight => MediaQuery.sizeOf(this).height;
}
