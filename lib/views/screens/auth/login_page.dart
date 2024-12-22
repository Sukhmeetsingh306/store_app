import 'package:flutter/material.dart';

import '../../../components/color/color_theme.dart';
import '../../../components/googleFonts.dart';

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
              Image.asset(
                'assets/images/mail-p.png',
                width: 300,
                height: 300,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: ColorTheme.color.whiteColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide:
                          BorderSide(color: ColorTheme.color.lustRedColor),
                    ),
                    labelText: 'Email',
                    //focusedBorder: InputBorder.none,
                    //enabledBorder: InputBorder.none,
                    labelStyle: googleFonts(
                      fontFamily: 'Nunito Sans',
                      fontSize: 14,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
