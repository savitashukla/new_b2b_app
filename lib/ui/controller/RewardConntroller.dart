import 'dart:convert';

import 'package:get/get.dart';
import 'package:gmng/model/responsemodel/ReferalResponse.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/BannerModel/BannerResC.dart';
import '../../model/responsemodel/ReferalResponse.dart';
import '../../model/responsemodel/ReferalResponse.dart';
import '../../model/responsemodel/referraltotalmoney.dart';
import '../../webservices/WebServicesHelper.dart';

class RewardController extends GetxController {
  SharedPreferences prefs;
  String token;
  String user_id;
  String bannerType = "referral";
  var bannerModelRV = BannerModelR().obs;
  var referlistModel = ReferalResponse().obs;
  var type = "monthly".obs;
  List<ReferalListModel> referlistValuesR = new List<ReferalListModel>().obs;
  Rx<ReferalListModel> user1 = new ReferalListModel().obs;
  Rx<ReferalListModel> user2 = new ReferalListModel().obs;
  Rx<ReferalListModel> user3 = new ReferalListModel().obs;
  var data_list = [].obs;
  var referTotalMoney = ReferralTotalMoney().obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getStaticFAQs();
    getBanner();
    getReferalList();
    getTotalEarnedMoney();
  }

  Future<void> getReferalList() async {
    referlistModel.value = null;
    user1.value = null;
    user2.value = null;
    user3.value = null;
    Utils().customPrint("type.value ${type.value}");
    //showLoader();

    Map<String, dynamic> response =
        await WebServicesHelper().getReferalList(token, user_id, type.value);
    if (response != null) {
      // hideLoader();
      referlistModel.value = ReferalResponse.fromJson(response);

      var leaderBoardResponse = ReferalResponse.fromJson(response);
      if (leaderBoardResponse != null &&
          leaderBoardResponse.data != null &&
          leaderBoardResponse.data.length > 0) {
        List<ReferalListModel> data = new List();
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
        if (referlistValuesR != null && referlistValuesR.length > 0) {
          referlistValuesR.clear();
        }
        referlistValuesR.addAll(data);
      } else {
        if (referlistValuesR != null && referlistValuesR.length > 0) {
          referlistValuesR.clear();
        }
      }

      // Fluttertoast.showToast(msg: "reward values $_referlistModel");
    } else {
      hideLoader();
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getBanner() async {
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getUserBanner(token, bannerType);
      if (response_str != null) {
        bannerModelRV.value = BannerModelR.fromJson(response_str);
      }
    }
  }

  Future<void> getStaticFAQs() async {
    //adding static FAQs
    var tmp_list = json.decode(ReferalResponse.FAQs);
    Utils().customPrint("referlistModel.value.data_list ${tmp_list}");
    if (tmp_list != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      data_list.value = new List<FAQ>();
      tmp_list.forEach((v) {
        data_list.value.add(new FAQ.fromJson(v, prefs.getString("language")));
      });
      Utils().customPrint("referlistModel.value.data_list ${data_list.length}");
    }
  }

  Future<void> getTotalEarnedMoney() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    Map<String, dynamic> responsestr =
        await WebServicesHelper().totalMoneyEarnedReferral(token, user_id);

    if (responsestr != null) {
      referTotalMoney.value = ReferralTotalMoney.fromJson(responsestr);
      print("getTotalEarnedMoney :: ${referTotalMoney.value.total.value}");
    }
  }
}
