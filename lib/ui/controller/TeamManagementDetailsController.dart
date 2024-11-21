import 'package:get/get.dart';
import 'package:gmng/model/ProfileModel/TeamDetailsModelR.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportsEventList.dart';
import '../../webservices/WebServicesHelper.dart';

class TeamManagementDetailsController extends GetxController {
  SharedPreferences prefs;
  String user_id;
  String token;
  var teamMemberListId = "".obs;
  var teamDetailsModelR = TeamDetailsModelR().obs;
  var teamDetailsModelRIncomplete = TeamDetailsModelR().obs;
  var teamCaptainLogin = false.obs;
  var esportJoinedList = ESportEventListModel().obs;
  var esportJoinedListUp = ESportEventListModel().obs;
  var team_upcoming=true.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    getJoinedContestList("");
    getJoinedContestListUp("");
  }

  Future<void> getTeamDetails(String teamid) async {
    teamDetailsModelR.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = await prefs.getString("token");
      user_id = await prefs.getString("user_id");
    }

    Map<String, dynamic> response = await WebServicesHelper()
        .getTeamsDetails(token, user_id, teamid);

    if (response != null) {
      teamDetailsModelR.value = TeamDetailsModelR.fromJson(response);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<Map> getDeleteTeam(String team_id) async {
    Map<String, dynamic> response =
        await WebServicesHelper().getTeamDelete(token, user_id, team_id);
  }
  Future<void> getJoinedContestList(String gameid) async {
    SharedPreferences prefs;
    esportJoinedList.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getJoinedContestList(token, gameid, "", user_id, teamMemberListId.value,"winningDistributed");
    if (response != null) {
      Utils().customPrint("Joined List=-=====");

      esportJoinedList.value = ESportEventListModel.fromJson(response,"", false,false);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getJoinedContestListUp(String gameid) async {
    SharedPreferences prefs;
    esportJoinedListUp.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getJoinedContestList(token, gameid, "", user_id, teamMemberListId.value,"active");
    if (response != null) {
      Utils().customPrint("joined List upcoming=-=====");

      esportJoinedListUp.value = ESportEventListModel.fromJson(response,"", false,false);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
