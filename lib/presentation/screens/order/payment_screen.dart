import 'package:flutter/material.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var payment = [
      "Cash on delivery",
      "Credit/Debit Card",
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Payment Method'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(
              context,
              payment[0],
            ),
            child: PaymentCard(
              imgassets: 'assets/icons/cash 1.png',
              title: payment[0],
              subtitle: 'Pay when you receive the order',
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(
              context,
              payment[1],
            ),
            child: PaymentCard(
              imgassets: 'assets/icons/debit/cash 1.png',
              title: payment[1],
              subtitle: 'VISA, MasterCard, UnionPay',
            ),
          ),
        ],
      ),
    );
  }
}
