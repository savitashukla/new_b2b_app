import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ESportListEvent/PerspectiveModelR.dart';
import 'package:gmng/model/ESportListEvent/RegistrationMemberJoinedCheckTeamTypeM.dart';
import 'package:gmng/model/InGame/InGameCheck.dart';
import 'package:gmng/model/UserLobboyModel.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportListEvent/MapModelR.dart';
import '../../model/ESportListEvent/RegistrationMemberJoinedCheck.dart';
import '../../model/ESportsEventList.dart';
import '../../model/ProfileModel/TeamGetModelR.dart';
import '../../webservices/WebServicesHelper.dart';
import '../main/esports/Affiliated_Contest.dart';
import '../main/esports/JoinedBattlesDetails.dart';
import '../main/ludo_king/LudoKingController.dart';

class ESportsController extends GetxController {
  String game_id;
  String user_id;
  String event_id = "";
  bool teamNotActive = true;


  ESportsController(this.game_id, this.event_id);

  String statusType = "active";
  var mapKey = {}.obs;
  var inGameIdVar = "".obs;
  var inGameNameVar = "".obs;
  TextEditingController password = new TextEditingController();
  TextEditingController inGameName = new TextEditingController();
  TextEditingController iNGameId = new TextEditingController();
  TextEditingController teamName = new TextEditingController();

  var esportEventListModel = ESportEventListModel().obs;
  var esportJoinedList = ESportEventListModel().obs;

  var registrationMemberJoinedCheckM = RegistrationMemberJoinedCheckM().obs;

  var registrationMemberJoinedCheckTeamTypeM =
      RegistrationMemberJoinedCheckTeamTypeM().obs;

  var mapMopdelR = MapMopdelR().obs;
  var perspectiveModelR = PerspectiveModelR().obs;
  var inGameCheckModel = InGameCheck().obs;
  var teamlist = TeamGetModelR().obs;
  var selected_team = "".obs;
  var selected_team_id = "".obs;
  var remainingDayData = .6.obs;
  var fillter_time = "".obs;
  var fillter_map_type = "".obs;
  var fillter_price_minimum = "0".obs;
  var fillter_price_maximum = "10000".obs;
  var fillter_price_range = "".obs;

  LudoKingController ludo_king_controller = Get.put(LudoKingController());

  // Rx<ContestModel> selected_contest = null.obs;
  // Rx<ContestModel> selected_contest = (null as ContestModel).obs;
   var selected_contest=ContestModel().obs;
/*
  RxList<UserRegistrations> selected_userRegistrations = [].obs;
*/
  RxList<UserRegistrations> selected_userRegistrations = <UserRegistrations>[].obs;

  var mapList = [
    "Erangel",
    "All Weapon",
    "Livik",
    "Miramar",
    "All",
    "Vikendi",
    "Sanhok"
  ].obs;
  SharedPreferences prefs;

  String token;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    //Utils().getTodayDates();
    getESportsEventList(game_id);

    getINGameCheck(game_id);
    getJoinedContestList(game_id);
    getMap("");
    Utils().customPrint("event_id==>${event_id}");
  }

//status-> inactive, active, completed, resultDeclated, winningDistributed
  Future<void> getESportsEventList(String id) async {
    esportEventListModel.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    var gameMapId = "";
    var minPrize = "0";
    var maxPrize = "100000";

    if (id.isEmpty) {
      id = game_id;
    }

    if (mapMopdelR.value != null &&
        mapMopdelR != null &&
        mapMopdelR.value.data != null &&
        mapMopdelR.value.data.length > 0) {
      if (!fillter_map_type.value.isEmpty) {
        gameMapId = mapMopdelR.value.data[int.parse(fillter_map_type.value)].id;
      }
      Utils().customPrint("gameMapId==>" + gameMapId);
    }
    if (!fillter_price_range.value.isEmpty) {
      switch (fillter_price_range.value) {
        case "1":
          minPrize = "0";
          maxPrize = "100";
          break;
        case "2":
          minPrize = "101";
          maxPrize = "500";
          break;
        case "3":
          minPrize = "501";
          maxPrize = "1000";
          break;
        case "4":
          minPrize = "1001";
          maxPrize = "5000";
          break;
      }
    }

    Map<String, dynamic> response = await WebServicesHelper()
        .getESportEventList(
            token,
            id,
            "",
            Utils().getCurrentdateString(),
            Utils().getCurrentdateString(),
            user_id,
            gameMapId,
            minPrize,
            "active");
    //Utils().getTodayDates()

    if (response != null) {
      esportEventListModel.value =
          ESportEventListModel.fromJson(response, event_id, true, false);
      Utils().customPrint(
          "serverTime============================================================= size ${esportEventListModel.value.data.length}");
      Utils().customPrint(
          "serverTime=============================================================${esportEventListModel.value.meta.serverTime}");
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getRegistrationMemberJoinedCheck(String event_id, String gameid,
      String url, ContestModel contestModel) async {
    registrationMemberJoinedCheckTeamTypeM.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = await prefs.getString("token");
      user_id = await prefs.getString("user_id");
    }

    Map<String, dynamic> response = await WebServicesHelper()
        .getRegistrationMemberJoinedCheck(token, user_id, event_id);

    if (response != null) {
      registrationMemberJoinedCheckM.value =
          RegistrationMemberJoinedCheckM.fromJson(response);
      if (registrationMemberJoinedCheckM.value.status.compareTo("active") ==
          0) {
        Get.to(() => JoinedBattlesDetails(gameid, url, contestModel.id));
      } else {
        Get.to(
            () => Affiliated(contestModel, true, selected_team_id.value, true));
      }
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getRegistrationMemberJoinedCheckTeamType(String event_id,
      String gameid, String url, ContestModel contestModel) async {
    registrationMemberJoinedCheckM.value = null;

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = await prefs.getString("token");
      user_id = await prefs.getString("user_id");
    }

    Map<String, dynamic> response = await WebServicesHelper()
        .getRegistrationMemberJoinedCheck(token, user_id, event_id);

    if (response != null) {
      registrationMemberJoinedCheckTeamTypeM.value =
          RegistrationMemberJoinedCheckTeamTypeM.fromJson(response);

      if (registrationMemberJoinedCheckTeamTypeM.value.members != null) {
        for (int index = 0;
            registrationMemberJoinedCheckTeamTypeM.value.members.length > index;
            index++) {
          if (registrationMemberJoinedCheckTeamTypeM
                  .value.members[index].eventRegistration.status
                  .compareTo("initial") ==
              0) {
            teamNotActive = false;
            break;
          } else {}
        }
      }

      if (teamNotActive) {
        Get.to(() => JoinedBattlesDetails(gameid, url, contestModel.id));
      } else {
        Get.to(
            () => Affiliated(contestModel, true, selected_team_id.value, true));
      }
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  subtractDate(DateTime startDate) {
    var apiDate = startDate.toUtc();
    var apiDate1 = startDate.toUtc();
    var utcCurrentDate = DateTime.now().toUtc();
    Utils().customPrint("current system date $utcCurrentDate");
    var difference = apiDate.difference(utcCurrentDate.toUtc()).inSeconds;
    var differencem = difference * 60;
    return difference;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<void> getJoinedContestList(String gameid) async {
    if (token == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }

    if (gameid.isEmpty) {
      gameid = game_id;
    }
    SharedPreferences prefs;
    esportJoinedList.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getJoinedContestList(token, gameid, "", user_id, "", "active");
    if (response != null) {
      Utils().customPrint("Joined List=-=====");
      //  response.data..sort((a,b)=>a.updatedAt.compareTo(b.updatedAt));

      esportJoinedList.value =
          ESportEventListModel.fromJson(response, "", false, false);

      for (int a = 0; a < (esportJoinedList.value.data.length); a++) {
        if (selected_contest.value != null && esportJoinedList.value.data[a].id!=null) {
          if (selected_contest.value.id
                  .compareTo(esportJoinedList.value.data[a].id) ==
              0) {
            selected_contest.value = esportJoinedList.value.data[a];
            selected_userRegistrations.value = esportJoinedList.value.userRegistrations;

            if (selected_contest.value.rounds != null &&
                selected_contest.value.rounds.length > 0 &&
                selected_userRegistrations.value != null &&
                selected_userRegistrations.value.length <= 0 ||
                !selected_contest.value.isCompletedJoined(selected_contest.value.id, selected_userRegistrations.value) ||
                selected_contest.value.getUserRoundRoomId(selected_userRegistrations.value).isEmpty) {
              // ludo_king_controller.Confirm_test.value = "REGISTERED";
            } else {
              ludo_king_controller.Confirm_test.value = "GO TO GAME";
            }

          } else {}
        }
      }
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<Map> getINGamePost(String game_id) async {
    final param = {
      "inGameId": mapKey["Enter your InGameID"],
      "inGameName": mapKey["Enter your InGameName"]
    };
    Map<String, dynamic> response =
        await WebServicesHelper().getInGamePost(param, token, user_id, game_id);
    return response;
  }

  Future<Map> getINGameCheck(String game_id) async {
    Utils().customPrint("game_id ===>${game_id}");
    Utils().customPrint("user_id ===>${user_id}");
    inGameCheckModel.value = null;

    if (token == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response =
        await WebServicesHelper().getInGameCheck(token, user_id, game_id);
    if (response != null) {
      inGameCheckModel.value = InGameCheck.fromJson(response);
      mapKey['Enter your InGameID'] = inGameCheckModel.value.inGameId;
      mapKey['Enter your InGameName'] = inGameCheckModel.value.inGameName;
      iNGameId.text = inGameCheckModel.value.inGameId;
      inGameName.text = inGameCheckModel.value.inGameName;
      return response;
    } else {
      return response;
    }
  }

  Future<Map> addIngameId(String game_id) async {
    final param = {
      "inGameId": mapKey["Enter your InGameID"],
      "inGameName": mapKey["Enter your InGameName"]
    };
    Map<String, dynamic> response =
        await WebServicesHelper().getInGamePost(param, token, user_id, game_id);
    if (response != null) {
      inGameCheckModel.value = InGameCheck.fromJson(response);
      mapKey['Enter your InGameID'] = inGameCheckModel.value.inGameId;
      mapKey['Enter your InGameName'] = inGameCheckModel.value.inGameName;
      iNGameId.text = inGameCheckModel.value.inGameId;
      inGameName.text = inGameCheckModel.value.inGameName;
      return response;
    } else {
      return response;
    }
  }

  Future<Map> updateIngameId() async {
    final param = {
      "inGameId": mapKey["Enter your InGameID"],
      "inGameName": mapKey["Enter your InGameName"]
    };
    Map<String, dynamic> response = await WebServicesHelper().updateIngameId(
        param, token, user_id, game_id, inGameCheckModel.value.id);
    if (response != null) {
      inGameCheckModel.value = InGameCheck.fromJson(response);
      mapKey['Enter your InGameID'] = inGameCheckModel.value.inGameId;
      mapKey['Enter your InGameName'] = inGameCheckModel.value.inGameName;
      iNGameId.text = inGameCheckModel.value.inGameId;
      inGameName.text = inGameCheckModel.value.inGameName;
      return response;
    } else {
      return response;
    }
  }

  Future<void> getMap(String id) async {
    mapMopdelR.value = null;

    if (token == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getMap(token, id, statusType);
    // Fluttertoast.showToast(msg: responsestr.toString());

    if (responsestr != null) {
      mapMopdelR.value = MapMopdelR.fromJson(responsestr);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getPerspective(String id) async {
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getPerspective(token, id, statusType);
    if (responsestr != null) {
      perspectiveModelR.value = PerspectiveModelR.fromJson(responsestr);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  //used in eSports JoinContest
  getCurrentdate() {
    final now = DateTime.now().toUtc();
    //Utils().getStartTimeHHMMSS(esportEventListModel.value.meta.serverTime);
    if (esportEventListModel.value!=null && esportEventListModel.value.meta!=null && esportEventListModel.value.meta.serverTime != null &&
        esportEventListModel.value.meta.serverTime != '') {
      //print('getCurrentdate server ${Utils().getStartTimeHHMMSS(esportEventListModel.value.meta.serverTime)}');
      DateTime dateTime =
          DateTime.parse(esportEventListModel.value.meta.serverTime);
      Utils().customPrint(
          'getCurrentdate server datetime ${esportEventListModel.value.meta.serverTime}');
      return dateTime;
    } else {
      Utils().customPrint('getCurrentdate local ${now}');
      return now;
    }
  }
}
