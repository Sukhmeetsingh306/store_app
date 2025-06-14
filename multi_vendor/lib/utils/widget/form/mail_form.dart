import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../fonts/google_fonts_utils.dart';
import '../space_widget_utils.dart';
import 'appTextButton_form.dart';
import 'textForm_form.dart';

class MailForm extends StatefulWidget {
  const MailForm({
    super.key,
    required this.mailController,
    required this.isLargeScreen,
    required this.hasError,
    required this.otpMailController,
    this.name,
  });

  final TextEditingController mailController;
  final TextEditingController otpMailController;

  final bool isLargeScreen;
  final bool hasError;

  final String? name;

  @override
  State<MailForm> createState() => _MailFormState();
}

class _MailFormState extends State<MailForm> {
  bool otpMailSent = false;

  final List<String> mailDomains = [
    'gmail.com',
    'yahoo.com',
    'icloud.com',
    'outlook.com',
  ];
  String selectedDomain = 'gmail.com';

  void _updateEmail() {
    String mail = widget.mailController.text.split('@')[0];
    widget.mailController.text = '$mail@$selectedDomain';
    widget.mailController.selection = TextSelection.fromPosition(
      TextPosition(offset: mail.length),
    );
  }

  void _sendmailOTP() {
    if (widget.mailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid mail')),
      );
      return;
    }

    setState(() {
      otpMailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textFormField(
          widget.mailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          ' ${widget.name} mail',
          hintText: 'Eg: abc@gmail.com',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mail';
            } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                .hasMatch(value)) {
              return 'Please enter a valid mail';
            }
            return null;
          },
          suffixIcon: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDomain,
              alignment: Alignment.centerRight,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedDomain = newValue;
                    _updateEmail();
                  });
                }
              },
              items: mailDomains.map<DropdownMenuItem<String>>((String domain) {
                return DropdownMenuItem<String>(
                  value: domain,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "@$domain",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ), // Smaller dropdown icon
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          autofillHints: [AutofillHints.email],
          onChanged: (value) {
            _updateEmail();
          },
        ),
        sizedBoxH15(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // important!
          children: [
            Expanded(
              child: Column(
                children: [
                  textFormField(
                    widget.otpMailController,
                    hintText: 'Eg: 12345',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    '${widget.name} mail OTP',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid OTP';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              children: [
                widget.isLargeScreen
                    ? SizedBox(height: widget.hasError ? 8 : 2)
                    : SizedBox(height: widget.hasError ? 14 : 8),
                AppTextButton(
                  onPressed: _sendmailOTP,
                  buttonText: 'OTP',
                  buttonWidth: 75,
                  buttonHeight: 45,
                  horizontalPadding: 0,
                  verticalPadding: 0,
                ),
              ],
            ),
          ],
        ),
        if (otpMailSent)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: googleInterText(
              'OTP has been sent to your mail',
              fontSize: 10,
            ),
          ),
      ],
    );
  }
}
