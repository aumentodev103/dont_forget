import 'package:flutter/material.dart';
import 'package:dont_forget/providers/auth.dart';
import 'package:provider/provider.dart';

class SocialIconsWidget extends StatelessWidget {
  const SocialIconsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            try {
              await auth.signInWithGoogle().then((value) {
                if (value.user != null) {
                  FirebaseUser user = FirebaseUser(
                    uid: value.user!.uid,
                    displayName: value.user!.displayName,
                    email: value.user!.email,
                    phoneNumber: value.user!.phoneNumber,
                    photoUrl: value.user!.photoURL,
                    birthdate: null,
                    gender: null,
                  );
                  auth.setFirebaseUser(user, "login", context);
                }
              });
            } catch (error) {
              debugPrint(error.toString());
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
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
          onTap: () async {
            try {
              await auth.loginWithFacebook();
            } catch (error) {
              debugPrint(error.toString());
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
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
          onTap: () async {
            try {
              auth.signInWithTwitter();
            } catch (error) {
              print("Error is $error");
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
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
    );
  }
}
