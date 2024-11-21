import 'dart:async';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/login/webview_t_c.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import '../../res/AppColor.dart';
import '../../res/AppString.dart';
import '../../utills/Platfrom.dart';
import '../../utills/Utils.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../controller/login_controller.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double height, width;

  Login_Controller login_controller = Get.put(Login_Controller());

  bool con = true;

  StreamSubscription streamSubscription;

  String firstName;

  String lastName;

  String signatureAlgorithm;

  Map<String, dynamic> payloade;

  String payloadOnly;

  var onChanges = "".obs;

  var phoneNumber = "Enter Phone Number".tr.obs;

  String signature;

  String imei_number;

  var countryCode = "".obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        "AppsflyerControllercall${AppsflyerController.referral_code_af.value}");
    try {
      if (AppsflyerController.referral_code_af.value != null) {
        if (AppsflyerController.referral_code_af.value.isNotEmpty) {
          login_controller.referral_codeb.value = true;
          login_controller.referral_code.text =
              AppsflyerController.referral_code_af.value;
          login_controller.referral_code_s.value =
              AppsflyerController.referral_code_af.value;
          print(
              "referral_code_s.value${login_controller.referral_code_s.value}");
        }
      } else {
        login_controller.referral_codeb.value = false;
      }
    } catch (E) {}

    var _duration1 = Duration(seconds: 1);
    Timer(_duration1, navigationPage);
    var _duration2 = Duration(seconds: 2);
    Timer(_duration2, navigationPage);
    var _duration = Duration(seconds: AppsflyerController.splashDelayRef.value);
    Timer(_duration, navigationPage);

    setState(() {});
  }

  Future<void> navigationPage() async {
    print(
        "AppsflyerControllercall${AppsflyerController.referral_code_af.value}");
    try {
      if (AppsflyerController.referral_code_af.value != null) {
        if (AppsflyerController.referral_code_af.value.isNotEmpty) {
          login_controller.referral_codeb.value = true;
          login_controller.referral_code.text =
              AppsflyerController.referral_code_af.value;
          login_controller.referral_code_s.value =
              AppsflyerController.referral_code_af.value;
          print(
              "referral_code_s.value${login_controller.referral_code_s.value}");
        }
      } else {
        login_controller.referral_codeb.value = false;
      }
      setState(() {
      });
    } catch (E) {}
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (AppsflyerController.onChangesV == true) {
      } else {
        if (AppsflyerController.referral_code_af.value != null) {
          if (AppsflyerController.referral_code_af.value.isNotEmpty) {
            login_controller.referral_codeb.value = true;
            login_controller.referral_code.text =
                AppsflyerController.referral_code_af.value;
            login_controller.referral_code_s.value =
                AppsflyerController.referral_code_af.value;
            print(
                "referral_code_s.value${login_controller.referral_code_s.value}");


            setState(() {
            });
          }
        } else {
          login_controller.referral_codeb.value = false;
        }
      }
    } catch (E) {}

    height = MediaQuery.of(context).size.height;

    width = Platfrom().isWeb()
        ? MediaQuery.of(context).size.width * 0.30
        : double.infinity;

    return Stack(children: [
      Image(
        width: double.infinity,
        image: AssetImage(ImageRes().background_new_otp),
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
                          ImageRes().black_logo_new,
                          //color: AppColor().whiteColor,
                        )),
                      ),
                      Column(
                        children: [
                          /*  Text(
                            "Enter your phone number", //Enter your phone number
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal),
                          ),*/
                          SizedBox(
                            height: 10,
                          ),
                          _editTitleTextFieldNumber(
                              login_controller.emailController,
                              "Enter Phone Number".tr,
                              login_controller.login_number,
                              TextInputType.number,
                              10),
                          SizedBox(
                            height: 22,
                          ),
                          _Button(context),
                          SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => Visibility(
                              visible: login_controller.referral_codeb.value,
                              // visible:AppsflyerController.referral_code_af.value != null &&AppsflyerController.referral_code_af.value.isNotEmpty? true:false,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _editTitleTextFieldreferral(
                                    "Enter referral code".tr,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                    ),
                                    child: IconButton(
                                        icon: new Icon(
                                          Icons.cancel,
                                          color: Colors.brown,
                                        ),
                                        onPressed: () {
                                          //Navigator.pop(context);
                                          if (con) {
                                            con = false;
                                            login_controller
                                                .referral_codeb.value = true;
                                          } else {
                                            con = true;
                                            login_controller
                                                .referral_codeb.value = false;
                                          }
                                          login_controller
                                              .referral_code_s.value = "";
                                        }),
                                  ),
                                  Text("")
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: !login_controller.referral_codeb.value,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: GestureDetector(
                                onTap: () {
                                  // con=true;
                                  if (con) {
                                    con = false;
                                    login_controller.referral_codeb.value =
                                        true;
                                  } else {
                                    con = true;
                                    login_controller.referral_codeb.value =
                                        false;
                                  }
                                },
                                child: Text(
                                  "Have a referral code?".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColor().colorPrimary,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Montserrat",
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 5, top: 0),
                  child: !ApiUrl().isbb
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            ApiUrl().isPlayStore == false
                                ? Text(
                                    "By continuing I hereby confirm I am 18 years of age or older and I am not playing from Assam, Nagaland, Orissa, Sikkim, Telangana and Andhra Pradesh. I agree to the "
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColor().whiteColor,
                                      fontFamily: "Montserrat",
                                    ),
                                  )
                                : Text(
                                    "By continuing I agree to the ".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor,
                                    ),
                                  ),
                            GestureDetector(
                              onTap: () {
                                //Utils.launchURLApp(ApiUrl.URL_CMS_T_C);
                                Utils().customPrint('click---->');
                                Get.to(() => WebViewTermsConditions(
                                    "Terms & Conditions"));
                              },
                              child: Text(
                                'Terms of Service',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Montserrat",
                                  decoration: TextDecoration.underline,
                                  color: AppColor().colorPrimaryDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              ' & ',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: "Montserrat",
                                color: AppColor().whiteColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Utils.launchURLApp(ApiUrl.URL_CMS_PRIVCY_POLICY);
                                Get.to(() =>
                                    WebViewTermsConditions("Privacy Policy"));
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Montserrat",
                                  decoration: TextDecoration.underline,
                                  color: AppColor().colorPrimaryDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 0,
                        ),
                ),
              )
            ],
          )),
    ]);
  }

  Widget _Button(BuildContext context) {
    Map idMapaa;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 35),
        height: 50,
        width: MediaQuery.of(context).size.width - 200,
        //width: 150,
        child: InkWell(
          onTap: () async => {
            AppString.logoutTrue = true,
            //FirebaseCrashlytics.instance.crash(),
            //Fluttertoast.showToast(msg: "msg${onChanges.value}"),
            //Utils().customPrint('BANNED STATES: PRINT ${Utils().checkForBannedStates('')}'),
            Utils().customPrint(
                "backgroundHandler ====================== $imei_number"),

            if (onChanges.value != null && onChanges.value.isNotEmpty)
              {
                login_controller.onSubmit(context),
              }
            else
              {
                if (payloadOnly != null)
                  {
                    if (payloadOnly.compareTo("skip") == 0)
                      {
                        login_controller.onSubmit(context),
                      }
                    else
                      {
                        if (countryCode.value == "IN")
                          {
                            login_controller.onSubmitTrueCaller(
                                signature,
                                signatureAlgorithm,
                                payloadOnly,
                                payloade,
                                login_controller.emailController.text)
                          }
                        else
                          {
                            Fluttertoast.showToast(
                                msg: "Please use a valid Indian phone number!"),
                          }
                      }
                  }
                else
                  {
                    login_controller.onSubmit(context),
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
                Text(
                  "Proceed".tr,
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
        ));
  }

  Widget _editTitleTextFieldNumber(TextEditingController controller,
      String text, var values, var keyboard_type, int limit) {
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Obx(
      () => Container(
        padding: EdgeInsets.only(bottom: 0),
        margin: EdgeInsets.symmetric(horizontal: 35),
        height: 52,
        child: TextField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.bottom,
          onTap: () {
            if (payloadOnly == null) {
              DemoMethodCall();
            }
          },
          style: TextStyle(color: AppColor().colorGray),
          keyboardType: keyboard_type,
          inputFormatters: [
            LengthLimitingTextInputFormatter(limit),
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColor().whiteColor,
                fontFamily: "Montserrat",
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    BorderSide(color: AppColor().colorPrimary, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    BorderSide(color: AppColor().colorPrimary, width: 1.5),
              ),
              hintText: "${phoneNumber.value}"),
          onChanged: (text) {
            phoneNumber.value = "Enter Phone Number".tr;
            onChanges.value = text;
            TextSelection previousSelection = controller.selection;
            controller.selection = previousSelection;
            Utils().customPrint("First text field: $text");
          },
          autofocus: false,
          controller: controller,
        ),
      ),
    );
  }

  Widget _editTitleTextFieldreferral(String text) {
    var textEditingController =
        TextEditingController(text: login_controller.referral_code_s.value);
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      //margin: EdgeInsets.symmetric(horizontal: 35),
      height: 52,
      width: 150,
      child: TextField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
            color: AppColor().colorGray,
            fontFamily: "Montserrat",
            fontSize: 12),
        decoration: InputDecoration(
            //border: InputBorder.none,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            //[focusedBorder], displayed when [TextField, InputDecorator.isFocused] is true
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            hintText: "${text}"),
        onChanged: (text) {
          login_controller.referral_codeb.value = true;
          AppsflyerController.onChangesV.value = true;
          login_controller.referral_code_s.value = text;

          TextSelection previousSelection = textEditingController.selection;
          textEditingController.selection = previousSelection;
        },
        controller: textEditingController,
        autofocus: false,
      ),
    );
  }

  DemoMethodCall() {
    Utils().customPrint('TRUECALLER ----------------------> START');

    initTrueCaller();
    //CASE 1 when truecaller installed
    //Step 4: Be informed about the TruecallerSdk.getProfile callback result(success, failure, verification)
    streamSubscription =
        TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
      try {
        if (truecallerSdkCallback.error != null &&
            truecallerSdkCallback.error.code != null) {
          int errorCode = truecallerSdkCallback.error.code;
          if (errorCode == 14) {
            payloadOnly = "skip";
          }
        }
      } catch (E) {
        Utils().customPrint(
            'TRUECALLER ---------------------->ERROR   ${E.toString()}');
      }

      switch (truecallerSdkCallback.result) {
        case TruecallerSdkCallbackResult.success:
          String phNo = truecallerSdkCallback.profile.phoneNumber;
          signature = truecallerSdkCallback.profile.signature;
          signatureAlgorithm = truecallerSdkCallback.profile.signatureAlgorithm;

          String firstName = truecallerSdkCallback.profile.firstName;
          String lastName = truecallerSdkCallback.profile.lastName;
          login_controller.emailController.text =
              truecallerSdkCallback.profile.phoneNumber;
          phoneNumber.value = truecallerSdkCallback.profile.phoneNumber;

          String gender = truecallerSdkCallback.profile.gender;
          String street = truecallerSdkCallback.profile.street;
          String city = truecallerSdkCallback.profile.city;
          String zipcode = truecallerSdkCallback.profile.zipcode;
          countryCode.value = truecallerSdkCallback.profile.countryCode;
          String facebookId = truecallerSdkCallback.profile.facebookId;
          String twitterId = truecallerSdkCallback.profile.twitterId;
          String email = truecallerSdkCallback.profile.email;
          String url = truecallerSdkCallback.profile.url;
          String avatarUrl = truecallerSdkCallback.profile.avatarUrl;
          bool isTrueName = truecallerSdkCallback.profile.isTrueName;
          bool isAmbassador = truecallerSdkCallback.profile.isAmbassador;
          String companyName = truecallerSdkCallback.profile.companyName;
          String jobTitle = truecallerSdkCallback.profile.jobTitle;
          payloadOnly = truecallerSdkCallback.profile.payload;

          String requestNonce = truecallerSdkCallback.profile.requestNonce;
          bool isSimChanged = truecallerSdkCallback.profile.isSimChanged;
          String verificationMode =
              truecallerSdkCallback.profile.verificationMode;
          int verificationTimestamp =
              truecallerSdkCallback.profile.verificationTimestamp;
          String userLocale = truecallerSdkCallback.profile.userLocale;
          String accessToken = truecallerSdkCallback.profile.accessToken;
          bool isBusiness = truecallerSdkCallback.profile.isBusiness;

          Utils().customPrint(
              'TRUECALLER ---------------------->countryCode data  ${truecallerSdkCallback.profile.countryCode}');

          Utils().customPrint(
              'TRUECALLER ---------------------->firstName $firstName');
          Utils().customPrint(
              'TRUECALLER ---------------------->lastName $lastName');
          Utils().customPrint('TRUECALLER ---------------------->phNo $phNo');
          Utils().customPrint(
              'TRUECALLER ---------------------->accessToken $payloadOnly');
          //login_controller.emailController.text=phoneNumber.value;
          payloade = {
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": login_controller.emailController.text,
            "gender": gender,
            "street": street,
            "city": city,
            "zipcode": zipcode,
            "countryCode": countryCode.value,
            "facebookId": facebookId,
            "twitterId": twitterId,
            "email": email,
            "url": url,
            "avatarUrl": avatarUrl,
            "isTrueName": isTrueName,
            "isAmbassador": isAmbassador,
            "companyName": companyName,
            "jobTitle": jobTitle,
            "payload": payloadOnly,
            "requestNonce": requestNonce,
            "isSimChanged": isSimChanged,
            "verificationMode": verificationMode,
            "verificationTimestamp": verificationTimestamp,
            "userLocale": userLocale,
            "accessToken": accessToken,
            "isBusiness": isBusiness,
          };

          /* login_controller.onSubmitTrueCaller(
              signature, signatureAlgorithm, payloadOnly, payloade, phoneNumber);*/
          break;
        case TruecallerSdkCallbackResult.failure:
          int errorCode = truecallerSdkCallback.error.code;
          if (payloadOnly != "skip") {
            Fluttertoast.showToast(
                msg: "Authentication Failed, Please proceed enter manually!");
          }
          Utils().customPrint("$errorCode call values ");
          Utils().customPrint(
              'TRUECALLER ---------------------->errorCode $errorCode');
          break;
        case TruecallerSdkCallbackResult.verification:
          Utils().customPrint("Verification Required");
          //Initiate manual verification by asking user for his number
          //Please ensure proper validations are in place so as to send correct phone number string to the below method,
          //otherwise an exception would be thrown
          TruecallerSdk.requestVerification(
              phoneNumber: "6307558161", countryISO: "IN");
          break;

        //CASE 2
        case TruecallerSdkCallbackResult.missedCallInitiated:
          //Number Verification would happen via Missed call, so you can show a loader till you receive the call
          //You'd also receive ttl (in seconds) that determines time left to complete the user verification
          //Once TTL expires, you need to start from step 4. So you can either ask the user to input another number
          //or you can also auto-retry the verification on the same number by giving a retry button
          String ttl = truecallerSdkCallback.ttl;
          Utils().customPrint(
              'TRUECALLER ---------------------->missedCallInitiated $ttl');
          break;
        case TruecallerSdkCallbackResult.missedCallReceived:
          //Missed call received and now you can complete the verification as mentioned in step 6a
          Utils().customPrint(
              'TRUECALLER ---------------------->missedCallReceived');
          //6a: If Missed call has been received on the same device, call this method with user's name
          TruecallerSdk.verifyMissedCall(
              firstName: firstName, lastName: lastName);
          break;
        case TruecallerSdkCallbackResult.otpInitiated:
          //Number Verification would happen via OTP
          //You'd also receive ttl (in seconds) that determines time left to complete the user verification
          //Once TTL expires, you need to start from step 4. So you can either ask the user to input another number
          //or you can also auto-retry the verification on the same number by giving a retry button
          String ttl = truecallerSdkCallback.ttl;
          Utils().customPrint(
              'TRUECALLER ---------------------->otpInitiated $ttl');
          break;
        case TruecallerSdkCallbackResult.otpReceived:
          //OTP received and now you can complete the verification as mentioned in step 6b
          //If SMS Retriever hashcode is configured on Truecaller's developer dashboard, get the OTP from callback
          String otp = truecallerSdkCallback.otp;
          Utils().customPrint(
              'TRUECALLER ---------------------->otpReceived $otp');
          break;
        case TruecallerSdkCallbackResult.verificationComplete:
          //Number verification has been completed successfully and you can get the accessToken from callback
          String token = truecallerSdkCallback.accessToken;
          Utils().customPrint('TRUECALLER ---------------------->token $token');

          Fluttertoast.showToast(
              msg: "verifiedBefore name  : $firstName $lastName token: $token");
          break;
        case TruecallerSdkCallbackResult.verifiedBefore:
          //Number has already been verified before, hence no need to verify. Retrieve the Profile data from callback
          String firstName = truecallerSdkCallback.profile.firstName;
          String lastName = truecallerSdkCallback.profile.lastName;
          String phNo = truecallerSdkCallback.profile.phoneNumber;
          String token = truecallerSdkCallback.profile.accessToken;
          Utils().customPrint(
              'TRUECALLER ---------------------->firstName2 $firstName');
          Utils().customPrint(
              'TRUECALLER ---------------------->lastName2 $lastName');
          Utils().customPrint('TRUECALLER ---------------------->phNo2 $phNo');
          Utils().customPrint(
              'TRUECALLER ---------------------->token2 call  $token');
          Fluttertoast.showToast(
              msg: "verifiedBefore name  : $firstName $lastName token: $token");
          break;
        case TruecallerSdkCallbackResult.exception:
          //Handle the exception
          int exceptionCode = truecallerSdkCallback.exception.code;
          String exceptionMsg = truecallerSdkCallback.exception.message;
          Utils().customPrint(
              'TRUECALLER ---------------------->exceptionMsg $exceptionMsg exceptionCode:$exceptionCode');
          break;
        default:
          Utils().customPrint("Invalid result");
          Utils()
              .customPrint('TRUECALLER ---------------------->Invalid result');
      }
    });
  }

  Future<void> initTrueCaller() async {
    //TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);
    TruecallerSdk.initializeSDK(
        sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);

    /*//Step 2: Check if SDK is usable on that device, otherwise fall back to any other alternative
    bool isUsable = await TruecallerSdk.isUsable;
     Utils().customPrint('TRUECALLER ---------------------->isUsable $isUsable');

    //Step 3: If isUsable is true, you can call getProfile to show consent screen to verify user's number
    isUsable ? TruecallerSdk.getProfile :Utils().customPrint("***Not usable***");*/

    //OR you can also replace Step 2 and Step 3 directly with this
    TruecallerSdk.isUsable.then((isUsable) {
      isUsable
          ? TruecallerSdk.getProfile
          : Utils().customPrint("***Not usable***");
      Utils().customPrint(
          'TRUECALLER ---------------------->TruecallerSdk $isUsable');
    });
  }
}
