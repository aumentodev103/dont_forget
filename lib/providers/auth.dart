import 'package:dont_forget/screens/dashboard_screen.dart';
import 'package:dont_forget/screens/user_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum AuthMode { enterPhoneNumber, enterOTP }

enum Gender { male, female, other }

//------------ MOdels  -----------------//

class UserDataModel {}

class FirebaseUser with ChangeNotifier {
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final String uid;
  final String? gender;
  final String? birthdate;
  FirebaseUser({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.uid,
    this.birthdate,
    this.gender,
  });
}

class Auth with ChangeNotifier {
  static const apiKey = "AIzaSyC7Yw17KxbqxrAOinwsxZVx-6mUkEXXChQ";

  late FirebaseUser loggedUser;
  int? _token;

  // DateTime? _tokenExpiryDate;

  String? _uid;

  bool numberValid = false;

  bool otpFieldReady = false;

  AuthMode currentAuthMode = AuthMode.enterPhoneNumber;

  //----- Maps -----//
  final Map<String, String> authData = {
    "phoneNumber": "",
    "verificationId": '',
    "OTP": "",
  };

  Map<String, String> loggedUserData = {
    "displayName": "",
    "email": "",
    "phoneNumber": "",
    "photoUrl": "",
    "uid": "",
    "gender": "",
    "birthdate": "",
  };
  //----- Getters -----//

  bool get isNumberValid {
    return numberValid;
  }

  bool get isotpFieldReady {
    return otpFieldReady;
  }

  AuthMode get getAuthMode {
    return currentAuthMode;
  }

  String get getUserId {
    return _uid as String;
  }

  bool get isUserAuthenticated {
    return _token != "";
  }

  Map<String, String> get getAuthData {
    return authData;
  }

  Map<String, String> get getLoggedData {
    return loggedUserData;
  }

  FirebaseUser get getLoggedUser {
    return loggedUser;
  }

  Future<void> setFirebaseUser(
      FirebaseUser user, String from, BuildContext ctx) async {
    loggedUser = user;
    FirebaseDatabase database = FirebaseDatabase.instance;
    final ref = "Users/${user.uid}/user_info/";

    await database.ref(ref).update({
      "displayName": user.displayName,
      "email": user.email,
      "gender": user.gender,
      "phoneNumber": user.phoneNumber,
      "photoUrl": user.photoUrl,
      "uid": user.uid,
      "birthdate": user.birthdate,
    }).then(
      (value) {
        loggedUserData = {
          "displayName":
              user.displayName != null ? user.displayName as String : "",
          "email": user.email != null ? user.email as String : "",
          "gender": user.gender != null ? user.gender as String : "",
          "phoneNumber":
              user.phoneNumber != null ? user.phoneNumber as String : "",
          "photoUrl": user.photoUrl != null ? user.photoUrl as String : "",
          "uid": user.uid,
          "birthdate": user.birthdate != null ? user.birthdate as String : "",
        };
        switch (from) {
          case "login":
            Navigator.pushReplacementNamed(ctx, UserDetailsScreen.routeName);
            break;

          case "user-details":
            debugPrint(loggedUserData.toString());
            Navigator.pushReplacementNamed(ctx, DashboardScreen.routeName);
            break;
        }
      },
    );
  }

  void changeNumberValidation(bool isNumberValid) {
    numberValid = isNumberValid;
    // if (numberValid == true) {
    //   notifyListeners();
    // }.
  }

  void onInputChange(String phoneNumber) {
    authData["phoneNumber"] = phoneNumber;
    debugPrint(authData.toString());
    notifyListeners();
  }

  void onLogin(String phoneNumber) {
    currentAuthMode = AuthMode.enterOTP;
    authData["phoneNumber"] = phoneNumber;
    debugPrint("Show OTP input $getAuthData");
    notifyListeners();
  }

  void onOtpEnter(String code) async {
    authData["OTP"] = code;
    debugPrint("Entered OTP is => $code ${authData["verificationId"]}");
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: authData["verificationId"] as String,
        smsCode: code,
      ),
    );
    notifyListeners();
  }

  void changeLoggedUserData(String userDataName, String userDataValue) {
    print(" The user data => $userDataName $userDataValue");
    loggedUserData[userDataName] = userDataValue;
    print(loggedUserData);
    notifyListeners();
  }

  Future registerUser(String mobile, BuildContext context) async {
    debugPrint("The  Number is $mobile");
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .verifyPhoneNumber(
      phoneNumber: mobile,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        debugPrint(credential.toString());

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('The error is ==> $e');
        // if (e.code == 'invalid-phone-number') {
        //   debugPrint('The provided phone number is not valid.');
        // }

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint(" verification Id is $verificationId");
        authData["verificationId"] = verificationId;
        _token = resendToken;
        otpFieldReady = true;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
        // authData["verificationId"] = verificationId;
        // notifyListeners();
      },
      timeout: const Duration(seconds: 120),
    )
        .catchError((error) {
      debugPrint("the following error occurred => $error");
    });
  }
}
