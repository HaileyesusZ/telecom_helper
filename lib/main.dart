import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:telecom_helper/environment/constants/package_attributes.dart';
import 'package:telecom_helper/environment/services/streams.dart';
import 'package:telecom_helper/ui/package_options.dart';

// get it
GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<Loader>(Loader());
  getIt.registerSingleton<CurrentPackage>(CurrentPackage());
  getIt.registerSingleton<PackagePlans>(PackagePlans());

  runApp(
    CupertinoApp(
      home: TelecomHelper(),
      title: "Telecom Helper",
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
//          barBackgroundColor: Color.fromRGBO(39, 43, 43, 1),
          primaryColor: Colors.teal,
//          primaryContrastingColor: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black),
    ),
  );
}

class TelecomHelper extends StatelessWidget {
  final loading = getIt.get<Loader>();
  final currentPackage = getIt.get<CurrentPackage>();
  final packagePlans = getIt.get<PackagePlans>();

  @override
  Widget build(BuildContext context) {
    // default to data package
    changePackageType(context, PACKAGE_TYPE.DATA);

    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: true,
      tabBuilder: (context, index) {
        return (index == 0)
            ? CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            " ቴሌኮም ረዳት",
                            style: TextStyle(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder(
                                stream: currentPackage.stream,
                                builder: (context, snapshot) {
                                  return CupertinoSegmentedControl(
                                    groupValue: snapshot.data,
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 10),
                                    children: {
                                      PACKAGE_TYPE.DATA: Container(
                                        child: Text(PACKAGE_TYPE_NAMES[
                                            PACKAGE_TYPE.DATA]),
                                        padding: EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 8,
                                            right: 8),
                                      ),
                                      PACKAGE_TYPE.VOICE: Container(
                                        child: Text(PACKAGE_TYPE_NAMES[
                                            PACKAGE_TYPE.VOICE]),
                                        padding: EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 8,
                                            right: 8),
                                      ),
                                      PACKAGE_TYPE.SMS: Container(
                                        child: Text(PACKAGE_TYPE_NAMES[
                                            PACKAGE_TYPE.SMS]),
                                        padding: EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 8,
                                            right: 8),
                                      )
                                    },
                                    onValueChanged: (value) =>
                                        changePackageType(context, value),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder(
                                stream: loading.stream,
                                builder: (context, snapshot) {
                                  bool isLoading = snapshot.data;
                                  if (!snapshot.hasData || isLoading) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: CupertinoActivityIndicator(
                                            radius: 16,
                                          ),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              "የጥቅሉን ዝርዝር በማግኘት ላይ ..",
                                              style: TextStyle(
                                                  color: Colors.grey.shade400),
                                            )),
                                      ],
                                    );
                                  }

                                  return Container(
                                    child: StreamBuilder(
                                      stream: packagePlans.stream,
                                      builder: (context, snapshot) {
                                        Map packagePlansData = snapshot.data;
                                        if (snapshot.hasData &&
                                            packagePlansData.length > 0) {
                                          return PackageOptions(
                                              packagePlansData);
                                        } else {
                                          return Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "የሚፈልጉትን ጥቅል መጀመሪያ ይምረጡ"));
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ));
                },
              )
            : Container(
//                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey.shade900),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.sim_card,
                        color: Colors.teal.shade600,
                        size: 84,
                      ),
                    ),
                    Container(
                      child: Text(
                        "ቴሌኮም ረዳት",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.teal.shade800,
                      indent: 16,
                      endIndent: 16,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 24,
                            ),
                            Text(
                              "መተግበሪያ ሰሪ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey.shade300),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          "ሃይለኢየሱስ ዘመድ",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone_iphone,
                              size: 24,
                            ),
                            Text(
                              "ስልክ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey.shade300),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          "0921615223",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          "0962239267",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.email,
                              size: 24,
                            ),
                            Text(
                              "ኢሜል",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey.shade300),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          "rebbet21@gmail.com",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              size: 24,
                            ),
                            Text(
                              "ሊንክድ ኢን",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey.shade300),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          "@haileyesuszemed",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Text(
                        "@copyright " + DateTime.now().year.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              );
      },
      tabBar: CupertinoTabBar(
//        backgroundColor: Colors.black,
//        inactiveColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.sim_card,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.help,
          ))
        ],
      ),
    );
  }

  changePackageType(context, value) {
    loading.request();
    currentPackage.changeCurrentPackage(value);
    try {
      // select the proper package to load
      String packageFile = PACKAGE_FILES[value];

      Future<String> fileLoader =
          DefaultAssetBundle.of(context).loadString(packageFile);

      fileLoader.then((stringFile) {
        Map plans = jsonDecode(stringFile);
        packagePlans.setPackagePlans(plans);
      });

      Future.delayed(Duration(seconds: 2), () {
        loading.endRequest();
      });
    } catch (ex) {
      loading.endRequest();
    }
  }
}
