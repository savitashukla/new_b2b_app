//import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:get/get.dart';
import 'package:gmng/model/LoginModel/LoginResponse.dart';
import 'package:gmng/preferences/UserPreferences.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/res/firebase_events.dart';
import 'package:gmng/ui/common/Progessbar.dart';
import 'package:gmng/ui/controller/login_controller.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/utills/CustomTextStyle.dart';
import 'package:gmng/utills/Platfrom.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:gmng/webservices/WebServicesHelper.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../model/LoginModel/OtpVerificationModel.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../utills/event_tracker/EventConstant.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../utills/event_tracker/FacebookEventApi.dart';
import '../controller/BaseController.dart';
import '../controller/FreshChatController.dart';
import '../controller/otpverifiction_controller.dart';
import '../main/dashbord/favourite_game/FavouriteGame.dart';
import 'Login.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class OtpVerification extends StatefulWidget {
  String from;
  LoginResponse data;
  String number;
  var btnControllerProfile = RoundedLoadingButtonController().obs;

  OtpVerification(this.data, this.from, this.number);

  @override
  _OtpVerificationState createState() =>
      _OtpVerificationState(this.data, this.from, this.number);
}

class _OtpVerificationState extends State<OtpVerification> {
  String from;
  LoginResponse userModel;
  String number;

  OtpVerificationController controller = Get.put(OtpVerificationController());
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  FocusNode focusNode = FocusNode();

  //UserController controller_user = Get.put(UserController());//ravi
  Login_Controller login_controller = Get.put(Login_Controller()); //ravi
  ProgessDialog progessbar;

  var userPreferences;

  var btnControllerProfile = RoundedLoadingButtonController();
  var btnControllerProfileRes = RoundedLoadingButtonController();

  String version;

  var resendTrue = false.obs;
  var secondV = 60.obs;

  var releaseKeySMSautofill;

  _OtpVerificationState(LoginResponse data, String from, String number) {
    this.from = from;
    this.userModel = data;
    this.number = number;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  double height, width;
  var whatsAppNo = "0".obs;
  var foc = true.obs;

  @override
  Future<void> initState() {
    super.initState();

    progessbar = new ProgessDialog(context);
    userPreferences = new UserPreferences(context);
    getAppversion();
    BaseController().getSettingPublicM();

    sharedPref();
    //getWhNumber(context);
  }

  sharedPref() async {
    try {
      //   releaseKeySMSautofill = await SmsAutoFill().getAppSignature;
    } catch (E) {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("whatsappMobile") != '' &&
          prefs.getString("whatsappMobile") != '0')
        whatsAppNo.value = prefs.getString("whatsappMobile");
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    TextEditingController passordconrtoller = new TextEditingController();

    // print("otp cal${passordconrtoller.text}");

    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * FontSizeC().screen_percentage_web
        : double.infinity;

    return Stack(
      children: [
        Image(
          width: double.infinity,
          image: AssetImage(ImageRes().background_new_otp),
          fit: BoxFit.fill,
        ),
        /*SvgPicture.asset(
          ImageRes().background_new_otp,
          width: double.infinity,
          //alignment: Alignment.center,
          */ /* width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,*/ /*
        ),*/
        Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        getCustomTextView(
                            from == 'LOGIN'
                                ? 'An OTP has been sent to'.tr
                                : 'An OTP has been sent to'.tr,
                            true),
                        SizedBox(height: 30),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  PinCodeTextField(
                                    showCursor: true,
                                    autoFocus: true,
                                    length: 6,
                                    controller: passordconrtoller,
                                    obscureText: false,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor().whiteColor),
                                    keyboardType: TextInputType.number,
                                    pinTheme: PinTheme(
                                      borderWidth: 1.5,
                                      fieldOuterPadding:
                                          const EdgeInsets.only(right: 10),
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      activeColor: AppColor().colorPrimary,
                                      inactiveColor: AppColor().colorPrimary,
                                      selectedColor: AppColor().colorPrimary,
                                      fieldHeight: 43,
                                      fieldWidth: 43,
                                    ),
                                    animationType: AnimationType.fade,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    enablePinAutofill: true,
                                    onChanged: (code) {
                                      Utils().customPrint("Changed: " + code);
                                      if (code.length == 6) {
                                        controller.Otp.value = code;
                                      }
                                    },
                                    onCompleted: (code) {
                                      if (code.length == 6) {
                                        controller.Otp.value = code;
                                        Onsubmit();
                                      }
                                    },
                                    appContext: context,
                                  ),
                                  Container(
                                    height: 1,
                                    child: PinFieldAutoFill(
                                   //   enabled: false,
                                      textInputAction: TextInputAction.previous,
                                      keyboardType: TextInputType.number,
                                      enableInteractiveSelection: false,
                                      decoration: UnderlineDecoration(
                                        textStyle: TextStyle(
                                            color: Colors.transparent),
                                        colorBuilder: FixedColorBuilder(
                                            Colors.transparent),
                                      ),
                                      codeLength: 6,
                                      onCodeSubmitted: (code) {},
                                      onCodeChanged: (code) {
                                        passordconrtoller.text = code;
                                        /*      print(
                                            "code working ${passordconrtoller.text}");*/
                                        if (code.length <= 1) {}
                                        if (code.length >= 6) {}
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // _PinFieldAutoFill(),
                        SizedBox(height: 35),
                        _ButtonVeryFy('Verify'.tr, context, Onsubmit),
                        SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF05A22),
                              style: BorderStyle.solid,
                              width: 0.5,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          //height: 50,
                          width: 160,
                          child: Obx(() => secondV.value > 0
                              ? TweenAnimationBuilder<Duration>(
                                  duration: Duration(seconds: secondV.value),
                                  tween: Tween(
                                      begin: Duration(seconds: secondV.value),
                                      end: Duration.zero),
                                  onEnd: () {
                                    secondV.value = 00;
                                    resendTrue.value = true;
                                    Utils().customPrint('Timer ended');
                                  },
                                  builder: (BuildContext context,
                                      Duration value, Widget child) {
                                    String seconds = (value.inSeconds % 60)
                                        .toInt()
                                        .toString()
                                        .padLeft(2, '0');
                                    String minutes =
                                        ((value.inSeconds / 60) % 60)
                                            .toInt()
                                            .toString()
                                            .padLeft(2, '0');

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Resend OTP  ".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: AppColor().colorGray,
                                                fontWeight: FontWeight.normal)),
                                        Obx(
                                          () => Text("$minutes\:$seconds",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: resendTrue == false
                                                      ? AppColor().colorPrimary
                                                      : AppColor().colorGray,
                                                  fontFamily: "Montserrat",
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                      ],
                                    );
                                  })
                              : GestureDetector(
                                  onTap: () {
                                    onResendOtp();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Resend OTP  ".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: AppColor().colorGray,
                                              fontWeight: FontWeight.normal)),
                                      Text("",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: AppColor().colorGray,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                )),
                        ),
                        //getCustomTextView('  Not received OTP yet?', false),
                        SizedBox(height: 15),
                        /*_Button('Resend OTP', context, onResendOtp),*/

                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () async {
                            print('TEST ::  ${whatsAppNo.value}');
                            if (whatsAppNo.value != null &&
                                whatsAppNo.value != '' &&
                                whatsAppNo.value != '0') {
                              BaseController base_controller =
                                  Get.put(BaseController());
                              base_controller.openwhatsappOTPV();
                            } else {
                              try {
                                FreshChatController freshChatController =
                                    Get.put(FreshChatController());
                                FreshchatUser freshchatUser =
                                    await Freshchat.getUser;
                                if (number != null) {
                                  freshchatUser.setPhone("+91", number);
                                }
                                Freshchat.setUser(freshchatUser);
                              } catch (e) {}
                              Freshchat.showFAQ();
                            }
                          },
                          child: Text("Need Support?".tr,
                              style: TextStyle(
                                  color: AppColor().colorPrimary,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Montserrat",
                                  fontSize: 15)),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              BaseController base_controller =
                                  Get.put(BaseController());

                              base_controller.openwhatsappOTPV();
                            },
                            child: whatsAppNo != null && whatsAppNo != "0"
                                ? Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/whatsapp_circle.png")),
                                        //fit: BoxFit.cover,
                                      ),
                                    ))
                                : Container()),
                      ],
                    ),
                  ),
                ])),
      ],
    );
  }

  Widget backgroudImage() {
    return Container(
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(ImageRes().otp_bg),
        ),
      ),
    );
  }

  Widget getCustomTextView(String text, bool check) {
    return Container(
      margin: new EdgeInsets.all(2.0),
      child: Center(
          child: Wrap(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor().colorGray,
                  //fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                )),
          ),
          Align(
            alignment: Alignment.center,
            child: Text("+91-${number}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: AppColor().colorPrimary,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400)),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => Login());
            },
            child: check == true
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 5, right: 5, bottom: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFF05A22),
                            style: BorderStyle.solid,
                            width: 0.5,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(" Change Number?".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: "Montserrat",
                              //fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 1,
                    width: 1,
                  ),
          )
        ],
      )),
    );
  }

  Future<void> Onsubmit() async {
    if (controller.Otp.value != null && controller.Otp.value.length < 6) {
      btnControllerProfile.reset();
      Utils.showCustomTosst("Please enter a valid OTP");
      return;
    }

    /* if (controller.Otp.value.length != 6) {
      Utils.showCustomTosst("Please enter a valid otp");
      return;
    }*/
    final param = {
      "otpRequestId": userModel.otpRequestId,
      "otp": controller.Otp.value,
      "userId": userModel.userId
    };
    Utils().customPrint(param);
    Map<String, dynamic> response = null;

    response = await WebServicesHelper().requestForVerifyOTP(param);

    debugPrint("otp ===${response}");

    if (response != null) {
      btnControllerProfile.success();
      OtpVerificationModel loginResponseModel =
          OtpVerificationModel.fromJson(response);
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      prefs.setString("token", loginResponseModel.token);
      String user_id = await prefs.getString("user_id");

      Map<String, dynamic> map;
      if (ApiUrl().isPlayStore) {
        map = {"app_type": "GMNG Esports", "user_id": user_id};
      } else if (ApiUrl().isbb) {
        map = {"app_type": "Fantasy", "user_id": user_id};
      } else {
        map = {"app_type": "GMNG Pro", "user_id": user_id};
      }
      //appsflyer
      AppsflyerController c = await Get.put(AppsflyerController());
      c.logEventAf(EventConstant.app_type, map);
      //clevertap
      CleverTapController cleverTapController = Get.put(CleverTapController());
      cleverTapController.logEventCT(EventConstant.app_type, map);
      cleverTapController.logEventCT(EventConstant.app_type, map);
      FirebaseEvent().firebaseEvent(EventConstant.app_type_F, map);
      //cleverTapController.logEventCT(EventConstant.app_type_new, map); //new
      //facebook
      //FaceBookEventController().logEventFacebook(EventConstant.app_type, map);
      AppString.isUserFTR = false;
      if (userModel.isNew) {
        AppString.isUserFTR = true;
        Map<String, Object> map = new Map<String, Object>();
        map["App Type"] = ApiUrl().isPlayStore ? "GMNG Esports" : "GMNG Pro";
        map["App Version"] = version ?? ""; //ravi
        map["Referal Code Used"] = login_controller.referral_codeb.value; //ravi
        map["Campaign ID"] = prefs.getString("campaignId") ?? "N/A";
        map["afAdSetId"] = prefs.getString("afAdSetId") ?? "N/A";

        map["Campaign Name"] = prefs.getString("campaignName") ?? "";
        map["Date"] = Utils().getTodayDates(); //ravi

        try {
          map["Campaign Name"] = prefs.getString("campaignName") ?? "";
          //map["Campaign Type"] = prefs.getString("campaignType") ?? "";
        } catch (E) {}
        map["Name"] = "Register Screen";
        map["user_id"] = user_id;
        map["USER_ID"] = user_id;
        map["code"] = "+91";
        appsflyerController.logEventAf("af_complete_registration", map);

        map["mobile"] = number; //no should be sent on clevertap only
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_Registration, map);
        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_FIREBASE_Registration, map);

        final params = {
          //"event_name": ApiUrl().isPlayStore ? "GMNG Esports" : "GMNG Pro",
          "event_name": "fb_complete_registration",
          "event_time": "${DateTime.now().millisecondsSinceEpoch}",
          "event_id": "",
          "action_source": "App",
          "user_data": {
            "client_ip_address": "",
            "client_user_agent": "Register Screen",
            "external_id": [userModel.userId],
          },
          "custom_data": {}
        };
        FacebookEventApi().FacebookEventC(params);
      } else {
        //Fluttertoast.showToast(msg: "Existing USER");
        Map<String, Object> map = new Map<String, Object>();
        map["Name"] = "Login Screen";
        map["code"] = "+91";
        appsflyerController.logEventAf("af_login", map);
        //FaceBookEventController().logEventFacebook("fb_login", map);
        map["mobile"] = number;
        map["USER_ID"] = userModel.userId;
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_Login, map);
      }

      Map<String, Object> map2 = new Map<String, Object>();
      map2["Name"] = "Otp verification Screen";
      map2["mobile"] = user_id;
      map2["user_id"] = user_id;
      map2["USER_ID"] = user_id;
      map2["code"] = "+91";
      appsflyerController.logEventAf(EventConstant.EVENT_OTP_VERIFICTION, map2);
      FaceBookEventController()
          .logEventFacebook(EventConstant.EVENT_OTP_VERIFICTION, map2);

      final params = {
        "event_name": "event_otp_verifiction",
        "event_time": "${DateTime.now().millisecondsSinceEpoch}",
        "event_id": "",
        "action_source": "App",
        "user_data": {
          "client_ip_address": "",
          "client_user_agent": "Login Screen",
          "external_id": [userModel.userId],
        },
        "custom_data": {}
      };
      FacebookEventApi().FacebookEventC(params);

      try {
        prefs.setString("mediaSource", "");
        prefs.setString("campaign", "");
        prefs.setString("appsFlyerId", "");
        prefs.setString("afAdSetId", "");
        prefs.setString("campaignId", "");
        prefs.setString("campaignName", "");
        prefs.setString("campaignType", "");
        prefs.setString("afAdSet", "");
        prefs.setString("afAdSetId", "");
        prefs.setString("afSub", "");
        prefs.setBool("isDeferred", false);
      } catch (E) {}
      Utils().getLocationPer().then((value) => Utils().getCurrentLocation());
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      //Get.to(() => FavouriteGame());

      /* if(userModel.isNew)
        {
          Get.to(() => FavouriteGame());
        }
      else
        {
          Get.to(() => DashBord(2, ""));
        }*/
    Get.to(() => DashBord(2, ""));

    } else {
      btnControllerProfile.reset();
      Utils().customPrint("else part");
    }
  }

  Future<void> onResendOtp() async {
    Map<String, dynamic> responsestr = null;

    final param = {
      "mobileNumber": number,
      "countryCode": 91,
      "userId": userModel.userId
    };
    Utils.showProgessBar(context);
    responsestr = await WebServicesHelper().requestForResendOTP(param);

    Utils().customPrint("respondata===${responsestr}");
    btnControllerProfileRes.reset();
    LoginResponse loginResponseModel = LoginResponse.fromJson(responsestr);
    resendTrue.value = false;
    secondV.value = 60;
    Utils.hideProgessBar();
    if (loginResponseModel != null) {
      userModel.otpRequestId = loginResponseModel.otpRequestId;

      Utils.showCustomTosst("OTP Sent Successfully");
      _printLatestValue('${loginResponseModel.error}');
    } else {
      Utils().customPrint("else part");
      // Utils.hideProgessBar();
      Utils.showCustomTosst("OTP Sent Successfully");
      _printLatestValue('${loginResponseModel.error}');
    }
  }

  getAppversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  void dispose() {
    //passordconrtoller.dispose();
    super.dispose();
  }

  _printLatestValue(String values) {
    Utils().customPrint("Second text field: ${values}");
  }

  _showProgessBar() {
    progessbar.setMessage("please wait ..");
    progessbar.show();
  }

  _hideProgessBar() {
    progessbar.hide();
  }

  //new design work
  Widget _ButtonVeryFy(String text, BuildContext context, OnMoveNext) {
    return SizedBox(
      width: 300,
      height: 50,
      child: RoundedLoadingButton(
          height: 50,
          borderRadius: 10,
          elevation: 2,
          color: Colors.transparent,
          controller: btnControllerProfile,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 35),
            height: 50,
            width: MediaQuery.of(context).size.width - 200,
            //width: 150,
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
                  Text(
                    "$text".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        color: AppColor().blackColor),
                  ),
                ],
              ),
            ),
          ) /*Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      "assets/images/rectangle_orange_gradient_box.png")),
              // border: Border.all(color: AppColor().colorPrimary, width: 2),
              borderRadius: BorderRadius.circular(10),
              // color: AppColor().whiteColor
            ),
            child: Center(
              child: Text(
                "Verify",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.normal,
                    color: AppColor().whiteColor),
              ),
            ),
          )*/
          ),
    );
  }

  Future<void> getWhNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    whatsAppNo.value = prefs.getString("whatsappMobile");
  }
}
