import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';

import '../../../../model/HomeModel/HomePageListModel.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/FontSizeC.dart';
import '../../../../res/AppString.dart';
import '../../../../res/ImageRes.dart';
import '../../../controller/Ballbazi_Controller.dart';
import '../../../controller/HomePageController.dart';
import '../../../controller/Pocket52_Controller.dart';
import '../../esports/ESports.dart';

class ViewAllTrendingEvent extends StatelessWidget {
  HomePageController controller = Get.put(HomePageController());
  List<TrendingEvents> trendingEvents;

  BallbaziLoginController ballbaziLoginController =
      Get.put(BallbaziLoginController());
  Pocket52LoginController _pocket52loginController =
      Get.put(Pocket52LoginController());

  ViewAllTrendingEvent(this.trendingEvents);

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
            child: Center(child: Text("Trending Events"))),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/store_back.png"))),
        child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 100.0,
            children: List.generate(trendingEvents.length, (index) {
              return listGameShow(context, index);
            })),
      ),
    );
  }

  Widget listGameShow(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        String gameid =
            controller.homePageListModel.value.trendingEvents[index].gameId.id;
        if (controller.homePageListModel.value.gameCategories != null &&
            controller.homePageListModel.value.gameCategories.length > 0) {
          for (int i = 0;
              i < controller.homePageListModel.value.gameCategories.length;
              i++) {
            for (int j = 0;
                j <
                    controller
                        .homePageListModel.value.gameCategories[i].games.length;
                j++) {
              Games game =
                  controller.homePageListModel.value.gameCategories[i].games[i];
              if (game.id == gameid) {
                Utils().customPrint("Found game ${game.name}");
                Get.to(() => ESports(
                      game.id,
                      game.banner != null ? game.banner.url : "",
                      game.howToPlayUrl,
                      controller
                          .homePageListModel.value.trendingEvents[index].id,
                    ));
                break;
              }
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 4, top: 4, bottom: 0),
        child: Wrap(
          children: [
            Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: controller.homePageListModel.value
                                .trendingEvents[index].banner !=
                            null
                        ? CachedNetworkImage(
                            height: 110,
                            width: 135,
                            fit: BoxFit.cover,
                            imageUrl: controller.homePageListModel.value
                                .trendingEvents[index].banner.url,
                          )
                        : Image(
                            height: 110,
                            width: 135,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/store_top.png'),
                          ))),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Container(
                height: 100,
                padding:
                    const EdgeInsets.only(right: 0, left: 7, top: 0, bottom: 0),
                color: AppColor().blackColor,
                margin: EdgeInsets.only(left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Win",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              color: AppColor().whiteColor,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w300,
                            )),
                        Text(
                            " ${AppString().txt_currency_symbole} ${controller.homePageListModel.value.trendingEvents[index].winner.prizeAmount.value ~/ 100}",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              color: AppColor().whiteColor,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Entry",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              // color: AppColor().whiteColor,
                              fontFamily: "Roboto",
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.w300,
                            )),
                        Text(
                            " ${AppString().txt_currency_symbole} ${controller.homePageListModel.value.trendingEvents[index].entry.fee.value}",
                            style: TextStyle(
                              fontSize: FontSizeC().front_very_small,
                              // color: AppColor().whiteColor,
                              fontFamily: "Roboto",
                              color: AppColor().whiteColor,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image(
                          height: 20,
                          width: 15,
                          fit: BoxFit.cover,
                          color: Colors.white70,
                          image: AssetImage(ImageRes().trophy_dash),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                            "${controller.homePageListModel.value.trendingEvents[index].gameId.name}",
                            style: TextStyle(
                              color: AppColor().colorPrimary,
                              fontSize: FontSizeC().front_very_small,
                              // color: AppColor().whiteColor,
                              fontFamily: "Roboto",

                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
