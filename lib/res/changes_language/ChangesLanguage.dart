import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/AppColor.dart';
import '../AppString.dart';

class ChanagesLanguages extends StatelessWidget {
  static var languageS = "en";
  static var language_countryS = "US";

  ChanagesLanguages({Key key}) : super(key: key);
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')}, //hindi
    {'name': 'ગુજરાતી', 'locale': Locale('gu', 'IN')}, //Gujarati
    {'name': 'ಕನ್ನಡ', 'locale': Locale('kn', 'IN')}, //Kannada
    {'name': 'મરાઠી', 'locale': Locale('mr', 'IN')}, //Marathi
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/images/store_top.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          // backgroundColor: AppColor().reward_card_bg,
          title: Container(
              margin: EdgeInsets.only(right: 50),
              child: Center(child: Text("title".tr))),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "sub".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () async {
                // buildLanguageDialog(context);
                Utils.language.value = "en";
                Utils.language_country.value = "US";

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("language", "en");
                prefs.setString("language_country", "US");
                Utils().getLocation();
                updateLanguage(locale[0]['locale']);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  "I want to change my language to English",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor().colorGray, width: 1),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                Utils.language.value = "hi";
                Utils.language_country.value = "IN";
                Utils().getLocation();
                //  buildLanguageDialog(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("language", "hi");
                prefs.setString("language_country", "IN");
                Utils.language.value = prefs.getString("language");
                //  Fluttertoast.showToast(msg: "msg${Utils.language.value}");
                updateLanguage(locale[1]['locale']);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  "मैं अपनी भाषा को हिंदी में बदलना चाहता हूं",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor().colorGray, width: 1),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            /* SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                buildLanguageDialog(context);
                updateLanguage(locale[1]['locale']);
                //updateLanguage(locale[2]['locale']);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  "ನಾನು ನನ್ನ ಭಾಷೆಯನ್ನು ಕನ್ನಡಕ್ಕೆ ಬದಲಾಯಿಸಲು ಬಯಸುತ್ತೇನೆ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor().colorGray, width: 1),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
