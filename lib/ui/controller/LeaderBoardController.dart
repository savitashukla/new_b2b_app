import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/responsemodel/LeaderBoardResponse.dart';
import '../../webservices/WebServicesHelper.dart';

class LeaderBoardController extends GetxController {
  SharedPreferences prefs;
  String token;
  String user_id;
  var leaderBoardList = LeaderBoardResponse().obs;
  var type = "monthly".obs;
  RxList leaderBoardlistNew = new List<LeaderBoardModel>().obs;
  Rx<LeaderBoardModel> user1 = new LeaderBoardModel().obs;
  Rx<LeaderBoardModel> user2 = new LeaderBoardModel().obs;
  Rx<LeaderBoardModel> user3 = new LeaderBoardModel().obs;
  var selectedgame = "".obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getLeaderBoardList("", type.value);
  }

  Future<Map> getLeaderBoardList(String gameId, String type) async {
    // showLoader();
    leaderBoardList.value = null;
    user1.value = null;
    user2.value = null;
    user3.value = null;
    if (leaderBoardlistNew != null) {
      leaderBoardlistNew.clear();
    }

    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    // showProgress(context, "message", true);
    Map<String, dynamic> response = await WebServicesHelper()
        .getOnlyLeaderBoarData(token, user_id, gameId, type);
    if (response != null) {
      // hideLoader();
      Utils().customPrint("1=====");
      leaderBoardlistNew.clear();
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
      } else {
        user1.value = new LeaderBoardModel();
      }
    }
    return response;
  }
}
