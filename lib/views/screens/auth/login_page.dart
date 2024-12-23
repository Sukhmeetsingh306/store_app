import 'package:flutter/material.dart';
import 'package:store_app/components/text/textFormField.dart';

import '../../../components/text/googleFonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

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
              googleText('Login Your Account'),
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
              textFormField(
                "Email",
                'assets/icons/email.png',
              ),
              textFormField(
                "Password",
                'assets/icons/password.png',
                obscureText: _obscureText,
                passObscureText: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle visibility
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(144, 213, 255, 7),
                ),
                child: googleText(
                  'Sign Up',
                  fontWeight: FontWeight.w400,
                  fontSize: 21,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  googleText(
                    'Already has an account?',
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: googleText(
                      'Sign In',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
