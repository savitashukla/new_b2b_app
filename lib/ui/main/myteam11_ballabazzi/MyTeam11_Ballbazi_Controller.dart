import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/routes/routes.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';
import '../../../model/BallbaziModel.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../dialog/helperProgressBar.dart';
import 'MyTeam11BallebaaziWebview.dart';



class MyTeam11_Ballbazi_Controller extends GetxController {
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

  Future<void> getLoginTeam11BB(BuildContext context,String GameId) async {
    showProgress(context, '', true);



        SharedPreferences     prefs = await SharedPreferences.getInstance();
        token = prefs.getString("token");
        user_id = prefs.getString("user_id");


    Map<String,dynamic> paramseData={"gameId":GameId};

    Map<String, dynamic> responsestr =
        await WebServicesHelper().getTeam11BB(token, user_id,paramseData);
    if (responsestr != null) {
      hideProgress(context);

      if (responsestr["isThirdPartyLimitExhausted"]!=null && responsestr["isThirdPartyLimitExhausted"]) {

        Utils.alertLimitExhausted();
        return true;
      } else {
        if (responsestr["url"] != null) {
          Navigator.push(
            navigatorKey.currentState.context,
            MaterialPageRoute(
              builder: (BuildContext context) => MyTeam11BallebaaziWebview(
                  responsestr["url"]),
            ),
          );
         // Get.toNamed(Routes.ballbaziGame, arguments: ballbaziModel.webViewUrl);
        } else {
          // Fluttertoast.showToast(msg: "Some Error");
        }
      }
    } else {
      hideProgress(context);
     Fluttertoast.showToast(msg: "Some Thing Went Wrong");
    }
  }
}
