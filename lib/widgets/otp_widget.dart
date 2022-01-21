import 'package:dont_forget/screens/user_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dont_forget/providers/auth.dart';

class OtpWidget extends StatefulWidget {
  final GlobalKey formKey;
  const OtpWidget({Key? key, required this.formKey}) : super(key: key);

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final phoneAuth = Provider.of<Auth>(context, listen: false);

    final String completeNumber = phoneAuth.authData["phoneNumber"] as String;
    Provider.of<Auth>(context, listen: false)
        .registerUser(completeNumber, context);
  }

  final Widget elementSpacer = const SizedBox(
    height: 25,
  );

  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // String _verificationId;
    final phoneAuth = Provider.of<Auth>(context, listen: false);
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
              border: OutlineInputBorder(),
            ),
          ),
          elementSpacer,
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
          elementSpacer,
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(8.0),
              minimumSize: MaterialStateProperty.all(
                const Size(255, 45),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            ),
            onPressed: phoneAuth.isotpFieldReady
                ? () async {
                    // _enterOtp();
                    final otpCode = _otpController.text;
                    final authData = phoneAuth.getAuthData;
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId:
                                  authData["verificationId"].toString(),
                              smsCode: otpCode))
                          .then((value) async {
                        final user = value.user;

                        if (user != null) {
                          final displayName = user.displayName;
                          final email = user.email;
                          final phoneNumber = user.phoneNumber;
                          final photoURL = user.photoURL;
                          final uid = user.uid;

                          final loggedUser = FirebaseUser(
                            displayName: displayName,
                            email: email,
                            phoneNumber: phoneNumber,
                            photoUrl: photoURL,
                            uid: uid,
                          );
                          Provider.of<Auth>(context, listen: false)
                              .setFirebaseUser(loggedUser, "login", context);
                        }
                      });
                    } catch (e) {
                      print(e.toString());
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  }
                : null,
            child: const Text(
              "Verfiy",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          elementSpacer,
          // ElevatedButton(
          //   style: ButtonStyle(
          //     elevation: MaterialStateProperty.all(8.0),
          //     minimumSize: MaterialStateProperty.all(
          //       const Size(255, 45),
          //     ),
          //     backgroundColor: MaterialStateProperty.all(Colors.redAccent),
          //   ),
          //   onPressed: () async {
          //     final otpCode = _otpController.text;
          //     debugPrint(phoneAuth.getAuthData["verificationId"]);
          //     // await FirebaseAuth.instance.signInWithCredential(
          //     //   PhoneAuthProvider.credential(
          //     //       verificationId: , smsCode: otpCode),
          //     // );
          //   },
          //   child: const Text(
          //     "Edit number",
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
    );
  }
}
