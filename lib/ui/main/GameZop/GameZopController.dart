
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:gmng/model/BannerModel/BannerResC.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/ESportsEventList.dart';
import '../../../model/unity_history/OnlyUnityHistoryModel.dart';
import '../../../utills/bridge.dart';
import '../../../webservices/WebServicesHelper.dart';

class GameZobController extends GetxController {
  var game_id;

  GameZobController(this.game_id);

  var unityEventList = ESportEventListModel().obs;
  SharedPreferences prefs;
  String user_id;
  var onlyUnityHistoryModel = OnlyUnityHistoryModel().obs;
  String token;
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var checkTr = true.obs;

  // pagination add
  var scrollcontroller = ScrollController();
  var currentpage = 0.obs;
  var total_limit = 10;
  var totalAmountValues = 0.obs;
  RxList unity_history_userRegistrations = new List<HistoryData>().obs;

  var bannerModelRV = BannerModelR().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getESportsEventList();

    // pagination add

    scrollcontroller.addListener(() {
      if (scrollcontroller.position.atEdge &&
          scrollcontroller.position.pixels != 0) {
        if (totalAmountValues > currentpage.value) {
          currentpage.value = currentpage.value + 10;
          getUnityHistoryOnly(game_id);
        }

        Utils().customPrint("data pagination");
        /* if (maxPaginationCount.value > paginationPage.value) {
            pageLoading.value = true;
            getProductList();
          } else {
            noMoreItems.value = true;
          }*/
      }
    });

    //call banner api
    getBanner(game_id);
  }

  Future<void> getESportsEventList() async {
    unityEventList.value = null;
    Map<String, dynamic> response = await WebServicesHelper()
        .getUnitEventList(token, game_id, "", "", user_id, "active");
    if (response != null) {
      unityEventList.value =
          ESportEventListModel.fromJson(response, "", false, true);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

/*  Future<void> getUnityHistory(String game_id) async {
    onlyUnityHistoryModel.value = null;


    Map<String, dynamic> response =
        await WebServicesHelper().getUnityHistory(token, user_id, game_id,total_limit,currentpage.value);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);


      unity_history_userRegistrations.addAll(onlyUnityHistoryModel.value.data);
      totalAmountValues.value = onlyUnityHistoryModel.value.pagination.total;

    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }*/
  Future<void> getUnityHistoryOnly(String game_id) async {
    onlyUnityHistoryModel.value = null;

    Map<String, dynamic> response = await WebServicesHelper().getUnityHistory(
        token, user_id, game_id, total_limit, currentpage.value);
    if (response != null) {
      onlyUnityHistoryModel.value = OnlyUnityHistoryModel.fromJson(response);

      if (onlyUnityHistoryModel.value.data.length > 0) {
        unity_history_userRegistrations
            .addAll(onlyUnityHistoryModel.value.data);
        totalAmountValues.value = onlyUnityHistoryModel.value.pagination.total;
      } else {
        Fluttertoast.showToast(msg: "Data Not Found!");
      }
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> OpenUnityGame(
      ContestModel model,
      String gameid,
      String game_name,
      bool is_test,
      String mobile,
      String name,
      String profile,
      String user_id,
      String email) async {
    String winning_type = "";
    String winning_type_amount = "";
    // List<num> winning_type_amount = [];
    if (model.rankAmount != null) {
      for (int i = 0; i < model.rankAmount.length; i++) {
        if (model.rankAmount[i].amount != null) {
          if (model.rankAmount[i].amount.type == "currency") {
            if (!winning_type.isEmpty) {
              winning_type = winning_type + ",WinningWallet";
            } else {
              winning_type = "WinningWallet";
            }

            //     winning_type.add("WinningWallet");
            int amount = model.rankAmount[i].amount.value ~/ 100;
            if (!winning_type_amount.isEmpty) {
              winning_type_amount =
                  winning_type_amount + "," + amount.toString();
            } else {
              winning_type_amount = amount.toString();
            }
            //winning_type_amount.add(amount);
          } else {
            if (!winning_type.isEmpty) {
              winning_type = winning_type + ",BonusWallet";
            } else {
              winning_type = "BonusWallet";
            }
            // winning_type.add("BonusWallet");
            //  winning_type_amount.add(model.rankAmount[i].amount.value);
            if (!winning_type_amount.isEmpty) {
              winning_type_amount = winning_type_amount +
                  "," +
                  model.rankAmount[i].amount.value.toString();
            } else {
              winning_type_amount = model.rankAmount[i].amount.value.toString();
            }
          }
        }
      }
    }

    final Map<String, String> data = {
      "event_id": model.id,
      "game_id": gameid,
      "game_name": game_name,
      "is_test": is_test.toString(),
      "mobile": mobile,
      "name": name,
      "profile": profile,
      "user_id": user_id,
      "email": email,
      "winning_type": winning_type.toString(),
      "winning_type_amount": winning_type_amount.toString(),
    };
    String reposnenative = await NativeBridge.OpenUnityGames(data);
  }

  Future<void> getBanner(String game_id) async {
    Utils().customPrint('GameZop Banner: $game_id');
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getBannerViaGameId(token, game_id);
      if (response_str != null) {
        bannerModelRV.value = BannerModelR.fromJson(response_str);
        Utils().customPrint(
            'GameZop Banner length : ${bannerModelRV.value.data.length} ');
      }
    }
  }
}
