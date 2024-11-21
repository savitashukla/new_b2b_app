import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/HomeModel/ESportModel.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/HomeModel/HomePageListModel.dart';
import '../../model/HomeModel/favorite_game_model.dart';
import '../../model/wallet/WalleModelR.dart';
import '../../utills/OnlyOff.dart';
import '../../webservices/WebServicesHelper.dart';

class HomePageController extends GetxController {
  EsportModelR EsportModelRV;
  var esports_model_v = EsportModelR().obs;
  var only_esport_game_e = EsportModelR().obs;
  var favoriteGameModel = FavoriteGameModel().obs;

  var homePageListModel = HomePageListModel().obs;
  SharedPreferences prefs;
  var currentIndexSlider = 0.obs;
  String token;
  var walletModelPromo = WalletModelR().obs();
  var selectedGameId = "".obs;
  String user_id;

  var appBtnBgColor = const Color(0xFFc23705).obs;
  var appBtnTxtColor = const Color(0xffFFFFFF).obs;

  // get cashback cal
  var selectAmount = "".obs;
  var promocode = "".obs;
  var amtAfterPromoApplied = 0.0.obs;
  var ApplyBtnText = 'Apply'.obs;
  var youWillGet = ''.obs;
  var ftdCheck = false.obs;
  var vipCheck = false.obs;
  var collectAmtVipNextLevel = "".obs;
  RxList AllGameCall = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    //await getPromoCodesData();
    //await getHomePage();

    Future.delayed(const Duration(seconds: 1), () async {
      await getPromoCodesData();
      // await getHomePage();
    });

    if (user_id != null && user_id != '') {
      getGameType();
      getGameEsportOnly();
      getFavoriteGameList();
    }

    //My Fav Game working
  }

  Future<void> getHomePage() async {
    homePageListModel.value = null;


if(token!=null && token!='')
  {
    Map<String, dynamic> responsestr =
    await WebServicesHelper().getHomePage(token);
    if (responsestr != null) {
      homePageListModel.value = HomePageListModel.fromJson(responsestr);
      Utils()
          .customPrint("HOMEBANNER ${homePageListModel.value.banners.length}");
      if (homePageListModel.value.gameCategories != null &&
          homePageListModel.value.gameCategories.length > 0) {
        homePageListModel.value.gamesMyFav = new List<Games>();
        AllGameCall.value = new List<Games>();

        for (int i = 0;
        i < homePageListModel.value.gameCategories.length;
        i++) {
          for (int j = 0;
          j < homePageListModel.value.gameCategories[i].games.length;
          j++) {
            Games game = homePageListModel.value.gameCategories[i].games[j];

            if (homePageListModel.value.gameCategories[i].isRMG) {
              game.isRMG = homePageListModel.value.gameCategories[i].isRMG;
            } else {
              game.isRMG = homePageListModel.value.gameCategories[i].isRMG;
            }

            //Utils().customPrint('Home page ui ${game.name}');
            if (AppString().header_Token == "BRAZGMNG8MTI") {
              if (game.name == "Cricketf" ||
                  game.name == "T. Ludo" ||
                  game.name == "Fruit Chop" ||
                  game.name == "Trago") {
                homePageListModel.value.gamesMyFav.add(game);
              }
            } else {
              //live Game
              if (game.name == "Rummy" ||
                  game.name == "POKER" ||
                  game.name == "FANTASY" ||
                  game.name == "Skill Ludo") {
                homePageListModel.value.gamesMyFav.add(game);
              }
            }

            AllGameCall.value.add(game);

            print("call here data values   ${AllGameCall.value.length}");
          }
        }
        AllGameCall.value.sort((a, b) => a.order.compareTo(b.order));

        if (onlyOffi.gamesMyFavSelected != null &&
            onlyOffi.gamesMyFavSelected.length > 0 &&
            onlyOffi.gamesMyFavSelected[0].name != null) {
          AllGameCall.removeWhere(
                  (item) => item.name == '${onlyOffi.gamesMyFavSelected[0].name}');
        }
      }
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }

  }

  }

  Future<void> getGameType() async {
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getGameType(token);
    if (responsestr != null) {
      EsportModelRV = EsportModelR.fromJson(responsestr);
      esports_model_v.value = EsportModelR.fromJson(responsestr);
    } else {
      //  Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getGameEsportOnly() async {
    only_esport_game_e.value = null;
    Map<String, dynamic> responsestr =
        await WebServicesHelper().only_esport_game(token);
    if (responsestr != null) {
      only_esport_game_e.value = EsportModelR.fromJson(responsestr);
    } else {
      //  Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> sendFavoriteGame(BuildContext context, String GameId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    Map<String, dynamic> paramseData = {"gameId": GameId};
    Map<String, dynamic> responsestr =
        await WebServicesHelper().sendFavoriteGame(token, user_id, paramseData);
  }

  Future<void> getFavoriteGameList() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    Map<String, dynamic> responsestr =
        await WebServicesHelper().getFavoriteGame(token, user_id);

    if (responsestr != null) {
      favoriteGameModel.value = FavoriteGameModel.fromJson(responsestr);
      print("fantsy exh.. ${responsestr.toString()}");
    }
  }

  //need to update un this functions
  Future<void> getPromoCodesData() async {
    //blocking promocodes
    if (AppString.promoCodes.value == "inactive") {
      return;
    }
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response = await WebServicesHelper().getPromoCodesData(
        token, user_id, Utils().getTodayDatesWithFormat(), "VIP");

    if (response != null) {
      walletModelPromo = WalletModelR.fromJsonPromo(response);
      print('home walletModelPromo length  ${walletModelPromo.data.length}');

      ////FTD LOOP *******************************************************
      for (int index = 0; walletModelPromo.data.length > index; index++) {
        //setting up VIP levels
        settingUpVipLevels(index);
        //end

        if (walletModelPromo.data[index].ftd == true) {
          ftdCheck.value = true;
          selectAmount.value = walletModelPromo.data[index].fromValue;
          promocode.value = walletModelPromo.data[index].code;

          // CALCULATE  GET vALUES
          Utils().customPrint(
              "PROMOCODE Loop code ${walletModelPromo.data[index].code}");
          if (promocode.value.toLowerCase() ==
              walletModelPromo.data[index].code.toLowerCase()) {
            //validation
            double enterAmtInt = double.parse(selectAmount.value);
            double fromValue =
                double.parse(walletModelPromo.data[index].fromValue);
            double toValue = double.parse(walletModelPromo.data[index].toValue);
            Utils().customPrint('Offer Valid F ${fromValue}');
            Utils().customPrint('Offer Valid T ${toValue}');

            if (enterAmtInt < fromValue) {
              Fluttertoast.showToast(
                  textColor: Colors.red,
                  msg:
                      'Offer Valid On Deposit for ${walletModelPromo.data[index].fromValue} - ${walletModelPromo.data[index].toValue} Rs!');
              return;
            } else if (enterAmtInt > toValue) {
              Fluttertoast.showToast(
                  textColor: Colors.red,
                  msg:
                      'Offer Valid On Deposit for ${walletModelPromo.data[index].fromValue} - ${walletModelPromo.data[index].toValue} Rs!');
              return;
            }

            //promo code
            promo_code_not_visible1(selectAmount.value, index);
            Utils().customPrint("PROMOCODE Applied: ${promocode.value}");

            //break;
          } else {
            Utils().customPrint("PROMOCODE Invalid: ${promocode.value}");
          }
        }
      }
      UserController userController = Get.put(UserController());
      //sorting array
      //walletModelPromo.data.sort((a, b) => getPrice(a).compareTo(getPrice(b)));
      Future.delayed(const Duration(milliseconds: 2000), () {
        walletModelPromo.data.sort((a, b) => a.vipLevel.compareTo(b.vipLevel));
        /* print(
            'Home Dynamic VIP work:vipLevel sort ${walletModelPromo.data[0].vipLevel}');
        print(
            'Home Dynamic VIP work:vipLevel sort ${walletModelPromo.data[1].vipLevel}');
        print(
            'Home Dynamic VIP work:vipLevel sort ${walletModelPromo.data[2].vipLevel}');*/
        //

        ////VIP LOOP *******************************************************
        if (ftdCheck.value == false &&
            userController.profileDataRes != null &&
            userController.profileDataRes.value != null &&
            userController.profileDataRes.value.level != null &&
            userController.profileDataRes.value.level.id != null) {
          for (int index = 0; walletModelPromo.data.length > index; index++) {
            if (userController.profileDataRes.value.level.value == 0) {
              //FTD or VIP1
              if (walletModelPromo.data[index].vipLevel == 1) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value = needDepositAmtForNextVipLevel();
              }
            } else if (userController.profileDataRes.value.level.value == 1) {
              //VIP1 or VIP2
              if (walletModelPromo.data[index].vipLevel == 1) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    ""; //needDepositAmtForNextVipLevel(); //means user can add amt
              } else if (walletModelPromo.data[index].vipLevel == 2) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    needDepositAmtForNextVipLevel(); //means user can add amt
              }
            } else if (userController.profileDataRes.value.level.value == 2) {
              //VIP2 or VIP3
              if (walletModelPromo.data[index].vipLevel == 2) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    ""; //needDepositAmtForNextVipLevel(); //means user can add amt
              } else if (walletModelPromo.data[index].vipLevel == 3) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    needDepositAmtForNextVipLevel(); //means user can add amt
              }
            } else if (userController.profileDataRes.value.level.value == 3) {
              //VIP3 or VIP4
              if (walletModelPromo.data[index].vipLevel == 3) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    ""; //needDepositAmtForNextVipLevel(); //means user can add amt
              } else if (walletModelPromo.data[index].vipLevel == 4) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    needDepositAmtForNextVipLevel(); //means user can add amt
              }
            } else if (userController.profileDataRes.value.level.value == 4) {
              //VIP4 or VIP5
              if (walletModelPromo.data[index].vipLevel == 4) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    ""; //needDepositAmtForNextVipLevel(); //means user can add amt
              } else if (walletModelPromo.data[index].vipLevel == 5) {
                print(
                    'home userVipLevel MATCH obj new user ${walletModelPromo.data[index].code}');
                vipCheck.value = true;
                selectAmount.value = walletModelPromo.data[index].fromValue;
                promocode.value = walletModelPromo.data[index].code;
                collectAmtVipNextLevel.value =
                    needDepositAmtForNextVipLevel(); //means user can add amt
              }
            }

            // CALCULATE  GET vALUES
            // CALCULATE  GET vALUES
            // CALCULATE  GET vALUES
            Utils().customPrint(
                "PROMOCODE Loop code ${walletModelPromo.data[index].code}");
            if (promocode.value.toLowerCase() ==
                walletModelPromo.data[index].code.toLowerCase()) {
              //validation
              double enterAmtInt = double.parse(selectAmount.value);
              double fromValue =
                  double.parse(walletModelPromo.data[index].fromValue);
              double toValue =
                  double.parse(walletModelPromo.data[index].toValue);
              Utils().customPrint('Offer Valid F ${fromValue}');
              Utils().customPrint('Offer Valid T ${toValue}');

              if (enterAmtInt < fromValue) {
                Fluttertoast.showToast(
                    textColor: Colors.red,
                    msg:
                        'Offer Valid On Deposit for ${walletModelPromo.data[index].fromValue} - ${walletModelPromo.data[index].toValue} Rs!');
                return;
              } else if (enterAmtInt > toValue) {
                Fluttertoast.showToast(
                    textColor: Colors.red,
                    msg:
                        'Offer Valid On Deposit for ${walletModelPromo.data[index].fromValue} - ${walletModelPromo.data[index].toValue} Rs!');
                return;
              }

              //promo code
              promo_code_not_visible1(selectAmount.value, index);
              Utils().customPrint("PROMOCODE Applied: ${promocode.value}");

              break;
            } else {
              Utils().customPrint("PROMOCODE Invalid: ${promocode.value}");
            }
          }
        }
      });
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }

  //banner click method for VIP
  void promo_code_not_visible1(var entered_amount, int index_promo) {
    if (index_promo != null) {
      try {
        if (walletModelPromo
                    .data[index_promo].benefit[0].wallet[0].percentage !=
                '' &&
            walletModelPromo
                    .data[index_promo].benefit[0].wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletModelPromo
              .data[index_promo].benefit[0].wallet[0].maximumAmount);

          double percentage = double.parse(walletModelPromo
              .data[index_promo].benefit[0].wallet[0].percentage);
          Utils().customPrint('Offer enterAmtInt F ');
          Utils().customPrint('Offer calcValuePerc T ');
          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (walletModelPromo.data[index_promo].benefit[0].wallet[0].type ==
              'bonus') {
            //bonus
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              amtAfterPromoApplied.value = enterAmtInt + maxAmtFixed;
              youWillGet.value =
                  '${/*enterAmtInt +*/ maxAmtFixed} ' + 'Cashback'.tr;
            } else {
              //+calc
              amtAfterPromoApplied.value = enterAmtInt + calcValuePerc;
              youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback & ${calcValuePerc.ceil()} Bonus';
            }
          } else if (walletModelPromo
                  .data[index_promo].benefit[0].wallet[0].type ==
              'coin') {
            //coin
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              amtAfterPromoApplied.value = enterAmtInt + maxAmtFixed;
              youWillGet.value =
                  '${/*enterAmtInt +*/ maxAmtFixed} ' + 'Cashback'.tr;
            } else {
              //+calc
              amtAfterPromoApplied.value = enterAmtInt + calcValuePerc;
              youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback & ${calcValuePerc.ceil()} Coin';
            }
          } else if (walletModelPromo
                  .data[index_promo].benefit[0].wallet[0].type ==
              'instantCash') {
            //coin
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              amtAfterPromoApplied.value = /*enterAmtInt +*/ maxAmtFixed;
              youWillGet.value =
                  '${amtAfterPromoApplied.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} ' +
                      'Cashback'.tr;

              print("youWillGet $amtAfterPromoApplied");
            } else {
              //+calc
              amtAfterPromoApplied.value = enterAmtInt + calcValuePerc;
              youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Cashback & ${calcValuePerc.ceil()} Ins. Cash';
            }
          } else {
            //deposit
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              amtAfterPromoApplied.value = /*enterAmtInt +*/ maxAmtFixed;
              youWillGet.value =
                  '${amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} ' +
                      'Cashback'.tr;
            } else {
              //+calc
              amtAfterPromoApplied.value = /* enterAmtInt +*/ calcValuePerc;
              youWillGet.value =
                  '${amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} ' +
                      'Cashback'.tr;
            }
          }
        }
      } catch (e) {
        //print('applied amount: $e');
        Utils().customPrint('Offer calcValuePerc T $e');
        Fluttertoast.showToast(msg: 'Offer calcValuePerc T $e');
      }
    } else {
      //for dynamic showing value in 'You'll get' place.
      amtAfterPromoApplied.value = double.parse(entered_amount);
      youWillGet.value =
          '${entered_amount.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} ' +
              'Cashback'.tr;
    }
  }

  String needDepositAmtForNextVipLevel() {
    UserController userController = Get.put(UserController());
    var userInstantAmount =
        userController.profileDataRes.value.stats.instantCash.value / 100;
    Utils().customPrint(
        'home vip testing: userInstantAmount ${userInstantAmount}');

    var instantCashLimit =
        (userController.instantCashLimitNextLevel.value / 100);
    Utils()
        .customPrint('home vip testing: instantCashLimit ${instantCashLimit}');

    var needInstantCash = instantCashLimit - userInstantAmount;

    Utils().customPrint('home vip testing: needInstantCash ${needInstantCash}');
    return needInstantCash.ceil().toStringAsFixed(0);
  }

  void settingUpVipLevels(int i) {
    UserController userController = Get.put(UserController());

    //Dynamic work of assigning level to promo-code
    Utils().customPrint(
        'Home Dynamic VIP work:length 1 ${walletModelPromo.data[i].vipLevelIds.length}');
    //Utils().customPrint('Home Dynamic VIP work:length 1 vipmodulesAllL ${userController.vipmodulesAllL.value.data.length}');
    if (userController.vipmodulesAllL != null &&
        userController.vipmodulesAllL.value.data != null &&
        userController.vipmodulesAllL.value.data.length > 0) {
      for (int index = 0;
          index < userController.vipmodulesAllL.value.data.length;
          index++) {
        Utils().customPrint(
            'Home Dynamic VIP work:value 2 ${userController.vipmodulesAllL.value.data[index].value}');
        var firstId = walletModelPromo.data[i].vipLevelIds[
            walletModelPromo.data[i].vipLevelIds.length - 1]; //pick first one
        Utils().customPrint('Home Dynamic VIP work:firstId 3 ${firstId}');
        if (userController.vipmodulesAllL.value.data[index].id == firstId) {
          walletModelPromo.data[i].vipLevel =
              userController.vipmodulesAllL.value.data[index].value;
          Utils().customPrint(
              'Home Dynamic VIP work: 4 ${userController.vipmodulesAllL.value.data[index].id}');
          Utils().customPrint(
              'Home Dynamic VIP work:vipLevel  ${walletModelPromo.data[i].vipLevel}');
          break;
        }

        //end
      }
    }
  }
}
