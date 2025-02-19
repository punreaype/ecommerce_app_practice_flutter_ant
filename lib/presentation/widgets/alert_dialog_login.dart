import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:practice_7/utils/extension.dart';

class AnimatedAlertDialog extends StatefulWidget {
  const AnimatedAlertDialog({super.key});

  @override
  _AnimatedAlertDialogState createState() => _AnimatedAlertDialogState();
}

class _AnimatedAlertDialogState extends State<AnimatedAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Lottie.asset(
              'assets/lottie/incorrect.json',
              height: context.scrnHeight * 0.08,
              width: context.scrnWidth * 0.2,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(width: 10),
            const Text('Login Failed'),
          ],
        ),
        content: const Text(
          'Invalid username or password. Please try again.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: Size(
                double.infinity,
                context.scrnHeight * 0.055, // Added height
              ), // Added width
            ),
            onPressed: () {
              _controller.reverse().then((_) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
