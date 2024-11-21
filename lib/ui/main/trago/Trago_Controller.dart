import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../dialog/helperProgressBar.dart';
import 'TragoWebview.dart';

class Trago_Controller extends GetxController {
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

  Future<void> getLoginTrago(BuildContext context, String GameId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    showProgress(context, '', true);
    Map<String, dynamic> paramseData = {"gameId": GameId, "latitude": Utils().latitude.value,
      "longitude": Utils().longitude.value};
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getTragoUrl(token, user_id, paramseData);
    if (responsestr != null) {
      hideProgress(context);

      print("fantsy exh.. ${responsestr["isThirdPartyLimitExhausted"]}");

      if (responsestr["isThirdPartyLimitExhausted"] != null &&
          responsestr["isThirdPartyLimitExhausted"]) {
        Utils.alertLimitExhausted();
        return true;
      } else {
        if (responsestr["webViewUrl"] != null) {
          Navigator.push(
            navigatorKey.currentState.context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  TragoWebview(responsestr["webViewUrl"]),
            ),
          );

          // Get.toNamed(Routes.ballbaziGame, arguments: ballbaziModel.webViewUrl);
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
