//import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmng/model/AppSettingResponse.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class AppDownScreen extends StatefulWidget {
  const AppDownScreen({Key key}) : super(key: key);

  @override
  State<AppDownScreen> createState() => _AppDownScreenState();
}

class _AppDownScreenState extends State<AppDownScreen> {
  UserController userController;

  Future<bool> onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(children: [
        Image(
          width: double.infinity,
          image: AssetImage(ImageRes().background_app_down),
          fit: BoxFit.fill,
        ),
        /*SvgPicture.asset(
          ImageRes().background_new_otp,
          fit: BoxFit.fill,
          //alignment: Alignment.center,
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
        ),*/
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0, top: 0),
                            child: Image.asset(ImageRes().logo_login_tranparnt,
                                height: 200, width: 350),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 150.0, left: 75, right: 75, bottom: 50),
                          child: Center(
                              child: /*Image.asset(ImageRes().logo_login,
                                height: 200, width: 200),
                          )*/
                                  SvgPicture.asset(
                            ImageRes().settings_app_down,
                            height: 200,
                            //color: AppColor().whiteColor,
                          )),
                        ),
                        Column(
                          children: [
                            Text(
                              "App is down", //Enter your phone number
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal),
                            ),
                            Text(
                              "Please check back soon!", //Enter your phone number
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal),
                            ),
                            SizedBox(
                              height: 150,
                            ),
                            _Button(context),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }

  Widget _Button(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 35),
        height: 50,
        width: MediaQuery.of(context).size.width - 200,
        //width: 150,
        child: InkWell(
          onTap: () async => {
            //Fluttertoast.showToast(msg: 'Work in progress!'),
            //Utils().showWalletDown(context),//Wallet down pop up
            //Utils().showKycDown(context), //KYC down pop up
            userController = Get.put(UserController()),
            showProgress(context, '', true),
            await userController.getAppSetting(),
            hideProgress(context),
            if (userController.appSettingReponse.value.featuresStatus != null &&
                userController.appSettingReponse.value.featuresStatus.length >
                    0)
              {
                for (FeaturesStatus obj
                    in userController.appSettingReponse.value.featuresStatus)
                  {
                    if (obj.id == 'appUp' && obj.status == 'active')
                      {
                        Navigator.of(context).pop(),
                        //Fluttertoast.showToast(msg: 'ACTIVE'),
                        //Utils().showWalletDown(context),
                      }
                  }
              }
          },
          child: Container(
            width: 100,
            height: 42,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                //  stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.

                  AppColor().button_bg_light,
                  AppColor().button_bg_dark,
                ],
              ),
              border: Border.all(color: AppColor().whiteColor, width: 2),
              borderRadius: BorderRadius.circular(30),

              boxShadow: const [
                BoxShadow(
                  offset: const Offset(
                    0.0,
                    5.0,
                  ),
                  blurRadius: 1.0,
                  spreadRadius: .3,
                  color: Color(0xFFA73804),
                  inset: true,
                ),
                BoxShadow(
                  offset: Offset(00, 00),
                  blurRadius: 00,
                  color: Color(0xFFffffff),
                  inset: true,
                ),
              ],
              // color: AppColor().whiteColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: /*Image.asset(ImageRes().logo_login,
                              height: 200, width: 200),
                        )*/
                        SvgPicture.asset(
                  ImageRes().undo,
                  height: 18,
                  //color: AppColor().whiteColor,
                )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Retry".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      color: AppColor().whiteColor),
                ),
              ],
            ),
          ),
        ));
  }
}
