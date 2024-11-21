import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportListEvent/TeamTypeModeR.dart';
import '../../webservices/WebServicesHelper.dart';

class TeamTypeController extends GetxController {
  SharedPreferences prefs;
  String user_id;
  var selectedValue = "duo".obs;
  String token;
  var teamTypeModelR = TeamTypeModelR().obs;
 var teamTypeId="".obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getTeamType();
  }

  Future<void> getTeamType() async {
    SharedPreferences prefs;
    teamTypeModelR.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getTeamType(token);
    if (response != null) {
      teamTypeModelR.value = TeamTypeModelR.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
