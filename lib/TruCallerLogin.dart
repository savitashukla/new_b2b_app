// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:truecaller_sdk/truecaller_sdk.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class TrueCallerName extends StatefulWidget {
//   const TrueCallerName({Key key}) : super(key: key);
//
//   @override
//   State<TrueCallerName> createState() => _TrueCallerNameState();
// }
//
// class _TrueCallerNameState extends State<TrueCallerName> {
//   StreamSubscription streamSubscription;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//   Utils().customPrint('TRUECALLER ----------------------> START');
//
//     initTrueCaller();
//     //CASE 1 when truecaller installed
//     //Step 4: Be informed about the TruecallerSdk.getProfile callback result(success, failure, verification)
//      streamSubscription = TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
//       switch (truecallerSdkCallback.result) {
//         case TruecallerSdkCallbackResult.success:
//           String firstName = truecallerSdkCallback.profile.firstName;
//           String lastName = truecallerSdkCallback.profile.lastName;
//           String phNo = truecallerSdkCallback.profile.phoneNumber;
//           String email = truecallerSdkCallback.profile.email;
//         Utils().customPrint('TRUECALLER ---------------------->firstName $firstName');
//         Utils().customPrint('TRUECALLER ---------------------->lastName $lastName');
//         Utils().customPrint('TRUECALLER ---------------------->phNo $phNo');
//         Utils().customPrint('TRUECALLER ---------------------->accessToken $email');
//           Fluttertoast.showToast(msg: "firstName : $firstName $lastName phNo: $phNo");
//           break;
//         case TruecallerSdkCallbackResult.failure:
//           int errorCode = truecallerSdkCallback.error.code;
//         Utils().customPrint('TRUECALLER ---------------------->errorCode $errorCode');
//           break;
//         case TruecallerSdkCallbackResult.verification:
//         Utils().customPrint("Verification Required");
//           //Initiate manual verification by asking user for his number
//           //Please ensure proper validations are in place so as to send correct phone number string to the below method,
//           //otherwise an exception would be thrown
//           TruecallerSdk.requestVerification(phoneNumber: "9044503284",countryISO: "IN");
//           break;
//
//           //CASE 2
//         case TruecallerSdkCallbackResult.missedCallInitiated:
//         //Number Verification would happen via Missed call, so you can show a loader till you receive the call
//         //You'd also receive ttl (in seconds) that determines time left to complete the user verification
//         //Once TTL expires, you need to start from step 4. So you can either ask the user to input another number
//         //or you can also auto-retry the verification on the same number by giving a retry button
//           String ttl = truecallerSdkCallback.ttl;
//         Utils().customPrint('TRUECALLER ---------------------->missedCallInitiated $ttl');
//           break;
//         case TruecallerSdkCallbackResult.missedCallReceived:
//         //Missed call received and now you can complete the verification as mentioned in step 6a
//         Utils().customPrint('TRUECALLER ---------------------->missedCallReceived');
//           //6a: If Missed call has been received on the same device, call this method with user's name
//           TruecallerSdk.verifyMissedCall(firstName: "Ravi Krishna", lastName: "Krishna");
//           break;
//         case TruecallerSdkCallbackResult.otpInitiated:
//         //Number Verification would happen via OTP
//         //You'd also receive ttl (in seconds) that determines time left to complete the user verification
//         //Once TTL expires, you need to start from step 4. So you can either ask the user to input another number
//         //or you can also auto-retry the verification on the same number by giving a retry button
//           String ttl = truecallerSdkCallback.ttl;
//         Utils().customPrint('TRUECALLER ---------------------->otpInitiated $ttl');
//           break;
//         case TruecallerSdkCallbackResult.otpReceived:
//         //OTP received and now you can complete the verification as mentioned in step 6b
//         //If SMS Retriever hashcode is configured on Truecaller's developer dashboard, get the OTP from callback
//           String otp = truecallerSdkCallback.otp;
//         Utils().customPrint('TRUECALLER ---------------------->otpReceived $otp');
//           break;
//         case TruecallerSdkCallbackResult.verificationComplete:
//         //Number verification has been completed successfully and you can get the accessToken from callback
//           String token = truecallerSdkCallback.accessToken;
//         Utils().customPrint('TRUECALLER ---------------------->token $token');
//           break;
//         case TruecallerSdkCallbackResult.verifiedBefore:
//         //Number has already been verified before, hence no need to verify. Retrieve the Profile data from callback
//           String firstName = truecallerSdkCallback.profile.firstName;
//           String lastName = truecallerSdkCallback.profile.lastName;
//           String phNo = truecallerSdkCallback.profile.phoneNumber;
//           String token = truecallerSdkCallback.profile.accessToken;
//         Utils().customPrint('TRUECALLER ---------------------->firstName2 $firstName');
//         Utils().customPrint('TRUECALLER ---------------------->lastName2 $lastName');
//         Utils().customPrint('TRUECALLER ---------------------->phNo2 $phNo');
//         Utils().customPrint('TRUECALLER ---------------------->token2 $token');
//           Fluttertoast.showToast(msg: "firstName2 : $firstName $lastName phNo2: $phNo");
//           break;
//         case TruecallerSdkCallbackResult.exception:
//         //Handle the exception
//           int exceptionCode = truecallerSdkCallback.exception.code;
//           String exceptionMsg = truecallerSdkCallback.exception.message;
//         Utils().customPrint('TRUECALLER ---------------------->exceptionMsg $exceptionMsg');
//           break;
//         default:
//         Utils().customPrint("Invalid result");
//         Utils().customPrint('TRUECALLER ---------------------->Invalid result');
//       }
//     });
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//           backgroundColor: Colors.white70,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             title: const Center(
//                 child: Padding(
//               padding: EdgeInsets.only(right: 60),
//               child: Text("DEMO"),
//             )),
//           ),
//           body: Container(
//             child: Center(child: const Text("DEMO")),
//           )),
//     );
//   }
//   //Step 1: Initialize the SDK with SDK_OPTION_WITHOUT_OTP
//   Future<void> initTrueCaller() async {
//     //TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);
//     TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP);
//
//
//     /*//Step 2: Check if SDK is usable on that device, otherwise fall back to any other alternative
//     bool isUsable = await TruecallerSdk.isUsable;
//   Utils().customPrint('TRUECALLER ---------------------->isUsable $isUsable');
//
//     //Step 3: If isUsable is true, you can call getProfile to show consent screen to verify user's number
//     isUsable ? TruecallerSdk.getProfile : print("***Not usable***");*/
//
//     //OR you can also replace Step 2 and Step 3 directly with this
//     TruecallerSdk.isUsable.then((isUsable) {
//       isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
//     Utils().customPrint('TRUECALLER ---------------------->TruecallerSdk $isUsable');
//     });
//
//
//   }
//
//   //Step 5: Dispose streamSubscription
//   @override
//   void dispose() {
//   Utils().customPrint('TRUECALLER ----------------------> END');
//     streamSubscription?.cancel();
//     super.dispose();
//   }
// }
