import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dont_forget/providers/auth.dart';

class DatePickerWidget extends StatefulWidget {
  final String pickerTitle;
  final String? birthdate;
  const DatePickerWidget({Key? key, required this.pickerTitle, this.birthdate})
      : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authObject = Provider.of<Auth>(context, listen: false);

    String? _selectedDate;
    if (widget.birthdate != null) {
      _selectedDate = widget.birthdate;
    }
    void _openDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1920),
        lastDate: DateTime.now(),
      ).then((dateChoosen) {
        if (dateChoosen == null) {
          return false;
        }
        String birthdayDate =
            '${dateChoosen.day} ${DateFormat.MMM().format(dateChoosen)} ${dateChoosen.year}';
        _selectedDate = birthdayDate;
        setState(() => _birthdayController.text = birthdayDate);
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _openDatePicker,
        child: AbsorbPointer(
          child: TextFormField(
            controller: _birthdayController,
            decoration: const InputDecoration(
              labelText: 'Birthday',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // widget.userGender = value.toString();

              // setState(() => select = value as String);
              print(value);
              authObject.changeLoggedUserData("birthdate", value);
            },
            onSaved: (newValue) {
              // final loggedUserData =
              //     Provider.of<Auth>(context, listen: false).getLoggedData;
              // Map<String, String> userData = {
              //   "displayName": loggedUserData["displayName"] as String,
              //   "email": loggedUserData["email"] as String,
              //   "phoneNumber": loggedUserData["phoneNumber"] as String,
              //   "photoUrl": loggedUserData["photoUrl"] as String,
              //   "uid": loggedUserData["uid"] as String,
              //   "gender": loggedUserData["gender"] as String,
              //   "birthdate": newValue as String,
              // };

              authObject.changeLoggedUserData("birthdate", newValue as String);
            },
          ),
        ),
      ),
    );
  }
}
