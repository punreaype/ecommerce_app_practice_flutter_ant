import 'package:flutter/material.dart';
import 'package:practice_7/utils/extension.dart';

class Buildcontainer extends StatelessWidget {
  const Buildcontainer({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.grey.shade100,
        height: context.scrnHeight * .01,
      ),
    );
  }
}
