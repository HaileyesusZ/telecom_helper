import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telecom_helper/environment/constants/package_attributes.dart';

class GlobalAction {
  /*
   buys package
   */
  static void buyPackage(BuildContext context, Map package, bool forOwn,
      {String phoneNumber}) {
    if (!package.containsKey('ussd')) {
      Scaffold.of(context).showBottomSheet(
        (BuildContext context) {
          return Text("የተመረጠው ጥቅል አልተገኘም!");
        },
      );
      return;
    }
    // validate phone number
    if (!forOwn && validPhoneNumber(phoneNumber)) {
      Scaffold.of(context).showBottomSheet((BuildContext context) {
        return Text("የመረጡት ስልክ ቁጥር ትክክል መሆኑን ያረጋግጡ!");
      }, elevation: 8);
      return;
    }
    // construct ussd
    String ussd =
        (forOwn ? PACKAGE_USSD_FOR_OWN_PREFIX : PACKAGE_USSD_FOR_GIFT_PREFIX) +
            package['ussd'] +
            (forOwn
                ? PACKAGE_USSD_SUFFIX
                : '*' + phoneNumber + PACKAGE_USSD_SUFFIX);

    debugPrint('TeleDebug: ussd is ' + ussd);

    displayDialog(context, "USSD", ussd);
  }

  /*
  displays dialog
   */
  static void displayDialog(BuildContext context, title, message) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("እሺ"))
            ],
          );
        });
  }

  static bool validPhoneNumber(String phoneNumber) {
    return !(phoneNumber == null ||
        phoneNumber.isEmpty ||
        phoneNumber.length != 10 ||
        !phoneNumber.startsWith('09'));
  }
}
