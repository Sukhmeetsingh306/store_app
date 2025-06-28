import 'package:flutter/material.dart';

class SellerBankDetailScreen extends StatefulWidget {
  const SellerBankDetailScreen({super.key});

  static const String routeName = '/sellerBankDetailScreen';
  static const String routePath = '/sellerBankDetailScreen';

  @override
  State<SellerBankDetailScreen> createState() => _SellerBankDetailScreenState();
}

class _SellerBankDetailScreenState extends State<SellerBankDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Details'),
      ),
      body: Center(
        child: Text(
          'Bank details will be displayed here.',
        ),
      ),
    );
  }
}
