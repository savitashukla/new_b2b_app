import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportListEvent/RegistrationMemberListModel.dart';
import '../../model/ESportListEvent/RegistrationMemberListModelTeamType.dart';
import '../../webservices/WebServicesHelper.dart';

class AffiliatedController extends GetxController {
  SharedPreferences prefs;
  String token;
  String user_id;

  Map<String, dynamic> registrationMember;

  var registrationMemberListModel = RegistrationMemberListModel().obs;

  var registrationMemberListTeamType =
      RegistrationMemberListModelTeamType().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    registrationMemberListModel.value = null;
  }

  Future<void> getRegistrationMemberList(String event_id) async {
    registrationMemberListModel.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = await prefs.getString("token");
      user_id = await prefs.getString("user_id");
    }

    Map<String, dynamic> response = await WebServicesHelper()
        .getRegistrationMemberList(token, user_id, event_id);
    if (response != null) {
      registrationMemberListModel.value =
          RegistrationMemberListModel.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getRegistrationMemberListTeamType(String event_id) async {
    registrationMemberListTeamType.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = await prefs.getString("token");
      user_id = await prefs.getString("user_id");
    }

    Map<String, dynamic> response = await WebServicesHelper()
        .getRegistrationMemberList(token, user_id, event_id);
    if (response != null) {
      registrationMemberListTeamType.value =
          RegistrationMemberListModelTeamType.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
