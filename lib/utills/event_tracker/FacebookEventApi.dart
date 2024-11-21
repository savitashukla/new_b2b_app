import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../webservices/WebServicesHelper.dart';

class FacebookEventApi extends GetxController {
  SharedPreferences prefs;
  String token, user_id;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
  }

  Future<void> FacebookEventC(
  var paramse) async {
    var response_str = await WebServicesHelper().getFacebookEvent(
      paramse,
      token,
    );

  }
}
