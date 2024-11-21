import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ProfileModel/TeamGetModelR.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ESportListEvent/TeamTypeModeR.dart';
import '../../model/ESportsEventList.dart';
import '../../webservices/WebServicesHelper.dart';

class ProfileController extends GetxController {
  SharedPreferences prefs;

  String token;
  var teamTypeModelR = TeamTypeModelR().obs;
  List<TeamTypeModel> teamTypeList = new List<TeamTypeModel>().obs;
  String user_id;
  var teamGetModel = TeamGetModelR().obs;
  var teamGetModelNewTeam = TeamGetModelR().obs;
  var teamGetModelInvites = TeamGetModelR().obs;
  var esportJoinedList = ESportEventListModel().obs;
  var mapKey = {}.obs;
  var gameTypeVar = "".obs;
  var noOfPlayer = "".obs;
  var teamNameVar = ''.obs;
  var selectedValue = "".obs;
  var selectedValue2 = 1.obs;
  var teamTypeId = ''.obs;
  var selectedMemberType = "".obs;
  var gameId = ''.obs;

  var isInvited = "".obs;
  var game_id_teams = "".obs;
  var team_id_teams = "".obs;
  var isCaptain = "".obs;
  var newTeam = "".obs;
  var my_team = "";

  var selectedValueGame = "".obs;
  var selectedValueGameCreate = "".obs;
  var selectedValueTeamCreate = "".obs;

  TextEditingController teamName = new TextEditingController();
  var path_call;

  var imageFile;

  PickedFile pickedFile;

  var image;

  Rx<File> iamges1 = File('file.txt').obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    onStartMethod();
  }

  onStartMethod() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    /*this code comment by vishnu we remove team managment from profile section */
    getTeamType();
    getTeamS("", "", "", "", "");
    newTeam.value = "status:incomplete";
    getTeamNew("", "", "", "", newTeam.value);

    isInvited.value = "isInvited=true";
    getTeamInVites(isInvited.value, "", "", "", "");
    // getJoinedContestList("");
  }

  Future<void> getTeamS(String invite, String game_id_c, String team_id,
      String isCaptain, String newTeam) async {
    teamGetModel.value = null;
    Map<String, dynamic> response = await WebServicesHelper().getTeams(
        token, user_id, invite, game_id_c, team_id, isCaptain, newTeam);
    if (response != null) {
      teamGetModel.value = TeamGetModelR.fromJson(response);
    } else {
      //Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getTeamInVites(String invite, String game_id_c, String team_id,
      String isCaptain, String newTeam) async {
    teamGetModelInvites.value = null;
    Map<String, dynamic> response = await WebServicesHelper().getTeams(
        token, user_id, invite, game_id_c, team_id, isCaptain, newTeam);
    if (response != null) {
      teamGetModelInvites.value = TeamGetModelR.fromJson(response);
    } else {
      //Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getTeamNew(String invite, String game_id_c, String team_id,
      String isCaptain, String newTeam) async {
    teamGetModelNewTeam.value = null;
    Map<String, dynamic> response = await WebServicesHelper().getTeams(token,
        user_id, invite, game_id_c, team_id, isCaptain, "status=incomplete");
    if (response != null) {
      teamGetModelNewTeam.value = TeamGetModelR.fromJson(response);
    } else {
      //  Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<bool> getTeamCreate(
      String teamID, String gameId, BuildContext context) async {
    // teamGetModel.value = null;
    var map = {
      "name": mapKey["Team Name"],
      "gameId": gameId,
      "teamTypeId": teamID,
      "image": imageFile
    };

    Map<String, dynamic> response = await WebServicesHelper()
        .getTeamsCreate(map, path_call, token, user_id, context);

    Utils().customPrint(response);
    if (response != null) {
      return true;

      /*teamGetModel.value = TeamGetModelR.fromJson(response);
      ;*/
    } else {
      return false;
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getTeamType() async {
    teamTypeModelR.value = null;
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getTeamType(token);
    if (responsestr != null) {
      teamTypeModelR.value = TeamTypeModelR.fromJson(responsestr);
      if (teamTypeList != null && teamTypeList.length > 0) {
        teamTypeList.clear();
      }

      for (int i = 0; i < teamTypeModelR.value.data.length; i++) {
        if (teamTypeModelR.value.data[i].size > 1) {
          teamTypeList.add(teamTypeModelR.value.data[i]);
        }
      }
      Utils().customPrint(
          "team data ========================= ${teamTypeList.length}");
      newTeam.value = "status:incomplete";
      getTeamNew("", "", "", "", newTeam.value);

      isInvited.value = "isInvited=true";
      getTeamInVites(isInvited.value, "", "", "", "");
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  getFromGallery() async {
    /*   image = (await ImagePicker().pickImage(source: ImageSource.gallery));
    iamges1 = image;*/

    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      path_call = pickedFile.path;
      iamges1.value = File(pickedFile.path);
    }
  }

/*  getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      final bytes = imageFile.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      /// imageFile = File(pickedFile.path);

    }
  }*/

  Future<void> getJoinedContestList(String gameid) async {
    esportJoinedList.value = null;

    if (token == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }

    //winningDistributed
    Map<String, dynamic> response = await WebServicesHelper()
        .getJoinedContestList(token, gameid, "", user_id, "",
            "completed,resultDeclared,winningDistributed");
    if (response != null) {
      Utils().customPrint("Joined List=-=====");
      esportJoinedList.value =
          ESportEventListModel.fromJson(response, "", false, false);
    } else {
      esportJoinedList.value = null;
      //Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
