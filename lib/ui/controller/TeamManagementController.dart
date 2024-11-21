import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ProfileModel/TeamGetModelR.dart';
import 'package:gmng/ui/controller/ProfileController.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/InGame/InGameCheck.dart';
import '../../webservices/WebServicesHelper.dart';

class TeamManagementController extends GetxController {
  SharedPreferences prefs;
  String token;
  String user_id;
  String user_mobileNO = "";
  TextEditingController teamMemberNumber = new TextEditingController();
  ProfileController controller = Get.put(ProfileController());
  TextEditingController inGameName = new TextEditingController();
  TextEditingController iNGameId = new TextEditingController();
  var inGameCheckModel = InGameCheck().obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    user_mobileNO = prefs.getString("user_mobileNo");
    super.onInit();
    //getINGameCheck(game_id);
  }

  Future<Map> getAddTeamMember(String team_id) async {
    final param = {
      "mobileNo": teamMemberNumber.text,
    };
    Map<String, dynamic> response = await WebServicesHelper()
        .getAddTeamMember(param, token, user_id, team_id);
    if (response != null) {}
  }

  Future<Map> getDeleteTeamMember(String team_id, String member_id) async {
    Map<String, dynamic> response = await WebServicesHelper()
        .getDeleteTeamMember(token, user_id, team_id, member_id);
    if (response != null) {
      /* String newTeam = "status:incomplete";

      controller.onStartMethod();*/
    }
  }

  Future<Map> getINGameCheck(String game_id) async {
    Utils().customPrint("game_id ===>${game_id}");
    Utils().customPrint("user_id ===>${user_id}");
    inGameCheckModel.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getInGameCheck(token, user_id, game_id);
    if (response != null) {
      inGameCheckModel.value = InGameCheck.fromJson(response);
      // mapKey["Enter you InGameID"].value=inGameCheckModel.value.inGameId;
      // mapKey["Enter you InGameName"]=inGameCheckModel.value.inGameName;
      return response;
    } else {
      return null;
    }
  }

  Future<Map> getINGamePost(
      String game_id, String team_id, List<Members> memberV) async {
    final param = {"inGameId": iNGameId.text, "inGameName": inGameName.text};
    Map<String, dynamic> response =
        await WebServicesHelper().getInGamePost(param, token, user_id, game_id);
    if (response != null) {
      getAcceptTeamMember(team_id, memberV);
    }

    return response;
  }

  Future<Map> getAcceptTeamMember(String team_id, List<Members> memberV) async {
    String member_id = "";

    for (int index = 0; memberV.length > index; index++) {
      if (user_id.compareTo(memberV[index].userId.id) == 0) {
        member_id = await memberV[index].id;
      }
    }

    final param = {
      "status": "accepted",
    };
    Map<String, dynamic> response = await WebServicesHelper()
        .getAcceptTeamMember(param, token, user_id, team_id, member_id);
    if (response != null && response['statusCode'] == 200) {
      Fluttertoast.showToast(msg: response.toString());

      return response;
    }
  }

  Future<Map> getRejectedTeamMember(
      String team_id, List<Members> memberV) async {
    String member_id = "";

    for (int index = 0; memberV.length > index; index++) {
      if (user_id.compareTo(memberV[index].userId.id) == 0) {
        member_id = await memberV[index].id;
      }
    }

    final param = {
      "status": "rejected",
    };
    Map<String, dynamic> response = await WebServicesHelper()
        .getRejectedTeamMember(param, token, user_id, team_id, member_id);
    if (response != null && response['statusCode'] == 200) {
      controller.onStartMethod();

      Fluttertoast.showToast(msg: response.toString());
      return response;
    }
  }
}
