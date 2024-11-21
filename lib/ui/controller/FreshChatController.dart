import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FreshChatController extends GetxController {
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

    Freshchat.init(ApiUrl.freshchat_appid,
        ApiUrl.freshchat_appkey,ApiUrl.freshchat_domain);
  }





}
