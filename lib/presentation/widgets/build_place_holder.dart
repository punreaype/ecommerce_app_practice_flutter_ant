import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildPlaceHolder extends StatelessWidget {
  const BuildPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0x939E9E9E),
      highlightColor: Colors.grey.shade300,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        // height: 64,
      ),
    );
  }
}
