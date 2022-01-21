import 'package:dont_forget/providers/auth.dart';
import 'package:dont_forget/widgets/otp_widget.dart';
import 'package:dont_forget/widgets/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneAuth = Provider.of<Auth>(context);
    final GlobalKey<FormState> _formKey = GlobalKey();
    return SingleChildScrollView(
      child: phoneAuth.getAuthMode == AuthMode.enterPhoneNumber
          ? PhoneNumberWidget(
              formKey: _formKey,
            )
          : OtpWidget(
              formKey: _formKey,
            ),
    );
  }
}
