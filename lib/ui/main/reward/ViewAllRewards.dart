
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';

import '../../../res/ImageRes.dart';
import '../../../webservices/ApiUrl.dart';
import '../../controller/GameTypeController.dart';
import '../../controller/RewardConntroller.dart';

class ViewAllRewards extends StatelessWidget {
  GameTypeController gameTypeController = Get.put(GameTypeController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  RewardController _rewardController = Get.put(RewardController());

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      _rewardController.type.value = "monthly";
      _rewardController.getReferalList();
      // SystemNavigator.pop();
      return true;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _rewardController.type.value = "monthly";
      _rewardController.getReferalList();
    });
    // gameTypeController.getGameType();

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/store_back.png'),
          ),
        ),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () async {
              _rewardController.getReferalList();
            });
          },
          child: WillPopScope(
            onWillPop: onWillPop,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  flexibleSpace: Image(
                    image: AssetImage('assets/images/store_top.png'),
                    fit: BoxFit.cover,
                  ),
                  backgroundColor: Colors.transparent,
                  // backgroundColor: AppColor().reward_card_bg,
                  title:  Text(
                    'Referral Leaderboard'.tr,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  )),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                _rewardController.type.value = "monthly";
                                _rewardController.getReferalList();
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "MONTHLY".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Inter",
                                        color: Colors.white),
                                  ),
                                  Obx(
                                    () => Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 5, right: 5),
                                      height: 2,
                                      color: _rewardController.type.value
                                                  .compareTo("monthly") ==
                                              0
                                          ? AppColor().colorPrimary
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      _rewardController.type.value = "weekly";
                                      _rewardController.getReferalList();
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "WEEKLY".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        ),
                                        Obx(
                                          () => Container(
                                            margin: EdgeInsets.only(
                                                top: 10, left: 5, right: 5),
                                            height: 2,
                                            color: _rewardController.type.value
                                                        .compareTo("weekly") ==
                                                    0
                                                ? AppColor().colorPrimary
                                                : null,
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                _rewardController.type.value = "daily";
                                _rewardController.getReferalList();
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "DAILY".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        color: Colors.white),
                                  ),
                                  Obx(
                                    () => Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 5, right: 5),
                                      height: 2,
                                      color: _rewardController.type.value
                                                  .compareTo("daily") ==
                                              0
                                          ? AppColor().colorPrimary
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 15, right: 15, bottom: 10, top: 2),
                      width: double.infinity,
                      height: 265,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  ImageRes().leader_board_rank_back)),
                          borderRadius: BorderRadius.circular(15)),
                      /*decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(15)),*/
                      child: Center(
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 65,
                                ),
                                Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 30,
                                          child: Image.asset(
                                              "assets/images/ic_cron.png"),
                                        ),
                                        ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(52)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .13),
                                                  border: Border.all(
                                                    width: 2,
                                                    color:
                                                        AppColor().colorPrimary,
                                                  )),
                                              child: Obx(() => _rewardController
                                                              .user2 !=
                                                          null &&
                                                      _rewardController
                                                              .user2.value !=
                                                          null &&
                                                      _rewardController.user2
                                                              .value.photo !=
                                                          null
                                                  ? CircleAvatar(
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .12,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: NetworkImage(
                                                          "${_rewardController.user2.value.photo.url}"),
                                                    )
                                                  : CircleAvatar(
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .12,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: Image(
                                                        height: 40,
                                                        width: 40,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            ImageRes()
                                                                .team_group),
                                                      ),
                                                    )),
                                            ))
                                      ],
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          top: 19,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .1),
                                      child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor:
                                              AppColor().colorPrimary_light,
                                          child: Text(
                                            "2",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                ),
                                Obx(() => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                ImageRes().rank_amount_back)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 1,
                                        ),
                                        child: Text(
                                          "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${_rewardController.user2 != null && _rewardController.user2.value != null && _rewardController.user2.value.amount != null ? _rewardController.user2.value.amount.getAmountValues() : "-"}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor().colorPrimary),
                                        ),
                                      ),
                                    )),
                                Obx(
                                  () => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 3),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${_rewardController.user2 != null && _rewardController.user2.value != null ? _rewardController.user2.value.username : "User"}"
                                                .capitalize,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500,
                                                color: AppColor().whiteColor),
                                          ),
                                          Text(
                                            "${_rewardController.user2 != null && _rewardController.user2.value != null ? "( ${_rewardController.user2.value.count} )" : "--"}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Roboto",
                                                color: AppColor().colorPrimary),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(0),
                                            height: 32,
                                            child: Image.asset(
                                                "assets/images/ic_cron.png"),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(52),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .20),
                                                    border: Border.all(
                                                      width: 2,
                                                      color: AppColor()
                                                          .colorPrimary,
                                                    )),
                                                child: Obx(
                                                  () => _rewardController
                                                                  .user1 !=
                                                              null &&
                                                          _rewardController
                                                                  .user1.value !=
                                                              null &&
                                                          _rewardController
                                                                  .user1
                                                                  .value
                                                                  .photo !=
                                                              null
                                                      ? CircleAvatar(
                                                          radius: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .19,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            backgroundImage:
                                                                (NetworkImage(
                                                                    "${_rewardController.user1.value.photo.url}")

                                                                // AssetImage('assets/images/images.png'),
                                                                ),
                                                          ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .19,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: Image(
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                ImageRes()
                                                                    .team_group),
                                                          )
                                                          //radius: 20,
                                                          ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            top: 20,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .17),
                                        child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                AppColor().colorPrimary_light,
                                            child: Center(
                                              child: Text(
                                                "1",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() => Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  ImageRes().rank_amount_back)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 1,
                                          ),
                                          child: Text(
                                            "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${_rewardController.user1 != null && _rewardController.user1.value != null && _rewardController.user1.value.amount != null ? _rewardController.user1.value.amount.getAmountValues() : "-"}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500,
                                                color: AppColor().colorPrimary),
                                          ),
                                        ),
                                      ),
                                    )),
                                Obx(() => Center(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 3),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${_rewardController.user1 != null && _rewardController.user1.value != null ? _rewardController.user1.value.username : "User"}"
                                                    .capitalize,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColor().whiteColor),
                                              ),
                                              Text(
                                                "${_rewardController.user1 != null && _rewardController.user1.value != null ? "( ${_rewardController.user1.value.count} )" : "--"}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Roboto",
                                                    color: AppColor()
                                                        .colorPrimary),
                                              ),
                                            ],
                                          )),
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                ),
                                Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 30,
                                          child: Image.asset(
                                              "assets/images/ic_cron.png"),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(52)),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .13),
                                                  border: Border.all(
                                                    width: 2,
                                                    color:
                                                        AppColor().colorPrimary,
                                                  )),
                                              child: Obx(
                                                () => _rewardController
                                                                .user3 !=
                                                            null &&
                                                        _rewardController
                                                                .user3.value !=
                                                            null &&
                                                        _rewardController.user3
                                                                .value.photo !=
                                                            null
                                                    ? CircleAvatar(
                                                        radius: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .12,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "${_rewardController.user3.value.photo.url}"),
                                                      )
                                                    : CircleAvatar(
                                                        radius: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .12,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Image(
                                                          height: 40,
                                                          width: 40,
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(
                                                              ImageRes()
                                                                  .team_group),
                                                        ),
                                                      ),
                                              )),
                                        )
                                      ],
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          top: 19,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .1),
                                      child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor:
                                              AppColor().colorPrimary_light,
                                          child: Text(
                                            "3",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                ),
                                Obx(() => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                ImageRes().rank_amount_back)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 1,
                                        ),
                                        child: Text(
                                          "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${_rewardController.user3 != null && _rewardController.user3.value != null && _rewardController.user3.value.amount != null ? _rewardController.user3.value.amount.getAmountValues() : "-"}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor().colorPrimary),
                                        ),
                                      ),
                                    )),
                                Obx(() => Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 3),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${_rewardController.user3 != null && _rewardController.user3.value != null ? _rewardController.user3.value.username : "-"}"
                                              .capitalize,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor().whiteColor),
                                        ),
                                        Text(
                                          "${_rewardController.user3 != null && _rewardController.user3.value != null ? "( ${_rewardController.user3.value.count} )" : "-"}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Roboto",
                                              color: AppColor().colorPrimary),
                                        ),
                                      ],
                                    ))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 5,
                        left: 5,
                        right: 5,
                        bottom: 0,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColor().colorPrimary_dark,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User Rank".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          Text(
                            "User Name".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: Colors.white),
                          ),
                          Text(
                            "REFERRALS".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                color: Colors.white),
                          ),
                          Text(
                            "PRIZES".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: 0,
                          left: 5,
                          right: 5,
                          bottom: 10,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        decoration: BoxDecoration(
                            // color: AppColor().reward_grey_bg,
                            borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                        alignment: Alignment.center,
                        child: Obx(() => (_rewardController.referlistValuesR !=
                                null)
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _rewardController
                                            .referlistValuesR.length >
                                        0
                                    ? _rewardController.referlistValuesR.length
                                    : 0,
                                /*  scrollDirection: Axis.vertical,*/
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return getUserListWidget(context, index);
                                })
                            : Container(
                                height: 0,
                                alignment: Alignment.center,
                              ))),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget getUserListWidget(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      /*   decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(width: 1, color: Colors.white),
          color: AppColor().optional_payment),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "${index + 4}",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14, fontFamily: "Inter", color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                      image: (_rewardController.referlistValuesR[index].photo !=
                                  null &&
                              _rewardController
                                      .referlistValuesR[index].photo.url !=
                                  null)
                          ? NetworkImage(_rewardController
                              .referlistValuesR[index].photo.url)
                          : AssetImage('assets/images/images.png'),
                    ),
                  ),
                ),
                /*  CircleAvatar(
                  radius: 12,
                  child: Image.asset("assets/images/ic_link.webp"),
                  backgroundColor: AppColor().colorPrimaryDark,
                ),*/
                Container(
                  width: 5,
                ),
                Center(
                  child: Text(
                    "${_rewardController.referlistValuesR[index].username.length > 13 ? _rewardController.referlistValuesR[index].username.substring(0, 13) : _rewardController.referlistValuesR[index].username}"
                        .capitalize,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Inter", color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${_rewardController.referlistValuesR[index].count}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  color: AppColor().colorPrimaryDark),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${ApiUrl().isPlayStore ? "" : '\u{20B9}'} ${_rewardController.referlistValuesR[index].amount != null ? _rewardController.referlistValuesR[index].amount.getAmountValues() : "-"}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 14, fontFamily: "Roboto", color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
