import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pencil.jpg'),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              googleText('Create Your Own Account'),
              googleText(
                'To Explore the World Model',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Text googleText(String text, {double? fontSize, FontWeight? fontWeight}) {
  return Text(
    text,
    style: GoogleFonts.getFont(
      'Lato',
      color: Colors.black,
      fontWeight: fontWeight ?? FontWeight.bold,
      letterSpacing: 0.2,
      fontSize: fontSize ?? 23, // Defaults to 23 if fontSize is null
    ),
  );
}
