import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dont_forget/providers/auth.dart';

class GenderRadioButtons extends StatefulWidget {
  final String? userGender;
  const GenderRadioButtons({Key? key, this.userGender}) : super(key: key);

  @override
  State<GenderRadioButtons> createState() => _GenderRadioButtonsState();
}

class _GenderRadioButtonsState extends State<GenderRadioButtons> {
  @override
  Widget build(BuildContext context) {
    List<String> genderList = ["Male", "Female", "Other"];
    String? select = widget.userGender;
    Map<int, String> mappedGender = genderList.asMap();
    final authObject = Provider.of<Auth>(context, listen: false);

    return Card(
      elevation: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: const Text("Gender"),
            alignment: Alignment.centerLeft,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (_, StateSetter setState) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...mappedGender.entries.map(
                      (MapEntry<int, String> mapEntry) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            activeColor: Theme.of(context).primaryColor,
                            groupValue: select,
                            value: genderList[mapEntry.key],
                            onChanged: (value) {
                              select = value as String;
                              // final loggedUserData =
                              //     Provider.of<Auth>(context, listen: false)
                              //         .getLoggedData;
                              // Map<String, String> userData = {
                              //   "displayName":
                              //       loggedUserData["displayName"] as String,
                              //   "email": loggedUserData["email"] as String,
                              //   "phoneNumber":
                              //       loggedUserData["phoneNumber"] as String,
                              //   "photoUrl":
                              //       loggedUserData["photoUrl"] as String,
                              //   "uid": loggedUserData["uid"] as String,
                              //   "gender": select as String,
                              //   "birthdate":
                              //       loggedUserData["birthdate"] as String,
                              // };

                              setState(() {});
                              // widget.userGender = value.toString();
                              authObject.changeLoggedUserData(
                                  "gender", select as String);

                              print(value);
                            },
                          ),
                          Text(mapEntry.value)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
