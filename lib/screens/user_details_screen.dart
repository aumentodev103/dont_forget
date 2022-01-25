import 'package:dont_forget/providers/auth.dart';
import 'package:dont_forget/screens/dashboard_screen.dart';
import 'package:dont_forget/widgets/date_picker_widget.dart';
import 'package:dont_forget/widgets/gender_radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  static const routeName = "/User/Details";
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<FormState> _userDetailsFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("An error occurred"),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"))
          ],
        ),
      );
    }

    bool isLoading = false;

    final deviceSize = MediaQuery.of(context).size;

    final user = Provider.of<Auth>(context, listen: false).getLoggedUser;
    final loggedUserData =
        Provider.of<Auth>(context, listen: false).getLoggedData;
    final changeUserMethod =
        Provider.of<Auth>(context, listen: false).changeLoggedUserData;

    // final TextEditingController nameController;
    // final TextEditingController emailController;
    // if (user.displayName != null) {
    //   nameController = TextEditingController(text: user.displayName);
    //   loggedUserData["displayName"] = user.displayName as String;
    // } else {
    //   nameController = TextEditingController();
    // }
    // if (user.email != null) {
    //   emailController = TextEditingController(text: user.email);
    //   loggedUserData["email"] = user.email as String;
    // } else {
    //   emailController = TextEditingController();
    // }
    // if (user.phoneNumber != null) {
    //   loggedUserData["phoneNumber"] = user.phoneNumber as String;
    // }

    void _submitDetailsForm() async {
      print(_userDetailsFormKey.currentState!.validate());
      if (!_userDetailsFormKey.currentState!.validate()) {
        return;
      }
      _userDetailsFormKey.currentState!.save();

      setState(() => isLoading = true);

      try {
        final getData = Provider.of<Auth>(context, listen: false).getLoggedData;
        FirebaseUser user = FirebaseUser(
          uid: getData["uid"] as String,
          birthdate: getData["birthdate"] as String,
          displayName: getData["displayName"] as String,
          email: getData["email"] as String,
          gender: getData["gender"] as String,
          phoneNumber: getData["phoneNumber"] as String,
          photoUrl: getData["photoUrl"] as String,
        );
        final auth = Provider.of<Auth>(context, listen: false)
            .setFirebaseUser(user, "user-details", context);
      } catch (error) {
        var errorMessage = "Network error, please try again later $error";
        _showErrorDialog(errorMessage);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.purple,
                  Colors.purple,
                  Colors.redAccent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0, 0.5, 0.5, 1],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: MediaQuery.of(context).systemGestureInsets,
              width: deviceSize.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey,
                              child: Image.asset(
                                'assets/images/google.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: deviceSize.width / 1.7,
                            top: 15,
                            child: GestureDetector(
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                              onTap: () {
                                debugPrint("Edit Picture");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        bottom: 15.0,
                      ),
                      width: deviceSize.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Form(
                              key: _userDetailsFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue:
                                          loggedUserData["displayName"],
                                      decoration: const InputDecoration(
                                        hintText: 'Name',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        // Map<String, String> userData = {
                                        //   "displayName": value,
                                        //   "email":
                                        //       loggedUserData["email"] as String,
                                        //   "phoneNumber":
                                        //       loggedUserData["phoneNumber"]
                                        //           as String,
                                        //   "photoUrl": loggedUserData["photoUrl"]
                                        //       as String,
                                        //   "uid":
                                        //       loggedUserData["uid"] as String,
                                        //   "gender": loggedUserData["gender"]
                                        //       as String,
                                        //   "birthdate":
                                        //       loggedUserData["birthdate"]
                                        //           as String,
                                        // };
                                        // changeUserMethod(userData);
                                        changeUserMethod("displayName", value);
                                      },
                                      onSaved: (value) {
                                        // Map<String, String> userData = {
                                        //   "displayName": value as String,
                                        //   "email":
                                        //       loggedUserData["email"] as String,
                                        //   "phoneNumber":
                                        //       loggedUserData["phoneNumber"]
                                        //           as String,
                                        //   "photoUrl": loggedUserData["photoUrl"]
                                        //       as String,
                                        //   "uid":
                                        //       loggedUserData["uid"] as String,
                                        //   "gender": loggedUserData["gender"]
                                        //       as String,
                                        //   "birthdate":
                                        //       loggedUserData["birthdate"]
                                        //           as String,
                                        // };
                                        changeUserMethod(
                                            "displayName", value as String);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please provide us name.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: user.email != null
                                        ? TextFormField(
                                            enabled: false,
                                            initialValue: user.email,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              hintText: 'Email',
                                              border: OutlineInputBorder(),
                                              fillColor: Colors.grey,
                                              filled: true,
                                            ),
                                          )
                                        : TextFormField(
                                            initialValue: user.email,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              hintText: 'Email',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              changeUserMethod("email", value);
                                            },
                                            onSaved: (value) {
                                              // Map<String, String> userData = {
                                              //   "displayName": loggedUserData[
                                              //       "displayName"] as String,
                                              //   "email": value as String,
                                              //   "phoneNumber": loggedUserData[
                                              //       "phoneNumber"] as String,
                                              //   "photoUrl":
                                              //       loggedUserData["photoUrl"]
                                              //           as String,
                                              //   "uid": loggedUserData["uid"]
                                              //       as String,
                                              //   "gender":
                                              //       loggedUserData["gender"]
                                              //           as String,
                                              //   "birthdate":
                                              //       loggedUserData["birthdate"]
                                              //           as String,
                                              // };
                                              // changeUserMethod(userData);
                                              changeUserMethod(
                                                  "emailp", value as String);
                                            },
                                          ),
                                  ),
                                  DatePickerWidget(
                                    pickerTitle: "Birthday",
                                    birthdate: user.birthdate ?? "",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: user.phoneNumber == null
                                        ? IntlPhoneField(
                                            decoration: const InputDecoration(
                                              labelText: 'Phone number',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(),
                                              ),
                                            ),
                                            initialCountryCode: 'IN',
                                            // controller: _phoneNumberController,
                                            onChanged: (value) {
                                              changeUserMethod("phoneNumber",
                                                  value.completeNumber);
                                            },
                                            onSaved: (value) {
                                              if (value == null) {
                                                return;
                                              }
                                              changeUserMethod("phoneNumber",
                                                  value.completeNumber);
                                              debugPrint(value.toString());
                                            },
                                            validator: (value) {
                                              debugPrint(value);
                                            },
                                          )
                                        : TextFormField(
                                            enabled: false,
                                            enableInteractiveSelection:
                                                false, // will disable paste operation
                                            focusNode:
                                                AlwaysDisabledFocusNode(),
                                            initialValue: user.phoneNumber,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey,
                                              hintText: 'Phone number',
                                              border: OutlineInputBorder(),
                                              focusColor: Colors.grey,
                                            ),
                                            onChanged: (value) {
                                              changeUserMethod(
                                                  "phoneNumber", value);
                                            },
                                            onSaved: (newValue) {
                                              changeUserMethod("phoneNumber",
                                                  newValue as String);
                                            },
                                          ),
                                  ),
                                  GenderRadioButtons(
                                    userGender: user.gender,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        debugPrint("submit Form");

                                        _submitDetailsForm();
                                      },
                                      style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.all(5.0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.redAccent,
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                          const Size(100, 40),
                                        ),
                                      ),
                                      child: const Text("Save"),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
