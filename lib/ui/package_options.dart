import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:telecom_helper/environment/constants/package_attributes.dart';
import 'package:telecom_helper/environment/services/global_actions.dart';
import 'package:telecom_helper/environment/services/streams.dart';
import 'package:telecom_helper/ui/recipient_chooser.dart';

GetIt getIt = GetIt.instance;
final currentPackage = getIt.get<CurrentPackage>();

class PackageOptions extends StatelessWidget {
  Map packagePlans;

  final currentPackage = getIt.get<CurrentPackage>();

  PackageOptions(this.packagePlans);

  @override
  Widget build(BuildContext context) {
    List<Widget> allPlanOptions = [];
    packagePlans.forEach((planName, planOptions) {
      List<Widget> planWidgets = [
        Container(
          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            planName.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
          ),
        )
      ];

      List plans = planOptions;

      planWidgets.addAll(plans.map((singlePlan) {
        String amount = singlePlan['amount'];
        String price = singlePlan['price'];

        int planIndex = plans.lastIndexOf(singlePlan);

        return Container(
          padding: EdgeInsets.only(top: planIndex == 0 ? 8.0 : 0.0),
          color: Color.fromRGBO(39, 43, 43, 1),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 24.0),
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        amount,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        pressedOpacity: .4,
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.shopping_cart,
                                    color: Colors.teal),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(
                                  price,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.teal),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () => handleSelectedPackage(context,
                            singlePlan: singlePlan, planExpiration: planName))
                  ],
                ),
              ),
              plans.lastIndexOf(singlePlan) != plans.length - 1
                  ? Divider(
                      color: Colors.black54,
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 8),
                    )
            ],
          ),
        );
      }).toList());

      allPlanOptions.addAll(planWidgets);
    });

    return ListView(
      children: allPlanOptions,
    );
  }

  /*
     show options, whether the package should be
    for the person
  */
  handleSelectedPackage(BuildContext context,
      {Map singlePlan, String planExpiration}) {
    String message = PACKAGE_TYPE_NAMES[currentPackage.current] +
        " " +
        planExpiration +
        '፣ ' +
        singlePlan['amount'] +
        ' በ ' +
        singlePlan['price'];

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
              title: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
              message: const Text('ጥቅሉን ለማን እንደሚሞሉ ይምሪጡ'),
              cancelButton: CupertinoActionSheetAction(
                child: Text('ተመለስ'),
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                    child: Container(
                      child: Text("ለራስዎ"),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      confirmPackagePurchase(context, singlePlan, message);
                    }),
                CupertinoActionSheetAction(
                    child: Container(
                      child: Text("ለሌላ ሰው"),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      chooseRecipient(context, singlePlan, message);
                    }),
              ]);
        });
  }

  /*
  confirm package selection and buy if confirmed
   */
  confirmPackagePurchase(BuildContext context, package, message,
      {bool forOwn = true, String phoneNumber = ''}) {
//    String message = PACKAGE_TYPE_NAMES[currentPackage.current] +
//        " " +
//        packageExpiration +
//        '፣ ' +
//        package['amount'] +
//        ' በ ' +
//        package['price'];
    String chosenFor = "የመረጡት " + (forOwn ? 'ለራስዎ' : 'ለ ' + phoneNumber);

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "በቃ ልሙላው?",
              style: TextStyle(fontSize: 20),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 16,
                ),
                Text(
                  chosenFor,
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  height: 16,
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("አይ ተወው"),
                isDestructiveAction: true,
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                onPressed: () => Navigator.pop(context),
                isDefaultAction: true,
              ),
              CupertinoDialogAction(
                child: Text("ሙላው"),
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                onPressed: () {
                  Navigator.pop(context);
                  GlobalAction.buyPackage(context, package, forOwn,
                      phoneNumber: phoneNumber);
                },
              ),
            ],
          );
        });
  }

  /*
  set receiver's phone number
   */
  chooseRecipient(
      BuildContext context, Map singlePlan, String planExpiration) async {
    // Contact contact = await _contactPicker.selectContact();

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return ReceiverChooser(singlePlan, planExpiration);
        });
  }
}
