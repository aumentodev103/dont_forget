// import 'package:dont_forget/providers/auth.dart';
import 'package:dont_forget/screens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:provider/provider.dart';
//
// import 'package:intl_phone_field/countries.dart';

enum AuthMode { enterPhoneNumber, enterOTP }

class LoginCard extends StatefulWidget {
  const LoginCard({Key? key}) : super(key: key);

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _otpController = TextEditingController();
  final Map<String, String> _authData = {
    'countryCode': "",
    'phoneNumber': '',
    'OTP': '',
  };

  AuthMode _authMode = AuthMode.enterPhoneNumber;

  bool phoneValid = false;
  // String? _verificationCode;

  // final _phoneNumberController = TextEditingController(text: "");

  //<-- Functions -->//

  void _enterOtp() async {
    debugPrint("Fetch phone number and fire phone auth..");

    if (phoneValid == false || _formKey.currentState!.validate() == false) {
      return;
    }
    debugPrint(_authData.toString());
    var completeNumber =
        "${_authData["countryCode"]}${_authData["phoneNumber"]}";
    debugPrint("Fetch $completeNumber and fire phone auth..");
    _formKey.currentState!.save();
    // try {
    //   await Provider.of<Auth>(context, listen: false)
    //       .registerUser(completeNumber, context);
    // } catch (error) {
    //   var errorMessage = "Network error, please try again later $error";
    //   _showErrorDialog(errorMessage);
    // }
    // _authData["phoneNumber"] = ;
    // setState(() {
    //   _authMode = AuthMode.enterOTP;
    // });
  }

  void _onGetOtp(Map<String, String> data) {
    _authData["phoneNumber"] = data["phoneNumber"].toString();
    _authData["countryCode"] = data["countryCode"].toString();
  }

  void _onTapDetector() {
    Navigator.pushNamed(context, UserDetailsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: _authMode == AuthMode.enterPhoneNumber
          ? Form(
              key: _formKey,
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
                    // controller: _phoneNumberController,
                    onChanged: (value) {
                      if ((value.number).trim().length < 10) {
                        phoneValid = false;
                        setState(() {});
                        // phoneValid = false;
                        return;
                      }
                      phoneValid = true;
                      setState(() {});
                      // Country country = countries.firstWhere((element) =>
                      //     "+${element.dialCode}" == phoneNumber.countryCode);
                      // if (phoneNumber.number.length == country.maxLength ||
                      //     phoneNumber.number.length > country.minLength &&
                      //         phoneNumber.number.length < country.maxLength) {
                      //   phoneValid = true;
                      //   print(phoneNumber.number);
                      // }
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _authData["phoneNumber"] = (value.number).toString();
                        _authData["countryCode"] =
                            (value.countryCode).toString();
                        // (value.countryCode).toString();
                      }
                    },
                    // validator: (value) {
                    //   print("validator $phoneValid $value ${value!.length}");
                    // },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8.0),
                      minimumSize: MaterialStateProperty.all(
                        const Size(78, 45),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return !states.contains(MaterialState.disabled)
                              ? Colors.redAccent
                              : Colors.grey;
                        },
                      ),
                      // backgroundColor: phoneValid
                      //     ? MaterialStateProperty.all(Colors.redAccent)
                      //     : MaterialStateProperty.all(Colors.grey),
                    ),
                    onPressed: phoneValid == false
                        ? null
                        : () {
                            setState(() {
                              _authMode = AuthMode.enterOTP;
                            });
                            _onGetOtp(_authData);
                          },
                    child: const Text(
                      "Get OTP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _onTapDetector,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              'assets/images/google.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _onTapDetector,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              'assets/images/facebook.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _onTapDetector,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              "assets/images/twitter.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Enter OTP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Didn't recieve OTP?",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          debugPrint(
                            "Resend Otp",
                          );
                        },
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8.0),
                      minimumSize: MaterialStateProperty.all(
                        const Size(255, 45),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                    ),
                    onPressed: () {
                      _enterOtp();
                    },
                    child: const Text(
                      "Verfiy",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8.0),
                      minimumSize: MaterialStateProperty.all(
                        const Size(255, 45),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Edit number",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
