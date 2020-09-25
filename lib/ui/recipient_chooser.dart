import 'dart:ui';

import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telecom_helper/environment/services/global_actions.dart';

class ReceiverChooser extends StatefulWidget {
  final Map singlePlan;
  final String message;
  ReceiverChooser(this.singlePlan, this.message);

  @override
  _ReceiverChooserState createState() =>
      _ReceiverChooserState(singlePlan, message);
}

class _ReceiverChooserState extends State<ReceiverChooser> {
  Contact contact;
  final Map package;
  final String message;
  String phoneNumber = '';
  ContactPicker _contactPicker = new ContactPicker();

  _ReceiverChooserState(this.package, this.message);

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = phoneNumber;
    _textEditingController.selection = TextSelection.collapsed(offset: -1);

    debugPrint('TeleHelper: phone ' + phoneNumber);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: CupertinoActionSheet(
          title: Text(
            "የሚላክለትን ስልክ ቁጥር ያስገቡ",
            style: TextStyle(fontSize: 16),
          ),
          message: Text(message),
          cancelButton: CupertinoActionSheetAction(
            child: Text('ተመለስ'),
            isDefaultAction: true,
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            Container(
              child: CupertinoTextField(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w400,
                ),
                placeholder: '0921615223',
                maxLines: 1,
                controller: _textEditingController,
                autofocus: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (String inputPhoneNumber) {
                  setState(() {
                    phoneNumber = inputPhoneNumber;
                  });
                },
              ),
            ),
            CupertinoButton(
              onPressed: () {
                _contactPicker.selectContact().then((selectedContact) {
                  String rawPhoneNumber = selectedContact.phoneNumber.number
                      .toString()
                      .replaceAll(' ', '');
                  setState(() {
                    phoneNumber = '09' +
                        rawPhoneNumber
                            .substring(rawPhoneNumber.length - 8)
                            .toString();
                  });
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.contacts),
                    Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("ከኮንታክት አውጣ"))
                  ],
                ),
              ),
            ),
            CupertinoButton(
              onPressed: GlobalAction.validPhoneNumber(phoneNumber)
                  ? () {
                      GlobalAction.buyPackage(context, package, false,
                          phoneNumber: phoneNumber);
                    }
                  : null,
              child: Container(
                  margin: EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.send),
                      Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("ላክ"),
                      )
                    ],
                  )),
            )
          ]),
    );
  }
}
