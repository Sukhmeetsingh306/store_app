import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/fonts/text_fonts_utils.dart';
import '../../../utils/routes/navigation_routes.dart';
import '../../../utils/validation/termsAndConditions_core.dart';
import '../../../utils/widget/animation/seller_widget_utils_animation.dart';
import '../../../utils/widget/form/appTextButton_form.dart';
import '../../../utils/widget/space_widget_utils.dart';

enum PaymentMethodType { upi, bank, wallet }

class SellerBankDetailScreen extends StatefulWidget {
  const SellerBankDetailScreen({super.key});

  static const String routeName = '/sellerBankDetailScreen';
  static const String routePath = '/sellerBankDetailScreen';

  @override
  State<SellerBankDetailScreen> createState() => _SellerBankDetailScreenState();
}

class _SellerBankDetailScreenState extends State<SellerBankDetailScreen>
    with TickerProviderStateMixin {
  PaymentMethodType? selectedType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _upiController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _walletNumberController = TextEditingController();

  late SellerWidgetUtilsAnimation _animationUtils;

  @override
  void initState() {
    _animationUtils = SellerWidgetUtilsAnimation(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _upiController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _walletNumberController.dispose();
    super.dispose();
  }

  void _submit() {
    if (selectedType == null) {
      _showSnackBar("Please select a payment method");
      return;
    }

    switch (selectedType!) {
      case PaymentMethodType.upi:
        if (_upiController.text.isEmpty) {
          _showSnackBar("Please enter your UPI ID");
          return;
        }
        print("Submitted UPI: ${_upiController.text}");
        break;

      case PaymentMethodType.bank:
        if (_accountNumberController.text.isEmpty ||
            _ifscController.text.isEmpty) {
          _showSnackBar("Please enter valid bank details");
          return;
        }
        print("Account No: ${_accountNumberController.text}");
        print("IFSC Code: ${_ifscController.text}");
        break;

      case PaymentMethodType.wallet:
        if (_walletNumberController.text.isEmpty) {
          _showSnackBar("Please enter wallet number");
          return;
        }
        print("Wallet Number: ${_walletNumberController.text}");
        break;
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildOptionButton(PaymentMethodType type, String label) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = isSelected ? null : type;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue.shade800 : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildUPIForm() {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      child: selectedType == PaymentMethodType.upi
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("UPI ID"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _upiController,
                  decoration: InputDecoration(
                    hintText: "example@upi",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildBankForm() {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      child: selectedType == PaymentMethodType.bank
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Account Number"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: InputDecoration(
                    hintText: "1234567890",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                Text("IFSC Code"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _ifscController,
                  decoration: InputDecoration(
                    hintText: "ABCD0123456",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildWalletForm() {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      child: selectedType == PaymentMethodType.wallet
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Wallet Number"),
                SizedBox(height: 8),
                TextFormField(
                  controller: _walletNumberController,
                  decoration: InputDecoration(
                    hintText: "Enter wallet number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  Widget _pageInnerCode(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            googleInterText(
              'Withdrawals Details',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
            sizedBoxH8(),
            googleInterText(
              'Select a withdrawal method and provide the necessary details.',
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.042,
        ),
        _buildOptionButton(PaymentMethodType.upi, "UPI"),
        _buildUPIForm(),
        _buildOptionButton(PaymentMethodType.bank, "Bank Account"),
        _buildBankForm(),
        _buildOptionButton(PaymentMethodType.wallet, "Wallet"),
        _buildWalletForm(),
      ],
    );
  }

  Widget buttonBottomCode(GlobalKey<FormState> formKey, BuildContext context) {
    return Column(
      children: [
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlide3,
          child: Column(
            children: [
              Center(child: TermsAndConditionsText()),
              sizedBoxH15(),
              AppTextButton(
                buttonText: 'Create Account',
                onPressed: () async {
                  context.push('/');
                  //if (_formKey.currentState!.validate()) {
                  // if (isSeller) {
                  //   Navigator.pushNamed(context, '/sellerPage');
                  // } else {
                  //   Navigator.pushReplacementNamed(context, '/loginPage');
                  // }
                  //}
                },
              ),
            ],
          ),
        ),
        sizedBoxH10(),
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlideScale2,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  if (Navigator.of(context).canPop()) {
                    pop(context);
                  } else {
                    context.go('/sellerPage');
                  }
                },
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        textSpan(
                          'Preview Details?',
                          fontSize: 14,
                        ),
                        textSpan(
                          ' Preview',
                          fontSize: 14,
                          color: const Color.fromRGBO(36, 124, 255, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              sizedBoxH5(),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }

  Widget pageCode(bool isLargeScreen) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isLargeScreen ? 500 : double.infinity,
      ),
      child: Container(
        height: isLargeScreen ? MediaQuery.of(context).size.height * 0.8 : null,
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 50 : 0,
          vertical: isLargeScreen ? 50 : 0,
        ),
        decoration: isLargeScreen
            ? BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(20), // Rounded edges
              )
            : null,
        child: isLargeScreen
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    _pageInnerCode(isLargeScreen),
                    SizedBox(height: 80),
                    buttonBottomCode(_formKey, context),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    child: _pageInnerCode(isLargeScreen),
                  ),
                  SizedBox(height: 115),
                  buttonBottomCode(_formKey, context),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth > 900;
        return isLargeScreen
            ? Stack(
                children: [
                  Image.asset(
                    'assets/images/img.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey); // fallback color
                    },
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Center(child: pageCode(isLargeScreen)),
                  ),
                ],
              )
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  child: SingleChildScrollView(
                    child: pageCode(isLargeScreen),
                  ),
                ),
              );
      }),
    );
  }
}
/**

 Widget buttonBottomCode(GlobalKey<FormState> formKey, BuildContext context) {
    return Column(
      children: [
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlide3,
          child: Column(
            children: [
              Center(child: TermsAndConditionsText()),
              sizedBoxH15(),
              AppTextButton(
                buttonText: 'Create Account',
                onPressed: () async {
                  context.push('/sellerBankDetailPage');
                  //if (_formKey.currentState!.validate()) {
                  // if (isSeller) {
                  //   Navigator.pushNamed(context, '/sellerPage');
                  // } else {
                  //   Navigator.pushReplacementNamed(context, '/loginPage');
                  // }
                  //}
                },
              ),
            ],
          ),
        ),
        sizedBoxH10(),
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlideScale2,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  if (Navigator.of(context).canPop()) {
                    pop(context);
                  } else {
                    context.go('/sellerPage');
                  }
                },
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        textSpan(
                          'Preview Details?',
                          fontSize: 14,
                        ),
                        textSpan(
                          ' Preview',
                          fontSize: 14,
                          color: const Color.fromRGBO(36, 124, 255, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              sizedBoxH5(),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }*/
