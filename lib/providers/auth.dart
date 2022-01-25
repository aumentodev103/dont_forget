import 'package:dont_forget/screens/dashboard_screen.dart';
import 'package:dont_forget/screens/user_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    DatabaseReference dbRef = database.ref().child(ref);
    await dbRef.once().then((snapshot) {
      DataSnapshot dataSnapshot = snapshot.snapshot;
      if (dataSnapshot.value != null) {
        from = "user-details";
      }
    });

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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Future<FacebookAuthCredential> signInWithFacebook() async {
  //   print("Facebook Login");
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //   print("Facebook Login $loginResult");
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  Future<OAuthCredential?> loginWithFacebook() async {
    final fb = FacebookLogin();
    try {
      // Log in
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

// Check result status
      switch (res.status) {
        case FacebookLoginStatus.success:
          // Logged in

          // Send access token to server for validation and auth
          final FacebookAccessToken accessToken =
              res.accessToken as FacebookAccessToken;
          print('Access token: ${accessToken.token}');

          // Get profile data
          final profile = await fb.getUserProfile();
          if (profile != null) {
            print('Hello, ${profile.name}! You ID: ${profile.userId}');
            // Get user profile image url
            final imageUrl = await fb.getProfileImageUrl(width: 100);
            print('Your profile image: $imageUrl');

            // Get email (since we request email permission)
            final email = await fb.getUserEmail();
            // But user can decline permission
            if (email != null) print('And your email is $email');
          }

          break;
        case FacebookLoginStatus.cancel:
          // User cancel log in
          break;
        case FacebookLoginStatus.error:
          // Log in failed
          print('Error while log in: ${res.error}');
          break;
      }
    } catch (e) {
      print('Error is => ${e.toString()}');
      return null;
    }
  }
}
