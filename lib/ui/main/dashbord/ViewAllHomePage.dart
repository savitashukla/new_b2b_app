import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/ui/main/myteam11_ballabazzi/MyTeam11_Ballbazi_Controller.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/HomeModel/HomePageListModel.dart';

import '../../../model/HomeModel/HomePageListModel.dart';
import '../../../model/LoginModel/hash_rummy.dart';
import '../../../res/AppColor.dart';
import '../../../res/FontSizeC.dart';
import '../../../utills/bridge.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/Ballbazi_Controller.dart';
import '../../controller/HomePageController.dart';
import '../../controller/Pocket52_Controller.dart';
import '../../controller/user_controller.dart';
import '../Freakx/FreakxList.dart';
import '../GameZop/GameZopList.dart';
import '../UnitEventList/UnityList.dart';
import '../esports/ESports.dart';
import '../how_to_pay_rummy.dart';
import '../ludo_king/Ludo_King_Screen.dart';
import '../tamasha_ludo/TamashaListing.dart';
import 'DashBord.dart';

class ViewAllHomePages extends StatelessWidget {
  GameCategories gameCategories;
  String game_name;
  HomePageController controller = Get.put(HomePageController());

  ViewAllHomePages(this.gameCategories, this.game_name);

  BallbaziLoginController ballbaziLoginController =
      Get.put(BallbaziLoginController());
  Pocket52LoginController _pocket52loginController =
      Get.put(Pocket52LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        title: Container(
            margin: EdgeInsets.only(right: 60),
            child: Center(child: Text("${gameCategories.name}".tr))),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 10, right: 10),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/store_back.png"))),
        child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 20,
            children: List.generate(gameCategories.games.length, (index) {
              return listGameShow(context, index);
            })),
      ),
    );
  }

  Widget listGameShow(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        AppString.gameName = gameCategories.games[index].name;
        Utils().customPrint("game name===>${gameCategories.games[index].name}");
        Utils().customPrint("isRMG===>${gameCategories.isRMG}");

        if (!gameCategories.isRMG) {
          if (gameCategories.games[index].isClickable) {
            Get.to(() => ESports(
                gameCategories.games[index].id,
                gameCategories.games[index].banner.url,
                gameCategories.games[index].howToPlayUrl,
                ""));
          }
          /* else{
            Fluttertoast.showToast(msg: "${controller.homePageListModel.value.gameCategories[indexfirst].games[index].isClickable}");
          }*/

        } else {
          if (gameCategories.games[index].thirdParty != null) {
            Utils()
                .customPrint('${gameCategories.games[index].thirdParty.name}');

            if (gameCategories.games[index].isClickable) {
              if (gameCategories.games[index].name == 'FANTASY') {
                //ballbaziLoginController.getLoginBallabzi(context);
                MyTeam11_Ballbazi_Controller team11Controller =
                    Get.put(MyTeam11_Ballbazi_Controller());

                await team11Controller.getLoginTeam11BB(
                    context, '62de6babd6fc1704f21b0ab4');
              } else if (gameCategories.games[index].thirdParty.name ==
                  'Pocket52') {
                _pocket52loginController.getLoginWithPocket52(context);
              } else if (gameCategories.games[index].thirdParty.name ==
                  'Rummy') {
                final param = {"state": "haryana", "country": "india"};

                Fluttertoast.showToast(msg: "Under Maintenance");

                //  getHashForRummy(param);
              } else if (gameCategories.games[index].thirdParty.name ==
                  'Ludo King') {
                Get.to(() => LudoKingScreen(gameCategories.games[index].id, "",
                    gameCategories.games[index].howToPlayUrl));
              } else if (gameCategories.games[index].thirdParty.name ==
                  'Gamezop') {
               /* Get.to(() => GameJobList(
                    gameCategories.games[index].id,
                    gameCategories.games[index].banner.url,
                    gameCategories.games[index].name));*/
              } else if (gameCategories.games[index].thirdParty.name ==
                  'Freakx') {
                Get.to(() => FreakxList(
                    gameCategories.games[index].id,
                    gameCategories.games[index].banner.url,
                    gameCategories.games[index].name));
              } else if (gameCategories.games[index].thirdParty.name ==
                  'Ludot') {
                Get.to(() => TamashaListing(
                    gameCategories.games[index].id,
                    gameCategories.games[index].banner.url,
                    gameCategories.games[index].name));
              }
            }
          } else {
            Utils().customPrint('Unity App ');

            if (gameCategories.games[index].isClickable) {
              Get.to(() => UnityList(
                  gameCategories.games[index].id,
                  gameCategories.games[index].banner.url,
                  gameCategories.games[index].name));
            }
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
        child: Wrap(
          children: [
            Container(
                padding:
                    const EdgeInsets.only(right: 0, left: 0, top: 4, bottom: 4),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      height: 108,
                      width: 110,
                      fit: BoxFit.fill,
                      imageUrl: gameCategories.games[index].banner.url,
                      /*    placeholder: (context, url) => Image(
                  image: NetworkImage(controller.homePageListModel.value
                      .gameCategories[indexfirst].games[index].banner.url),
                ),*/
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ))),
            /* Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor().reward_card_bg,
              ),

               */ /* padding: const EdgeInsets.only(
                    right: 10, left: 4, top: 4, bottom: 4),*/ /*
                child: Image(
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      gameCategories.games[index].banner.url),
                )),*/
            Container(
              height: 5,
            ),
            Center(
              child: Text(
                gameCategories.games[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  //  decoration: TextDecoration.underline,
                  fontSize: FontSizeC().front_very_small,
                  color: AppColor().whiteColor,
                  fontFamily: "Roboto",

                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getHashForRummy(Map<String, dynamic> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, dynamic> response =
        await WebServicesHelper().getHashForRummy(token, param);

    Utils().customPrint('response $response');
    if (response != null) {
      if (response["isThirdPartyLimitExhausted"] != null &&
          response['isThirdPartyLimitExhausted']) {
        Utils.alertLimitExhausted();
        return true;
      } else {
        Utils().customPrint('response ${response['loginRequest']['params']}');
        RummyModel rummyModel =
            RummyModel.fromJson(response['loginRequest']['params']);
        Utils().customPrint('LoginResponseLoginResponse ${rummyModel}');

        final Map<String, String> data = {
          "user_id": rummyModel.user_id,
          "name": rummyModel.name,
          "state": rummyModel.state,
          "country": rummyModel.country,
          "session_key": rummyModel.session_key,
          "timestamp": rummyModel.timestamp,
          "client_id": rummyModel.client_id,
          "hash": rummyModel.hash,
        };

        String reposnenative = await NativeBridge().OpenRummy(data);
        Utils().customPrint("data====> ${reposnenative}");
        try {
          switch (reposnenative) {
            case "click_add_amount":
              UserController controller = Get.find();
              controller.currentIndex.value = 4;
              controller.getWalletAmount();
              Get.offAll(() => DashBord(4, ""));
              break;
            case "topBarClicked":
              Get.to(() => how_to_play_rummy());
              break;
            default:
              Utils().customPrint("click_buyin_success=====================>");
              break;
          }
        } catch (e) {
          //error
        }
      }
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }
}
