import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/components/text/textFormField.dart';
import 'package:store_app/models/navigate_models.dart';
import 'package:store_app/views/screens/auth/login_page.dart';

import '../../../components/text/googleFonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                googleText('Create Your Account'),
                googleText(
                  'To Explore the World Model',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                SvgPicture.asset(
                  'assets/images/register.svg',
                  width: 300,
                  height: 300,
                ),
                SizedBox(
                  height: 10,
                ),
                textFormField(
                  "Username",
                  'assets/icons/name.png',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username is required";
                    } else if (value.length < 3) {
                      return "Username should be at least 3 characters long";
                    } else {
                      return null;
                    }
                  },
                ),
                textFormField(
                  "Email",
                  'assets/icons/email.png',
                  validator: (value) {
                    final regex = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                    if (!regex.hasMatch(value!)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
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
                      onPressed: () {
                        pushAndRemoveUntil(
                          context,
                          LoginPage(),
                        );
                      },
                      child: googleText(
                        'Log In',
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
      ),
    );
  }
}
