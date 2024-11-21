import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Pocket52Model.dart';
import '../../utills/Utils.dart';
import '../../utills/bridge.dart';
import '../../webservices/WebServicesHelper.dart';
import '../dialog/helperProgressBar.dart';
import '../main/poker/how_to_play.dart';
import '../main/wallet/Wallet.dart';

class Pocket52LoginController extends GetxController {
  SharedPreferences prefs;
  String token;
  String user_id;

  String user_mobileNo;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    user_mobileNo = prefs.getString("user_mobileNo");

    if (user_id != null && user_id != '') {
      // autoPockerWallateCreate();
    }
  }

  Future<void> getLoginWithPocket52(BuildContext context) async {
    if (user_id == null || token == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
      user_mobileNo = prefs.getString("user_mobileNo");
    }

    //showProgress(context, '', true);

    Map<String, String> paramse = {"phoneNumber": user_mobileNo};

    Map<String, dynamic> responsestr =
        await WebServicesHelper().loginPocket52(token, user_id, paramse);
    //hideProgress(context);
    if (responsestr != null) {
      //print("poker exhausted${responsestr["isThirdPartyLimitExhausted"]}");
      if (responsestr["isThirdPartyLimitExhausted"] != null &&
          responsestr["isThirdPartyLimitExhausted"]) {
        Utils.alertLimitExhausted();
        return true;
      } else {
        Pocket52Model _pocket52Model = Pocket52Model.fromJson(responsestr);
        if (_pocket52Model != null && _pocket52Model.d != null) {
          // print("BB Url is: ${ballbaziModel.webViewUrl}");
          // Get.toNamed(Routes.ballbaziGame,arguments: ballbaziModel.webViewUrl);

          final Map<String, String> data = {
            "token": _pocket52Model.d.getToken(),
            "url": _pocket52Model.d.kv.getUrl(),
            "user_id": user_id,
          };
          String reposnenative = await NativeBridge.callOpenPocket52(data);
          Utils().customPrint("data====> ${reposnenative}");
          try {
            switch (reposnenative) {
              case "OPEN_LEADER_BOARD":
                Get.to(() => PokerHowToPlayWebview(ApiUrl.URL_CMS_PLAY_POCKER));
                //     Utils.launchURLApp(ApiUrl.URL_CMS_PLAY_POCKER);
                break;
              case "Click_LobbyName_Selected":
                break;
              case "click_helpdesk_profile":
                Utils.launchURLApp(ApiUrl.URL_CMS_HOW_TO_PLAY);
                break;
              case "click_icon_wallet":
                Utils().customPrint("click_icon_wallet=====================");
                UserController controller = Get.find();
                controller.currentIndex.value = 4;
                controller.getWalletAmount();
                Get.offAll(() => DashBord(4, ""));

                break;

              case "click_add_amount":
                UserController controller = Get.find();
                controller.currentIndex.value = 4;
                Wallet walletIns = new Wallet();
                //walletIns.showBottomSheetAddAmount(context);
                controller.getWalletAmount();
                Utils().customPrint("click_add_amount=====================");
                Get.offAll(() => DashBord(4, ""));
                break;
              default:
                Utils()
                    .customPrint("click_buyin_success=====================>");
                if (reposnenative.contains("click_buyin_success")) {
                  // final split = reposnenative.split(',');
                  // Map<String, dynamic> map  = json.decode(split[1]);
                  // Fluttertoast.showToast(msg: " ${map['game']}");
                  Utils().customPrint(
                      "click_buyin_success=====================>true");
                } else {
                  Utils().customPrint(
                      "click_buyin_success=====================>false");
                }

                break;
            }
          } catch (e) {
            //code
          }
          Utils().customPrint("responseFromNative== ${reposnenative}");
        } else {
          // Fluttertoast.showToast(msg: "Some Error");
        }
      }
    } else {
      // hideProgress(context);
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

/*  Future<void> autoPockerWallateCreate() async {
    Map<String, String> paramse = {"phoneNumber": user_mobileNo};

    Map<String, dynamic> responsestr =
        await WebServicesHelper().loginPocket52(token, user_id, paramse);
    if (responsestr != null) {
      Pocket52Model _pocket52Model = Pocket52Model.fromJson(responsestr);
      if (_pocket52Model != null &&
          _pocket52Model.d != null &&
          _pocket52Model.d.kv.getUrl() != null) {
        final Map<String, String> data = {
          "token": _pocket52Model.d.getToken(),
          "url": _pocket52Model.d.kv.getUrl(),
        };

        Utils().customPrint("AutoWallaterCreatePocker==");
      }
    }
  }*/
}
