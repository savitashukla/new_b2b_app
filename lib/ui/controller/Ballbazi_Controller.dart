import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/routes/routes.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/BallbaziModel.dart';
import '../../webservices/WebServicesHelper.dart';
import '../dialog/helperProgressBar.dart';

class BallbaziLoginController extends GetxController {
  SharedPreferences prefs;
  String token;
  String user_id;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
  }

  Future<void> getLoginBallabzi(BuildContext context) async {
    showProgress(context, '', true);

    Map<String, dynamic> responsestr =
        await WebServicesHelper().BallbaziLogin(token, user_id);
    if (responsestr != null) {
      hideProgress(context);

      //print("fantsy exh.. ${responsestr["isThirdPartyLimitExhausted"]}");

      if (responsestr["isThirdPartyLimitExhausted"]!=null&&responsestr["isThirdPartyLimitExhausted"]) {

        Utils.alertLimitExhausted();
        return true;
      } else {
        BallbaziModel ballbaziModel = BallbaziModel.fromJson(responsestr);
        if (ballbaziModel != null && !ballbaziModel.webViewUrl.isEmpty) {
          Utils().customPrint("BB Url is: ${ballbaziModel.webViewUrl}");

          Get.toNamed(Routes.ballbaziGame, arguments: ballbaziModel.webViewUrl);
        } else {
          // Fluttertoast.showToast(msg: "Some Error");
        }
      }
    } else {
      hideProgress(context);
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
