import 'package:flutter/material.dart';
import 'package:practice_7/utils/extension.dart';

class PaymentCard extends StatelessWidget {
  final String imgassets;
  final String title;
  final String subtitle;
  const PaymentCard({
    super.key,
    required this.imgassets,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scrnWidth * 0.02,
        right: context.scrnWidth * 0.02,
        top: context.scrnWidth * 0.03,
      ),
      child: Container(
        color: Colors.white,
        height: context.scrnWidth * 0.15,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: context.scrnWidth * 0.05,
              ),
              child: Image.asset(
                imgassets,
                width: context.scrnWidth * 0.15,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: context.scrnWidth * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
