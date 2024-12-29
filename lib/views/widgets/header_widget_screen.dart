import 'package:flutter/material.dart';

class HeaderWidgetScreen extends StatelessWidget {
  const HeaderWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Stack(
        children: [
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.02,
          // ),
          Image.asset(
            'assets/images/arrow.png',
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
