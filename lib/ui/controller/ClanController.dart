import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ClanModel.dart';
import 'package:gmng/model/responsemodel/ClanResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportsEventList.dart';
import '../../model/InGame/InGameCheck.dart';
import '../../model/ProfileModel/TeamGetModelR.dart';
import '../../model/responsemodel/LeaderBoardResponse.dart';
import '../../utills/Utils.dart';
import '../../webservices/WebServicesHelper.dart';

class ClanController extends GetxController {
  TextEditingController inGameName = new TextEditingController();
  TextEditingController iNGameId = new TextEditingController();
  TextEditingController teamName = new TextEditingController();

  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;

  var colorPrimaryAllTime = Color(0xFFe55f19).obs;
  var colorwhiteMonthly = Color(0xFFeffffff).obs;
  var checkTr = true.obs;
  var allClan = true.obs;
  var selectedClan = ClanModel().obs;
  SharedPreferences prefs;
  String token, user_id;
  var clanList = ClanResponseModel().obs;
  var clanJoinedList = ClanResponseModel().obs;

  var esportEventListModel = ESportEventListModel().obs;
  var esportJoinedList = ESportEventListModel().obs;
  var inGameCheckModel = InGameCheck().obs;
  var matches = true.obs;
  var mapKey = {}.obs;
  var teamlist = TeamGetModelR().obs;
  var leaderboardMonth = true.obs;
  var selected_team = "".obs;
  var selected_team_id = "".obs;
  var result = "Slide to join Clan".tr.obs;

  var gameListSelectedColor = 0.obs;

  //leaderboard
  var leaderBoardList = LeaderBoardResponse().obs;
  Rx<LeaderBoardModel> user1 = new LeaderBoardModel().obs;
  Rx<LeaderBoardModel> user2 = new LeaderBoardModel().obs;
  Rx<LeaderBoardModel> user3 = new LeaderBoardModel().obs;
  RxList leaderBoardlistNew = new List<LeaderBoardModel>().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    esportEventListModel.value = null;
    if (user_id != null && user_id != '') {
      getClanList();
      getJoinedClanList();
    }
  }

  Future<void> getClanList() async {
    selectedClan.value = null;
    clanList.value = null;

    Map<String, dynamic> response =
        await WebServicesHelper().getClanList(token);
    if (response != null) {
      clanList.value = ClanResponseModel.fromJson(response);
    } else {
      // hideLoader();
      //Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getJoinedClanList() async {
    selectedClan.value = null;
    clanJoinedList.value = null;


    if(token!=null && user_id!=null)
      {

        Map<String, dynamic> response =
        await WebServicesHelper().getJoinedClanList(token, user_id);
        if (response != null) {
          clanJoinedList.value = ClanResponseModel.fromJson(response);
          if (clanJoinedList.value.data != null &&
              clanJoinedList.value.data.length > 0 &&
              selectedClan.value != null) {
            for (var i = 0; i < clanJoinedList.value.data.length; i++) {
              if (selectedClan.value.id == clanJoinedList.value.data[i].id) {
                selectedClan.value.is_slected = true;
                Utils().customPrint(
                    "Selected value selectedClan ${selectedClan.value.is_slected}");
              }
            }
          }
        } else {
          // hideLoader();
          //  Fluttertoast.showToast(msg: "Some Error");
        }

      }



  }

  getCurrentdate() {
    final now = DateTime.now().toUtc();

    return now;
  }

  subtractDate(DateTime startDate) {
    var apiDate = startDate.toUtc();
    Utils().customPrint("api date $apiDate");
    var utcCurrentDate = DateTime.now().toUtc();
    Utils().customPrint("current system date $utcCurrentDate");
    var difference = apiDate.difference(utcCurrentDate.toUtc()).inSeconds;
    //Fluttertoast.showToast(msg: difference.toString());
    return difference;
  }

  Future<void> updateSelectedClan() {
    //Utils().customPrint("Selected value selectedClan ${selectedClan.value.id}");
    if (clanJoinedList.value != null &&
        clanJoinedList.value.data != null &&
        clanJoinedList.value.data.length > 0 &&
        selectedClan != null &&
        selectedClan.value != null) {
      for (var i = 0; i < clanJoinedList.value.data.length; i++) {
        if (selectedClan.value.id == clanJoinedList.value.data[i].id) {
          selectedClan.value.is_slected = true;
          Utils().customPrint(
              "Selected value selectedClan ${selectedClan.value.is_slected}");
        }
      }
    }
  }

  Future<void> getEventList(String id, String clanId) async {
    esportEventListModel.value = null;
    Utils().customPrint("All Ballel List=-=====");
    Map<String, dynamic> response = await WebServicesHelper()
        .getESportEventList(token, id, clanId, Utils().getCurrentdateString(),
            Utils().getCurrentdateString(), user_id, "", "", "active");
    if (response != null) {
      Utils().customPrint("All Ballel List=-=====");
      esportEventListModel.value =
          ESportEventListModel.fromJson(response, "", true, false);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getJoinedContestList(
    String gameid,
  ) async {
    esportJoinedList.value = null;
    String clan_Id = "";
    if (selectedClan == null) {
      return;
    }
    clan_Id = selectedClan.value.id;
    Map<String, dynamic> response = await WebServicesHelper()
        .getJoinedContestList(token, gameid, clan_Id, user_id, "", "active");
    if (response != null) {
      Utils().customPrint("Joined List=-=====");
      esportJoinedList.value =
          ESportEventListModel.fromJson(response, "", false, false);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> UserJoinedClanApply() async {
    String clan_Id = "";
    if (selectedClan == null) {
      return;
    }
    clan_Id = selectedClan.value.id;
    Map<String, dynamic> response =
        await WebServicesHelper().UserJoinedClan(token, user_id, clan_Id);
    if (response != null) {
      Utils().customPrint("Apply for join =-=====");
      Fluttertoast.showToast(msg: "Joined Successfully".tr);
      getJoinedClanList();
      //esportJoinedList.value = ESportEventListModel.fromJson(response, false);
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> userRemoveClan() async {
    String clan_Id = "";
    if (selectedClan == null) {
      return;
    }
    clan_Id = selectedClan.value.id;
    final response_final =
        await WebServicesHelper().userRemoveClan(token, user_id, clan_Id);
    if (response_final.statusCode == 200) {
      selectedClan.value.is_slected = false;
      Fluttertoast.showToast(msg: "Remove Successfully");
      getJoinedClanList();
      updateSelectedClan();
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<Map> getLeaderBoardByClanid(
      String clanid, String gameId, String type) async {
    Utils().customPrint("clanid  ${clanid}");
    leaderBoardList.value = null;
    user1.value = null;
    user2.value = null;
    user3.value = null;

    Map<String, dynamic> response = await WebServicesHelper()
        .getLeaderBoarData(token, user_id, clanid, gameId, type);
    leaderBoardlistNew.clear();
    // if (response != null) {
    //   leaderBoardList.value = LeaderBoardResponse.fromJson(response);
    // }
    if (response != null) {
      var leaderBoardResponse = LeaderBoardResponse.fromJson(response);
      if (leaderBoardResponse != null &&
          leaderBoardResponse.data != null &&
          leaderBoardResponse.data.length > 0) {
        List<LeaderBoardModel> data = new List();
        for (int i = 0; i < leaderBoardResponse.data.length; i++) {
          if (i == 0) {
            user1.value = leaderBoardResponse.data[i];
          } else if (i == 1) {
            user2.value = leaderBoardResponse.data[i];
          } else if (i == 2) {
            user3.value = leaderBoardResponse.data[i];
          } else {
            data.add(leaderBoardResponse.data[i]);
          }
        }
        leaderBoardlistNew.value = data;
      }
    }
    return response;
  }
}
