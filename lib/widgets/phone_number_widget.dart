import 'package:dont_forget/providers/auth.dart';
import 'package:dont_forget/widgets/social_icons_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class PhoneNumberWidget extends StatefulWidget {
  final GlobalKey formKey;
  const PhoneNumberWidget({Key? key, required this.formKey}) : super(key: key);

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  final Widget elementSpacer = const SizedBox(
    height: 25,
  );

  final Widget authSeparator = Row(
    children: const <Widget>[
      Expanded(
        child: Divider(
          endIndent: 15,
          thickness: 2,
        ),
      ),
      Text(
        "OR",
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
      ),
      Expanded(
        child: Divider(
          indent: 15,
          thickness: 2,
        ),
      ),
    ],
  );

  final Map<String, String> authData = {
    "phoneNumber": "",
    "verificationId": '',
  };
  String? phoneNumber;
  bool isNumberValid = false;
  @override
  Widget build(BuildContext context) {
    final phoneAuth = Provider.of<Auth>(context, listen: false);
    //final isNumberValid = Provider.of<Auth>(context).isNumberValid;
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          IntlPhoneField(
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            initialCountryCode: 'IN',
            onChanged: (inputValue) {
              if ((inputValue.number).trim().length < 10) {
                isNumberValid = false;
                setState(() {});
                phoneAuth.changeNumberValidation(false);
                return;
              }
              isNumberValid = true;
              String phoneNumber = inputValue.countryCode + inputValue.number;
              authData["phoneNumber"] = phoneNumber;
              phoneAuth.changeNumberValidation(true);
              setState(() {});
            },
            onSaved: (value) {
              if (value != null) {
                String phoneNumber = value.countryCode + value.number;
                authData["phoneNumber"] = phoneNumber;
                phoneAuth.onInputChange(phoneNumber);
              }
            },
          ),
          elementSpacer,
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(8.0),
              minimumSize: MaterialStateProperty.all(
                const Size(80, 45),
              ),
              backgroundColor: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) =>
                    !states.contains(MaterialState.disabled)
                        ? Colors.redAccent
                        : Colors.grey,
              ),
            ),
            onPressed: isNumberValid
                ? () {
                    debugPrint("On Pressed Data is $authData");
                    phoneAuth.onLogin(authData["phoneNumber"] as String);
                  }
                : null,
            child: const Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          elementSpacer,
          authSeparator,
          elementSpacer,
          const SocialIconsWidget(),
        ],
      ),
    );
  }
}
