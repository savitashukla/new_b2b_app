import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmng/model/Withdrawal/withdrawTds.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Withdrawal/WithdrawalModelR.dart';
import '../../model/basemodel/AppBaseErrorResponse.dart';
import '../../model/wallet/WithdrawRequest.dart';
import '../../res/AppString.dart';
import '../../res/firebase_events.dart';
import '../../utills/Utils.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../webservices/WebServicesHelper.dart';
import '../login/Login.dart';

class WithdrawalController extends GetxController {
  SharedPreferences prefs;
  List<Placemark> placeMarks = [];

  String token;
  String user_id;
  var UPI_link = "".obs;
  var accountholderName = "".obs;
  var accountNumber = "".obs;
  var accountNumberConfirm = "".obs;
  var accountIFSCCode = "".obs;
  var withdrawalModelR = WithdrawalModelR().obs;
  var withdrawType = "".obs;
  var enter_Amount = 0.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var permission;
  var addressLine1 = "".obs;
  var addressLine2 = "".obs;
  var permissionAlow = false.obs;
  TextEditingController fullAddress = new TextEditingController();
  var withdrawProcessingComplete = false.obs;
  var withdrawProcessingSuccessMessage = "".obs;
  var withdrawProcessingFailedMessage = "".obs;
  var withdrawProcessingStatusCode = 0.obs;

  var responseWithdraw = {}.obs;
  var withdrawRequestModelR = WithdrawRequestNew().obs;

  var stateV = "".obs;

  var pennyDropFalseFirstTime = true.obs;
  var withdrawalModelTDS = WithdrawTDS().obs;

  Timer mytimer;

  var withdrawProcessCompleted = "check".obs;

//  var latLong = const LatLng(0.0, 0.0).obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getWithdrawalData();
    getCurrentLocation();
  }

  Future<void> getWithdrawalUPI(BuildContext context) async {
    var map = {
      "type": "upi",
      "data": {
        "upi": {"link": UPI_link.value}
      }
    };
    showProgress(context, "", true);
    var response = await WebServicesHelper().getWithdrawal(map, token, user_id);
    hideProgress(context);
    if (response != null) {
      getWithdrawalData();
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getWithdrawalUPIUpdate(
      BuildContext context, String withdrawMethodId) async {
    var map = {
      "type": "upi",
      "data": {
        "upi": {"link": UPI_link.value}
      }
    };
    showProgress(context, "", true);

    var response = await WebServicesHelper()
        .getWithdrawalUpdate(map, token, user_id, withdrawMethodId);

    hideProgress(context);
    if (response != null) {
      getWithdrawalData();
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getWithdrawalBank(BuildContext context) async {
    if (accountNumber.value != null && accountNumber.value.isNotEmpty) {
      if (accountNumber.value == accountNumberConfirm.value) {
        if (ApiUrl().isbb) {
          bool stateR = await Utils().checkResLocation(context);
          if (stateR) {
            Utils().customPrint("LOCATION 11: ---------FAILED");
            return;
          }

          if (fullAddress.text != null && fullAddress.text.isNotEmpty) {
            var map = {
              "type": "bank",
              "data": {
                "bank": {
                  "accountNo": accountNumber.value,
                  "ifscCode": accountIFSCCode.value,
                  "name": accountholderName.value,
                  "address": fullAddress.text
                }
              }
            };

            showProgress(context, '', true);

            var response =
                await WebServicesHelper().getWithdrawal(map, token, user_id);
            hideProgress(context);
            if (response != null) {
              //  Fluttertoast.showToast(msg: "Bank Account Added Sucessfully");
              getWithdrawalData();
            } else {
              //hideProgress();
              Fluttertoast.showToast(msg: "Some Error");
            }
          } else {
            Fluttertoast.showToast(msg: "Enter Residencial Address");
          }
        } else {
          var map = {
            "type": "bank",
            "data": {
              "bank": {
                "accountNo": accountNumber.value,
                "ifscCode": accountIFSCCode.value,
                "name": accountholderName.value
              }
            }
          };

          showProgress(context, '', true);

          var response =
              await WebServicesHelper().getWithdrawal(map, token, user_id);
          hideProgress(context);
          if (response != null) {
            // Fluttertoast.showToast(msg: "Bank Account Added Sucessfully");
            getWithdrawalData();
          } else {
            //hideProgress();
            Fluttertoast.showToast(msg: "Some Error");
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Account Number and Confirm account Number does not match");
      }
    } else {
      Fluttertoast.showToast(msg: "Enter Account Number");
    }
  }

  Future<void> getWithdrawalBankUpDate(
      BuildContext context, String withdrawMethodId) async {
    if (accountNumber.value != null && accountNumber.value.isNotEmpty) {
      if (accountNumber.value == accountNumberConfirm.value) {
        /*    if (ApiUrl().isbb) {
          bool stateR = await Utils().checkResLocation(context);
          if (stateR) {
            Utils().customPrint("LOCATION 11: ---------FAILED");
            return;
          }

          if (fullAddress.text != null && fullAddress.text.isNotEmpty) {
            var map = {
              "type": "bank",
              "data": {
                "bank": {
                  "accountNo": accountNumber.value,
                  "ifscCode": accountIFSCCode.value,
                  "name": accountholderName.value,
                  "address": fullAddress.text
                }
              }
            };

            showProgress(context, '', true);

            var response =
            await WebServicesHelper().getWithdrawal(map, token, user_id);
            hideProgress(context);
            if (response != null) {
              //  Fluttertoast.showToast(msg: "Bank Account Added Sucessfully");
              getWithdrawalData();
            } else {
              //hideProgress();
              Fluttertoast.showToast(msg: "Some Error");
            }
          } else {
            Fluttertoast.showToast(msg: "Enter Residencial Address");
          }
        } else {*/
        var map = {
          "type": "bank",
          "data": {
            "bank": {
              "accountNo": accountNumber.value,
              "ifscCode": accountIFSCCode.value,
              "name": accountholderName.value
            }
          }
        };

        showProgress(context, '', true);

        var response = await WebServicesHelper()
            .getWithdrawalUpdate(map, token, user_id, withdrawMethodId);
        hideProgress(context);
        if (response != null) {
          // Fluttertoast.showToast(msg: "Bank Account Added Sucessfully");
          getWithdrawalData();
        } else {
          //hideProgress();
          Fluttertoast.showToast(msg: "Some Error");
        }
        //  }
      } else {
        Fluttertoast.showToast(
            msg: "Account Number and Confirm account Number does not match");
      }
    } else {
      Fluttertoast.showToast(msg: "Enter Account Number");
    }
  }

  Future<void> getWithdrawalData() async {
    withdrawalModelR.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getWithdrawalData(token, user_id);
    if (response != null) {
      withdrawalModelR.value = WithdrawalModelR.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    placeMarks =
        await placemarkFromCoordinates(latitude.value, longitude.value);
    addressLine1.value = "${placeMarks[0].name}";
    addressLine2.value =
        "${placeMarks[0].subLocality}, ${placeMarks[0].locality}";
    stateV.value = placeMarks[0].administrativeArea;
    fullAddress.text = "${addressLine1.value}${addressLine2.value}";

    Utils().customPrint(
        "addressLine1.value ${addressLine1.value} addressLine2.value${addressLine2.value}");
  }

  Future<void> getLocationPer() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');
        return Future.error('Location permissions are denied');
      }
    }

    getPermission();
  }

  void getPermission() {
    if ((permission == LocationPermission.always) ||
        (permission == LocationPermission.whileInUse)) {
      permissionAlow.value = true;
      getCurrentLocation();
    }
  }

  Future<void> getWithdrawRequest() async {
    withdrawRequestModelR.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getWithdrawRequest(token, user_id);

    if (response != null) {
      withdrawRequestModelR.value = WithdrawRequestNew.fromJson(response);
    }
    Utils().customPrint('getWithdrawRequest DATA:: ${withdrawRequestModelR}');
  }

  Future<void> getWithdrawalClick(
      String Withdran_method_type,
      BuildContext context,
      String withdrawMethodId,
      String wallet_id,
      var winningB,
      RxInt maxlimit,
      RxInt maxAmountUserLa,
      RxInt minAmountUserLa,
      RxInt noWithdraw) async {
    Utils().customPrint("wallet_id---> ${wallet_id}");
    if (enter_Amount.value > 0) {
      AppsflyerController affiliatedController = Get.put(AppsflyerController());
      CleverTapController cleverTapController = Get.put(CleverTapController());

      UserController _controller = Get.put(UserController());
      Map<String, Object> map = new Map<String, Object>();
      map["USER_ID"] = _controller.profileDataRes != null
          ? _controller.profileDataRes.value.id
          : "";
      map["Amount"] = enter_Amount.value * 100;
      map["Withdrawl Method"] = Withdran_method_type;
      map["Faliure reason"] = '-';
      map["Status"] = 'Success'; //we are in success case
      //map["Message"] = "Withdrawl Amount ";
      map["user_id"] = _controller.profileDataRes != null
          ? _controller.profileDataRes.value.id
          : "";
      map["user_name"] = _controller.profileDataRes != null
          ? _controller.profileDataRes.value.username
          : "";
      cleverTapController.logEventCT(
          EventConstant.EVENT_CLEAVERTAB_Withdrawl, map);
      FirebaseEvent()
          .firebaseEvent(EventConstant.EVENT_FIREBASE_Withdrawl, map);
      FirebaseEvent()
          .firebaseEvent(EventConstant.EVENT_FIREBASE_Withdrawl_test, map);
      affiliatedController.logEventAf(
          EventConstant.EVENT_CLEAVERTAB_Withdrawl, map);
      FaceBookEventController()
          .logEventFacebook(EventConstant.EVENT_CLEAVERTAB_Withdrawl, map);

      if (_controller.maxAmountUserLavWithdraw != null &&
          _controller.maxAmountUserLavWithdraw > 0) {
        var map = {
          "walletId": wallet_id,
          "withdrawMethodId": withdrawMethodId,
          "amount": {"value": (enter_Amount.value * 100)}
        };

        //   showProgress(context, "", true);

        responseWithdraw.value = {};
        withdrawProcessingStatusCode.value = 0;
        var response_final =
            await WebServicesHelper().getWithdrawalClick(map, token, user_id);
        withdrawProcessCompleted.value = "check";
        withdrawProcessingComplete.value = true;
        responseWithdraw.value = jsonDecode(response_final.body);
        withdrawProcessingStatusCode.value = response_final.statusCode;

        Get.put(UserController()).callAllProfileData();

        Future.delayed(const Duration(seconds: 5), () {
          withdrawProcessCompleted.value = "pending";
        });

        WalletPageController cc = Get.put(WalletPageController());

        await cc.getProfileData();

        await cc.getWithdrawSummary();

        if (response_final.statusCode == 200) {
          if (responseWithdraw["status"].compareTo("queued") == 0 ||
              responseWithdraw["status"].compareTo("pending") == 0) {
            mytimer = Timer.periodic(Duration(seconds: 10), (timer) async {
              await getWithdrawRequest();
              for (int index = 0;
                  index < withdrawRequestModelR.value.data.length;
                  index++) {
                if (responseWithdraw["id"].compareTo(
                        "${withdrawRequestModelR.value.data[index].id}") ==
                    0) {
                  if (withdrawRequestModelR.value.data[index].status
                          .compareTo("completed") ==
                      0) {
                    withdrawProcessCompleted.value = "completed";
                    mytimer.cancel();
                  } else if (withdrawRequestModelR.value.data[index].status
                              .compareTo("pending") ==
                          0 ||
                      withdrawRequestModelR.value.data[index].status
                              .compareTo("queued") ==
                          0) {
                    withdrawProcessCompleted.value = "pending";
                  } else {
                    withdrawProcessCompleted.value = "failed";

                    mytimer.cancel();
                  }
                }
              }
            });
          }

          // hideProgress(context);
          if (cc.profileDataRes.value.withdrawMethod != null &&
              cc.profileDataRes.value.isPennyDropFaild() != null &&
              cc.profileDataRes.value.isPennyDropFaild()) {
            /*if (cc.profileDataRes.value.withdrawMethod != null &&
              cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus
                      .status
                      .compareTo("failure") ==
                  0) {*/

            if (cc.profileDataRes.value.withdrawMethod.length >= 2) {
              if (Withdran_method_type.compareTo("BANK") == 0) {
                for (int index = 0;
                    index < cc.profileDataRes.value.withdrawMethod.length;
                    index++) {
                  if (cc.profileDataRes.value.withdrawMethod[index].type
                          .compareTo("bank") ==
                      0) {
                    try {
                      pennyDropFalseFirstTime.value =
                          prefs.getBool("pennyDropFalseFirstTime");

                      if (pennyDropFalseFirstTime.value == null) {
                        prefs.setBool("pennyDropFalseFirstTime", false);
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /* showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      } else if (pennyDropFalseFirstTime.value == true) {
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";
                        /* showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      }
                    } catch (E) {}
                  }
                }
              } else {
                for (int index = 0;
                    index < cc.profileDataRes.value.withdrawMethod.length;
                    index++) {
                  if (cc.profileDataRes.value.withdrawMethod[index].type
                          .compareTo("upi") ==
                      0) {
                    try {
                      pennyDropFalseFirstTime.value =
                          prefs.getBool("pennyDropFalseFirstTime");

                      if (pennyDropFalseFirstTime.value == null) {
                        prefs.setBool("pennyDropFalseFirstTime", false);
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                        /* showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      } else if (pennyDropFalseFirstTime.value == true) {
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                        /*showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      }
                    } catch (E) {}
                  }
                }
              }
            } else {
              try {
                pennyDropFalseFirstTime.value =
                    prefs.getBool("pennyDropFalseFirstTime");

                if (pennyDropFalseFirstTime.value == null) {
                  prefs.setBool("pennyDropFalseFirstTime", false);
                  withdrawProcessingSuccessMessage.value =
                      "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                  /* showWithdrawPennyDrop(
                    context,
                    cc.profileDataRes.value.withdrawMethod[0]
                        .pennyDropCheckStatus.nameAtBank,
                    "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                  );*/
                } else if (pennyDropFalseFirstTime.value == true) {
                  withdrawProcessingSuccessMessage.value =
                      "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                  /*showWithdrawPennyDrop(
                    context,
                    cc.profileDataRes.value.withdrawMethod[0]
                        .pennyDropCheckStatus.nameAtBank,
                    "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                  );*/
                }
              } catch (E) {}
            }
          }

          Map<String, Object> map = new Map<String, Object>();
          map["USER_ID"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.id
              : "";
          map["Amount"] = enter_Amount.value * 100;
          map["Withdrawl Method"] = Withdran_method_type;

          cleverTapController.logEventCT(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);
          FirebaseEvent().firebaseEvent(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success_F, map);

          map["user_id"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.id
              : "";
          map["user_name"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.username
              : "";
          map["Message"] = "Withdrawl Amount ";

          affiliatedController.logEventAf(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);
          FaceBookEventController().logEventFacebook(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);

          //new code withdrawl pending work
          if (_controller.maxAmountUserLavWithdraw != null &&
              _controller.maxAmountUserLavWithdraw > 0) {
            if (_controller.maxAmountUserLavWithdraw >= enter_Amount.value) {
              // withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
              // Fluttertoast.showToast(msg: "Withdrawal Successfully!");
            } else {
              withdrawProcessingSuccessMessage.value =
                  "Your Withdrawal Is Pending!";
              //Fluttertoast.showToast(msg: "Withdrawal Pending!");
              //alertForPendingWithdrawal(context);

              //popup which will redirect to transaction history
            }
          } else if (_controller.maxAmountUserWithdrawVIP.value != null &&
              _controller.maxAmountUserWithdrawVIP.value > 0) {
            if (_controller.maxAmountUserWithdrawVIP.value >=
                enter_Amount.value) {
              //  withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
              // Fluttertoast.showToast(msg: "Withdrawal Successfully!");
            } else {
              withdrawProcessingSuccessMessage.value =
                  "Your Withdrawal Is Pending!";
              //Fluttertoast.showToast(msg: "Withdrawal Pending!");
              //  alertForPendingWithdrawal(context);
              //popup which will redirect to transaction history
            }
          } else if (maxlimit >= enter_Amount.value) {
            //   withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
            // Fluttertoast.showToast(msg: "Withdrawal Successfully!");
          } else {
            withdrawProcessingSuccessMessage.value =
                "Your Withdrawal Is Pending!";
            //Fluttertoast.showToast(msg: "Withdrawal Pending!");
            //alertForPendingWithdrawal(context);
            //popup which will redirect to transaction history
          }
          //end
        } else if (response_final.statusCode == 403) {
          Fluttertoast.showToast(msg: "Authorization Failed".capitalize);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('token');
          await preferences.remove('user_id');
          await preferences.clear();
          Get.offAll(Login());
        } else {
          //  hideProgress(context);
          Map<String, dynamic> response =
              json.decode(response_final.body.toString());
          AppBaseResponseModel appBaseErrorModel =
              AppBaseResponseModel.fromMap(response);

          if (response["errorCode"] == "ERR1620") {
            print("call here data withdraw popUp");
            UserController userController = Get.find();
            /*   Utils().showPopMiniMumDeposit(
                userController.appSettingReponse.value.deposit.minAmount);*/

            withdrawProcessingFailedMessage.value =
                "Please make a ${userController.appSettingReponse.value.deposit.minAmount ~/ 100} deposit to withdraw money from your account";
          }

          if (appBaseErrorModel.errorCode.compareTo("ERR1617") == 0) {
            Map<String, dynamic> map = {
              "User_Limit_exhausted": "User Limit exhausted",
              "USER_ID": user_id,
            };

            AppsflyerController appsflyerController =
                Get.put(AppsflyerController());
            CleverTapController cleverTapController =
                Get.put(CleverTapController());
            appsflyerController.logEventAf(
                EventConstant.EVENT_Penny_Drop_Initiated, map);
            cleverTapController.logEventCT(
                EventConstant.EVENT_Penny_Drop_Initiated, map);
            FirebaseEvent()
                .firebaseEvent(EventConstant.EVENT_Penny_Drop_Initiated_F, map);
            //  withdrawProcessingFailedMessage.value=appBaseErrorModel.error;
            withdrawProcessingFailedMessage.value =
                "Your Name On Your KYC did not match the Name on Your withdrawal method. We have reset your Withdrawal method, Please enter the details which match your pan card";
            //   showWithdrawPennyDropReje(context, appBaseErrorModel.error);
          } else {
            //new work for Withdraw Limit Exhausted per day
            if (appBaseErrorModel.errorCode != null &&
                appBaseErrorModel.errorCode == 'ERR1607') {
              withdrawProcessingFailedMessage.value = appBaseErrorModel.error;
              //Fluttertoast.showToast(msg: 'pop-up');
              // withdrawLimitExhaustedPopup(context, appBaseErrorModel.error);
            } else {
              withdrawProcessingFailedMessage.value = appBaseErrorModel.error;
              // Fluttertoast.showToast(msg: appBaseErrorModel.error);
              //  withdrawLimitExhaustedPopup(context, appBaseErrorModel.error);
            }
          }

          //  Utils().showErrorMessage("", appBaseErrorModel.error);
        }
      } else if (_controller.maxAmountUserWithdrawVIP.value != null &&
          _controller.maxAmountUserWithdrawVIP.value > 0) {
        var map = {
          "walletId": wallet_id,
          "withdrawMethodId": withdrawMethodId,
          "amount": {"value": (enter_Amount.value * 100)}
        };
        responseWithdraw.value = {};
        //  showProgress(context, "", true);

        withdrawProcessingStatusCode.value = 0;
        var response_final =
            await WebServicesHelper().getWithdrawalClick(map, token, user_id);
        withdrawProcessCompleted.value = "check";
        withdrawProcessingComplete.value = true;

        responseWithdraw.value = jsonDecode(response_final.body);
        withdrawProcessingStatusCode.value = response_final.statusCode;
        Get.put(UserController()).callAllProfileData();

        Future.delayed(const Duration(seconds: 5), () {
          withdrawProcessCompleted.value = "pending";
        });

        WalletPageController cc = Get.put(WalletPageController());
        await cc.getProfileData();

        await cc.getWithdrawSummary();

        if (response_final.statusCode == 200) {
          //   hideProgress(context);

          if (responseWithdraw["status"].compareTo("queued") == 0 ||
              responseWithdraw["status"].compareTo("pending") == 0) {
            mytimer = Timer.periodic(Duration(seconds: 7), (timer) async {
              await getWithdrawRequest();
              for (int index = 0;
                  index < withdrawRequestModelR.value.data.length;
                  index++) {
                if (responseWithdraw["id"].compareTo(
                        "${withdrawRequestModelR.value.data[index].id}") ==
                    0) {
                  if (withdrawRequestModelR.value.data[index].status
                          .compareTo("completed") ==
                      0) {
                    withdrawProcessCompleted.value = "completed";
                    mytimer.cancel();
                  } else if (withdrawRequestModelR.value.data[index].status
                              .compareTo("pending") ==
                          0 ||
                      withdrawRequestModelR.value.data[index].status
                              .compareTo("queued") ==
                          0) {
                    withdrawProcessCompleted.value = "pending";
                  } else {
                    withdrawProcessCompleted.value = "failed";
                    mytimer.cancel();
                  }
                }
              }
            });
          }

          if (cc.profileDataRes.value.withdrawMethod != null &&
              cc.profileDataRes.value.isPennyDropFaild() != null &&
              cc.profileDataRes.value.isPennyDropFaild()) {
            if (cc.profileDataRes.value.withdrawMethod.length >= 2) {
              if (Withdran_method_type.compareTo("BANK") == 0) {
                for (int index = 0;
                    index < cc.profileDataRes.value.withdrawMethod.length;
                    index++) {
                  if (cc.profileDataRes.value.withdrawMethod[index].type
                          .compareTo("bank") ==
                      0) {
                    try {
                      pennyDropFalseFirstTime.value =
                          prefs.getBool("pennyDropFalseFirstTime");

                      if (pennyDropFalseFirstTime.value == null) {
                        prefs.setBool("pennyDropFalseFirstTime", false);

                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /* showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      } else if (pennyDropFalseFirstTime.value == true) {
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /* showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      }
                    } catch (E) {}
                  }
                }
              } else {
                for (int index = 0;
                    index < cc.profileDataRes.value.withdrawMethod.length;
                    index++) {
                  if (cc.profileDataRes.value.withdrawMethod[index].type
                          .compareTo("upi") ==
                      0) {
                    try {
                      pennyDropFalseFirstTime.value =
                          prefs.getBool("pennyDropFalseFirstTime");

                      if (pennyDropFalseFirstTime.value == null) {
                        prefs.setBool("pennyDropFalseFirstTime", false);
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /*showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      } else if (pennyDropFalseFirstTime.value == true) {
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /*showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      }
                    } catch (E) {}
                  }
                }
              }
            } else {
              try {
                pennyDropFalseFirstTime.value =
                    prefs.getBool("pennyDropFalseFirstTime");

                if (pennyDropFalseFirstTime.value == null) {
                  prefs.setBool("pennyDropFalseFirstTime", false);
                  withdrawProcessingSuccessMessage.value =
                      "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                  /* showWithdrawPennyDrop(
                    context,
                    cc.profileDataRes.value.withdrawMethod[0]
                        .pennyDropCheckStatus.nameAtBank,
                    "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                  );*/
                } else if (pennyDropFalseFirstTime.value == true) {
                  withdrawProcessingSuccessMessage.value =
                      "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                  /*showWithdrawPennyDrop(
                    context,
                    cc.profileDataRes.value.withdrawMethod[0]
                        .pennyDropCheckStatus.nameAtBank,
                    "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                  );*/
                }
              } catch (E) {}
            }

            /*      try {
              pennyDropFalseFirstTime.value =
                  prefs.getBool("pennyDropFalseFirstTime");
              if (pennyDropFalseFirstTime.value == null) {
             */ /*   Fluttertoast.showToast(
                    msg: "msg${pennyDropFalseFirstTime.value}");*/ /*

                prefs.setBool("pennyDropFalseFirstTime", false);

                showWithdrawPennyDrop(
                  context,
                  cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus
                      .nameAtBank,
                  "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                );
              } else if (pennyDropFalseFirstTime.value == true) {
                showWithdrawPennyDrop(
                  context,
                  cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus
                      .nameAtBank,
                  "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                );
              }
            } catch (E) {}*/
          }

          Map<String, Object> map = new Map<String, Object>();
          map["USER_ID"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.id
              : "";
          map["Amount"] = enter_Amount.value * 100;
          map["Withdrawl Method"] = Withdran_method_type;

          cleverTapController.logEventCT(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);
          FirebaseEvent().firebaseEvent(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success_F, map);

          map["user_id"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.id
              : "";
          map["user_name"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.username
              : "";
          map["Message"] = "Withdrawl Amount ";

          affiliatedController.logEventAf(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);
          FaceBookEventController().logEventFacebook(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);

          //new code withdrawl pending work
          if (_controller.maxAmountUserLavWithdraw != null &&
              _controller.maxAmountUserLavWithdraw > 0) {
            if (_controller.maxAmountUserLavWithdraw >= enter_Amount.value) {
              //    withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
              //  Fluttertoast.showToast(msg: "Withdrawal Successfully!");
            } else {
              //Fluttertoast.showToast(msg: "Withdrawal Pending!");
              withdrawProcessingSuccessMessage.value =
                  "Your Withdrawal Is Pending!";
              //    alertForPendingWithdrawal(context);
              //popup which will redirect to transaction history
            }
          } else if (_controller.maxAmountUserWithdrawVIP.value != null &&
              _controller.maxAmountUserWithdrawVIP.value > 0) {
            if (_controller.maxAmountUserWithdrawVIP.value >=
                enter_Amount.value) {
              // withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
              //   Fluttertoast.showToast(msg: "Withdrawal Successfully!");
            } else {
              withdrawProcessingSuccessMessage.value =
                  "Your Withdrawal Is Pending!";
              //Fluttertoast.showToast(msg: "Withdrawal Pending!");
              //  alertForPendingWithdrawal(context);
              //popup which will redirect to transaction history
            }
          } else if (maxlimit >= enter_Amount.value) {
            //  withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
            //  Fluttertoast.showToast(msg: "Withdrawal Successfully!");
          } else {
            withdrawProcessingSuccessMessage.value =
                "Your Withdrawal Is Pending!";
            //Fluttertoast.showToast(msg: "Withdrawal Pending!");
            //  alertForPendingWithdrawal(context);
            //popup which will redirect to transaction history
          }
          //end
        } else if (response_final.statusCode == 403) {
          Fluttertoast.showToast(msg: "Authorization Failed".capitalize);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('token');
          await preferences.remove('user_id');
          await preferences.clear();
          Get.offAll(Login());
        } else {
          //   hideProgress(context);
          Map<String, dynamic> response =
              json.decode(response_final.body.toString());
          AppBaseResponseModel appBaseErrorModel =
              AppBaseResponseModel.fromMap(response);

          if (response["errorCode"] == "ERR1620") {
            print("call here data withdraw popUp");
            UserController userController = Get.find();

            withdrawProcessingFailedMessage.value =
                "Please make a ${userController.appSettingReponse.value.deposit.minAmount ~/ 100} deposit to withdraw money from your account";

            //    Utils().showPopMiniMumDeposit(userController.appSettingReponse.value.deposit.minAmount);
          }

          if (appBaseErrorModel.errorCode.compareTo("ERR1617") == 0) {
            Map<dynamic, dynamic> map = {
              "User Limit exhausted": "User Limit exhausted",
              "USER_ID": user_id,
            };

            AppsflyerController appsflyerController =
                Get.put(AppsflyerController());
            CleverTapController cleverTapController =
                Get.put(CleverTapController());
            appsflyerController.logEventAf(
                EventConstant.EVENT_Penny_Drop_Initiated, map);
            cleverTapController.logEventCT(
                EventConstant.EVENT_Penny_Drop_Initiated, map);

            FirebaseEvent()
                .firebaseEvent(EventConstant.EVENT_Penny_Drop_Initiated_F, map);
            // withdrawProcessingFailedMessage.value=appBaseErrorModel.error;
            withdrawProcessingFailedMessage.value =
                "Your Name On Your KYC did not match the Name on Your withdrawal method. We have reset your Withdrawal method, Please enter the details which match your pan card";
            // showWithdrawPennyDropReje(context, appBaseErrorModel.error);
          } else {
            withdrawProcessingFailedMessage.value = appBaseErrorModel.error;
            // Fluttertoast.showToast(msg: appBaseErrorModel.error);
          }

          //  Utils().showErrorMessage("", appBaseErrorModel.error);
        }
      } else {
        //if (maxlimit >= enter_Amount.value) {
        var map = {
          "walletId": wallet_id,
          "withdrawMethodId": withdrawMethodId,
          "amount": {"value": (enter_Amount.value * 100)}
        };
        Utils().customPrint("test>>> $map");
        //    showProgress(context, "", true);
        responseWithdraw.value = {};
        withdrawProcessingStatusCode.value = 0;
        var response_final =
            await WebServicesHelper().getWithdrawalClick(map, token, user_id);
        withdrawProcessCompleted.value = "check";
        withdrawProcessingComplete.value = true;
        responseWithdraw.value = jsonDecode(response_final.body);
        withdrawProcessingStatusCode.value = response_final.statusCode;

        Future.delayed(const Duration(seconds: 5), () {
          withdrawProcessCompleted.value = "pending";
        });

        WalletPageController cc = Get.put(WalletPageController());

        await cc.getProfileData();

        await cc.getWithdrawSummary();

        if (response_final.statusCode == 200) {
          // Fluttertoast.showToast(msg: "Withdrawn Successfully");
          //  hideProgress(context);

          if (responseWithdraw["status"].compareTo("queued") == 0 ||
              responseWithdraw["status"].compareTo("pending") == 0) {
            mytimer = Timer.periodic(Duration(seconds: 7), (timer) async {
              await getWithdrawRequest();
              for (int index = 0;
                  index < withdrawRequestModelR.value.data.length;
                  index++) {
                if (responseWithdraw["id"].compareTo(
                        "${withdrawRequestModelR.value.data[index].id}") ==
                    0) {
                  if (withdrawRequestModelR.value.data[index].status
                          .compareTo("completed") ==
                      0) {
                    withdrawProcessCompleted.value = "completed";
                    mytimer.cancel();
                  } else if (withdrawRequestModelR.value.data[index].status
                              .compareTo("pending") ==
                          0 ||
                      withdrawRequestModelR.value.data[index].status
                              .compareTo("queued") ==
                          0) {
                    withdrawProcessCompleted.value = "pending";
                  } else {
                    withdrawProcessCompleted.value = "failed";

                    mytimer.cancel();
                  }
                }
              }
            });
          }

          if (cc.profileDataRes.value.withdrawMethod != null &&
              cc.profileDataRes.value.isPennyDropFaild() != null &&
              cc.profileDataRes.value.isPennyDropFaild()) {
            /* if (cc.profileDataRes.value.withdrawMethod != null &&
              cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus
                      .status
                      .compareTo("failure") ==
                  0) {*/
            if (cc.profileDataRes.value.withdrawMethod.length >= 2) {
              if (Withdran_method_type.compareTo("BANK") == 0) {
                for (int index = 0;
                    index < cc.profileDataRes.value.withdrawMethod.length;
                    index++) {
                  if (cc.profileDataRes.value.withdrawMethod[index].type
                          .compareTo("bank") ==
                      0) {
                    try {
                      pennyDropFalseFirstTime.value =
                          prefs.getBool("pennyDropFalseFirstTime");

                      if (pennyDropFalseFirstTime.value == null) {
                        prefs.setBool("pennyDropFalseFirstTime", false);
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /*showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      } else if (pennyDropFalseFirstTime.value == true) {
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /* showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      }
                    } catch (E) {}
                  }
                }
              } else {
                for (int index = 0;
                    index < cc.profileDataRes.value.withdrawMethod.length;
                    index++) {
                  if (cc.profileDataRes.value.withdrawMethod[index].type
                          .compareTo("upi") ==
                      0) {
                    try {
                      pennyDropFalseFirstTime.value =
                          prefs.getBool("pennyDropFalseFirstTime");

                      if (pennyDropFalseFirstTime.value == null) {
                        prefs.setBool("pennyDropFalseFirstTime", false);

                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /*showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      } else if (pennyDropFalseFirstTime.value == true) {
                        withdrawProcessingSuccessMessage.value =
                            "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[index].pennyDropCheckStatus.nameAtBank ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100) ?? ""}";

                        /*showWithdrawPennyDrop(
                          context,
                          cc.profileDataRes.value.withdrawMethod[index]
                              .pennyDropCheckStatus.nameAtBank,
                          "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                        );*/
                      }
                    } catch (E) {}
                  }
                }
              }
            } else {
              try {
                pennyDropFalseFirstTime.value =
                    prefs.getBool("pennyDropFalseFirstTime");

                if (pennyDropFalseFirstTime.value == null) {
                  prefs.setBool("pennyDropFalseFirstTime", false);
                  withdrawProcessingSuccessMessage.value =
                      "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                  /*showWithdrawPennyDrop(
                    context,
                    cc.profileDataRes.value.withdrawMethod[0]
                        .pennyDropCheckStatus.nameAtBank,
                    "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                  );*/
                } else if (pennyDropFalseFirstTime.value == true) {
                  withdrawProcessingSuccessMessage.value =
                      "Your KYC name does not match your bank name${cc.profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.nameAtBank}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}";

                  /* showWithdrawPennyDrop(
                    context,
                    cc.profileDataRes.value.withdrawMethod[0]
                        .pennyDropCheckStatus.nameAtBank,
                    "${(cc.profileDataRes.value.settings.withdrawRequest.maxLimit ~/ 100) - (cc.pennyDropSummaryAmount.value ~/ 100)}",
                  );*/
                }
              } catch (E) {}
            }
          }

          Map<String, Object> map = new Map<String, Object>();
          map["USER_ID"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.id
              : "";
          map["Amount"] = enter_Amount.value * 100;
          map["Withdrawl Method"] = Withdran_method_type;

          cleverTapController.logEventCT(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);
          FirebaseEvent().firebaseEvent(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success_F, map);

          map["user_id"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.id
              : "";
          map["user_name"] = _controller.profileDataRes != null
              ? _controller.profileDataRes.value.username
              : "";
          map["Message"] = "Withdrawl Amount ";

          affiliatedController.logEventAf(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);
          FaceBookEventController().logEventFacebook(
              EventConstant.EVENT_CLEAVERTAB_Withdrawl_Success, map);

          Get.put(UserController()).callAllProfileData();
          //new code withdrawl pending work
          if (_controller.maxAmountUserLavWithdraw != null &&
              _controller.maxAmountUserLavWithdraw > 0) {
            if (_controller.maxAmountUserLavWithdraw >= enter_Amount.value) {
              // withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
              //Fluttertoast.showToast(msg: "Withdrawal Successfully!");
            } else {
              withdrawProcessingSuccessMessage.value =
                  "Your Withdrawal Is Pending!";
              //Fluttertoast.showToast(msg: "Withdrawal Pending!");
              // alertForPendingWithdrawal(context);
              //popup which will redirect to transaction history
            }
          } else if (_controller.maxAmountUserWithdrawVIP.value != null &&
              _controller.maxAmountUserWithdrawVIP.value > 0) {
            if (_controller.maxAmountUserWithdrawVIP.value >=
                enter_Amount.value) {
              //  withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";

              //Fluttertoast.showToast(msg: "Withdrawal Successfully!");
            } else {
              withdrawProcessingSuccessMessage.value =
                  "Your Withdrawal Is Pending!";
              //Fluttertoast.showToast(msg: "Withdrawal Pending!");
              //  alertForPendingWithdrawal(context);
              //popup which will redirect to transaction history
            }
          } else if (maxlimit >= enter_Amount.value) {
            //  withdrawProcessingSuccessMessage.value="Withdrawal Successfully!";
            // Fluttertoast.showToast(msg: "Withdrawal Successfully!");
          } else {
            withdrawProcessingSuccessMessage.value =
                "Your Withdrawal Is Pending!";
            //Fluttertoast.showToast(msg: "Withdrawal Pending!");
            // alertForPendingWithdrawal(context);
            //popup which will redirect to transaction history
          }
          //end
        } else if (response_final.statusCode == 403) {
          Fluttertoast.showToast(msg: "Authorization Failed".capitalize);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('token');
          await preferences.remove('user_id');
          await preferences.clear();
          Get.offAll(Login());
        } else {
          //   hideProgress(context);
          Map<String, dynamic> response =
              json.decode(response_final.body.toString());
          AppBaseResponseModel appBaseErrorModel =
              AppBaseResponseModel.fromMap(response);

          if (response["errorCode"] == "ERR1620") {
            print("call here data withdraw popUp");
            UserController userController = Get.find();

            withdrawProcessingFailedMessage.value =
                "Please make a ${userController.appSettingReponse.value.deposit.minAmount ~/ 100} deposit to withdraw money from your account";

            //   Utils().showPopMiniMumDeposit(userController.appSettingReponse.value.deposit.minAmount);
          }

          if (appBaseErrorModel.errorCode.compareTo("ERR1617") == 0) {
            withdrawProcessingFailedMessage.value =
                "Your Name On Your KYC did not match the Name on Your withdrawal method. We have reset your Withdrawal method, Please enter the details which match your pan card";
            // showWithdrawPennyDropReje(context, appBaseErrorModel.error);
          } else {
            withdrawProcessingFailedMessage.value = appBaseErrorModel.error;
            // Fluttertoast.showToast(msg: appBaseErrorModel.error);
          }
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Please Enter Amount");
    }
  }

  void alertForPendingWithdrawal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 00),
            height: 175,
            width: MediaQuery.of(context).size.width - 120,
            child: Card(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        Text(
                          "ALERT",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              color: Colors.white),
                        ),
                        Text(""),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Your Withdrawal Is Pending!',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                        color: AppColor().whiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        WalletPageController controller = Get.find();

                        controller.checkTr.value = false;
                        controller.colorPrimary.value = Color(0xFFffffff);
                        controller.colorwhite.value = Color(0xFFe55f19);

                        Navigator.of(context).pop();
                        Get.offAll(() => DashBord(4, ""));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 260,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().button_bg)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("OKAY",
                              style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontFamily: "Roboto")),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  void showWithdrawPennyDropReje(BuildContext context, String test) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 190,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Text(
                      test,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        UserController controller = Get.find();
                        controller.currentIndex.value = 4;
                        Get.offAll(() => DashBord(4, ""));
                        //  Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 235,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().button_bg)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("OKAY",
                              style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontFamily: "Roboto")),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
          ),
        );
      },
    );
  }

  void showWithdrawPennyDrop(BuildContext context, String test, String amount) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 190,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Text(
                      "Your KYC name does not match your bank name${test ?? ""}, \n Please re-upload your KYC \n\n New Withdrawal Limit: ${AppString().txt_currency_symbole} ${amount ?? ""}",
                      //"Your Name On Your KYC did not match the Name on Your withdrawal method. We have reset your Withdrawal method, Please enter the details which match your pan card.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().button_bg)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("OKAY",
                              style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontFamily: "Roboto")),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
          ),
        );
      },
    );
  }

/*  Future<void> alertForPendingWithdrawal(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Alert',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Wrap(
                children: [
                  Text(
                    'Your withdrawal is pending!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  //walletPageController.checkTr.value = false;
                  Get.offAll(() => DashBord(4, ""));
                  Wallet().walletPageController.checkTr.value = false;
                  Wallet().walletPageController.colorPrimary.value = Color(0xFFffffff);
                  Wallet().walletPageController.colorwhite.value = Color(0xFFe55f19);

                  //Wallet().walletPageController.getTransaction();
                  //Wallet().walletPageController.getWithdrawRequest();
                  //Navigator.pop(context, 'Ok');
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
            ],
          );
        })) {
    }
  }*/

  Future<void> getWithdrawalTDS(
      BuildContext context, Map<String, dynamic> param) async {
    showProgress(context, '', true);
    Map<String, dynamic> response =
        await WebServicesHelper().getWithdrawalTDS(token, user_id, param);
    hideProgress(context);

    if (response != null) {
      withdrawalModelTDS.value = WithdrawTDS.fromJson(response);
/*      Utils().customPrint(
          'getWithdrawalTDS: ${withdrawalModelTDS.value.data.tdsInfo.tds.value / 100}');*/
    }
  }

  //new work for Withdraw Limit Exhausted per day
  void withdrawLimitExhaustedPopup(BuildContext context, var str) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 00),
            height: 175,
            width: MediaQuery.of(context).size.width - 120,
            child: Card(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        Text(
                          "ALERT!",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat",
                              color: Colors.white),
                        ),
                        Text(""),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '$str',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          color: AppColor().whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        try {
                          UserController controller = Get.put(UserController());
                          controller.SetFreshchatUser();
                          Freshchat.showFAQ();
                        } catch (e) {}
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 200,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().button_bg)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Connect to support!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    fontFamily: "Montserrat")),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }
}
