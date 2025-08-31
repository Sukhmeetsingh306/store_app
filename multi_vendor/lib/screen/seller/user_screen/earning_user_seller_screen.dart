import 'package:flutter/material.dart';

class EarningUserSellerScreen extends StatelessWidget {
  static const String routeName = '/seller/earningSellerScreen';
  const EarningUserSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Earnings Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
