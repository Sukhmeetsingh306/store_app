import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EarningUserSellerScreen extends StatelessWidget {
  static const String routeName = '/seller/earningSellerScreen';
  const EarningUserSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Earnings Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  context.go('/loginPage');
                },
                child: Text('Go Back')),
          ],
        ),
      ),
    );
  }
}
