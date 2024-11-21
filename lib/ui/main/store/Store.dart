import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/controller/GameTypeController.dart';
import 'package:gmng/utills/Utils.dart';

import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../controller/BaseController.dart';
import '../../controller/StoreController.dart';

class Store extends StatelessWidget {
  Store({Key key}) : super(key: key);
  BaseController base_controller = Get.put(BaseController());
  StoreController controller = Get.put(StoreController());
  GameTypeController gameTypeController = Get.put(GameTypeController());

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: RefreshIndicator(
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return a Future when code finish execution.
          // return Future<void>.delayed(const Duration(seconds: 3));
          return Future.delayed(const Duration(seconds: 1), () async {
            controller.getStoreList("");
          });
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Image(
              image: AssetImage('assets/images/store_top.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Text("store".tr),
            )),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              controller.checkTr.value = true;
                              controller.colorPrimary.value = Color(0xFFe55f19);
                              controller.colorwhite.value = Color(0xFFffffff);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Coin".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Obx(
                                  () => Container(
                                    margin: EdgeInsets.only(top: 5),
                                    color: controller.colorPrimary.value,
                                    height: 3,
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              controller.checkTr.value = false;
                              controller.colorPrimary.value = Color(0xFFffffff);
                              controller.colorwhite.value = Color(0xFFe55f19);
                              controller.getBuyHistory();
                            },
                            child: Column(
                              children: [
                                Text(
                                  "History".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      color: Colors.white),
                                ),
                                Obx(
                                  () => Container(
                                    margin: EdgeInsets.only(top: 5),
                                    color: controller.colorwhite.value,
                                    height: 3,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.checkTr.value,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            height: 40,
                            child: Obx(
                              () => gameTypeController
                                          .only_esport_game_e.value !=
                                      null
                                  ? gameTypeController
                                              .only_esport_game_e.value.data !=
                                          null
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: gameTypeController
                                                      .only_esport_game_e
                                                      .value
                                                      .data
                                                      .length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return mapList(
                                                        context, index);
                                                  }),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.topCenter,
                                          height: 20,
                                          child: Text(
                                            "No items are available Please Come back later",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                color: Colors.white),
                                          ))
                                  : Container(
                                      alignment: Alignment.topCenter,
                                      height: 100,
                                      width: 100,
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        color: Colors.transparent,
                                        child: Image(
                                            height: 100,
                                            width: 100,
                                            //color: Colors.transparent,
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/progresbar_images.gif")),
                                      )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => controller.storeValues.value != null
                                ? controller.storeValues.value.data != null
                                    ? GridView.count(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.0,
                                        childAspectRatio: 0.85,
                                        mainAxisSpacing: 0,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: List.generate(
                                            controller.storeValues.value.data
                                                .length, (index) {
                                          return listGameDetails(
                                              context, index);
                                        }))
                                    : Center(
                                        child: Container(
                                          child: Text(
                                              "No items are available Please Come back later",
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      )
                                : Center(
                                    child: Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.transparent,
                                    child: Image(
                                        height: 100,
                                        width: 100,
                                        //color: Colors.transparent,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/images/progresbar_images.gif")),
                                  )),
                          ),
                        ],
                      )),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Offstage(
                      offstage: controller.checkTr.value,
                      child: controller.store_p_historyR.value != null
                          ? controller.store_p_historyR.value.data != null
                              ? ListView.builder(
                                  //     padding: EdgeInsets.only(bottom: 100),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller
                                      .store_p_historyR.value.data.length,
                                  itemBuilder: (context, index) {
                                    return ListHistoryCall(context, index);
                                  })
                              : Center(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 200),
                                    height: 0,
                                    /*     child: Text("No Data Found",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),*/
                                  ),
                                )
                          : Center(
                              child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.transparent,
                              child: Image(
                                  height: 100,
                                  width: 100,
                                  //color: Colors.transparent,
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/images/progresbar_images.gif")),
                            )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mapList(BuildContext context, int index) {
    return Center(
      child: GestureDetector(
        onTap: () {
          controller.tabIndex.value = index;

          if (index == 0) {
            controller.getStoreList("");
          } else {
            controller.getStoreList(
                gameTypeController.only_esport_game_e.value.data[index].id);
          }
        },
        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              gameTypeController.only_esport_game_e.value.data[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Inter", color: Colors.white),
            ),
            decoration: controller.tabIndex.value == index
                ? BoxDecoration(
                    color: AppColor().colorPrimary,
                    borderRadius: BorderRadius.circular(10))
                : BoxDecoration(
                    border: Border.all(color: AppColor().colorGray, width: 1),
                    borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget listGameDetailsS(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        var mapData = await controller
            .getINGameCheck(controller.storeValues.value.data[index].gameId.id);
        if (mapData != null) {
          if (controller.inGameCheckModel.value != null) {
            if (!controller.inGameCheckModel.value.inGameName.isEmpty) {
              showInGameDialog(
                  context,
                  controller.storeValues.value.data[index].id,
                  controller.storeValues.value.data[index].gameId.id);
            } else {
              showInGameDialog(
                  context,
                  controller.storeValues.value.data[index].id,
                  controller.storeValues.value.data[index].gameId.id);
            }
          }
        } else {
          showInGameDialog(context, controller.storeValues.value.data[index].id,
              controller.storeValues.value.data[index].gameId.id);
        }

        /* controller
                    .getBuyStore(controller.storeValues.value.data[index].id);*/
      },
      child: Wrap(
        /* crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,*/
        children: [
          Container(
            decoration: BoxDecoration(color: AppColor().whiteColor),
            child: Column(
              children: [
                Image(
                  height: 110,
                  image: AssetImage(ImageRes().team_group),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 4, 0, 0),
                  child: Text(
                    "cxvbnvcxz",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: AppColor().blackColor),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 4, 0, 0),
                  child: Text(
                    "ghjklghjk",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Inter",
                        color: AppColor().grey_other),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 3, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset("assets/images/wincoin.webp"),
                        height: 18,
                        width: 18,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "dfghjkljhgf",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                            color: AppColor().blackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
              ],
            ),
          ),
          Container(
            color: AppColor().colorPrimary,
            height: 1,
          ),
          InkWell(
            onTap: () async {
              Utils().customPrint("hello ");
              var mapData = await controller.getINGameCheck(
                  controller.storeValues.value.data[index].gameId.id);

              if (controller.storeValues.value.data[index].gameId.name
                      .compareTo("Call of duty") ==
                  0) {
                controller.game_id_name.value = "OpenID";
              } else {
                controller.game_id_name.value = "InGameID";
              }

              if (mapData != null) {
                if (controller.inGameCheckModel.value != null) {
                  if (!controller.inGameCheckModel.value.inGameName.isEmpty) {
                    showInGameDialog(
                        context,
                        controller.storeValues.value.data[index].id,
                        controller.storeValues.value.data[index].gameId.id);
                  } else {
                    showInGameDialog(
                        context,
                        controller.storeValues.value.data[index].id,
                        controller.storeValues.value.data[index].gameId.id);
                  }
                }
              } else {
                showInGameDialog(
                    context,
                    controller.storeValues.value.data[index].id,
                    controller.storeValues.value.data[index].gameId.id);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              child: Text(
                "Buy Now".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                    color: AppColor().colorPrimary),
              ),
            ),
          ),
          // )
        ],
      ),
    );
  }

  Widget listGameDetails(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        var mapData = await controller
            .getINGameCheck(controller.storeValues.value.data[index].gameId.id);
        if (mapData != null) {
          if (controller.inGameCheckModel.value != null) {
            if (!controller.inGameCheckModel.value.inGameName.isEmpty) {
              showInGameDialog(
                  context,
                  controller.storeValues.value.data[index].id,
                  controller.storeValues.value.data[index].gameId.id);
            } else {
              showInGameDialog(
                  context,
                  controller.storeValues.value.data[index].id,
                  controller.storeValues.value.data[index].gameId.id);
            }
          }
        } else {
          showInGameDialog(context, controller.storeValues.value.data[index].id,
              controller.storeValues.value.data[index].gameId.id);
        }

        /* controller
                  .getBuyStore(controller.storeValues.value.data[index].id);*/
      },
      child: Wrap(
        /* crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,*/
        children: [
          Container(
            decoration: BoxDecoration(color: AppColor().whiteColor),
            child: Column(
              children: [
                /*  SizedBox(
                  height: 15,
                ),*/
                CachedNetworkImage(
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: controller.storeValues.value.data[index].image.url,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 4, 0, 0),
                  child: Text(
                    controller.storeValues.value.data[index].gameId != null
                        ? controller.storeValues.value.data[index].gameId.name
                        : '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: AppColor().blackColor),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 4, 0, 0),
                  child: Text(
                    controller
                        .storeValues.value.data[index].description.capitalize,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Inter",
                        color: AppColor().grey_other),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 3, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset("assets/images/wincoin.webp"),
                        height: 18,
                        width: 18,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "${controller.storeValues.value.data[index].price.value ~/ 100}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                            color: AppColor().blackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
              ],
            ),
          ),
          Container(
            color: AppColor().colorPrimary,
            height: 1,
          ),
          InkWell(
            onTap: () async {
              if (AppString.buyStoreItem == 'inactive') {
                Fluttertoast.showToast(msg: 'Currently unavailable!');
                return;
              }
              var mapData = await controller.getINGameCheck(
                  controller.storeValues.value.data[index].gameId.id);
              if (controller.storeValues.value.data[index].gameId.id
                      .compareTo("62de6babd6fc1704f21b0a95") ==
                  0) {
                Utils().customPrint(
                    "game id ${controller.storeValues.value.data[index].gameId.id}");
                controller.game_id_name.value = "OpenID";
              } else {
                controller.game_id_name.value = "InGameID";
              }
              if (mapData != null) {
                if (controller.inGameCheckModel.value != null) {
                  if (!controller.inGameCheckModel.value.inGameName.isEmpty) {
                    showInGameDialog(
                        context,
                        controller.storeValues.value.data[index].id,
                        controller.storeValues.value.data[index].gameId.id);
                  } else {
                    showInGameDialog(
                        context,
                        controller.storeValues.value.data[index].id,
                        controller.storeValues.value.data[index].gameId.id);
                  }
                }
              } else {
                showInGameDialog(
                    context,
                    controller.storeValues.value.data[index].id,
                    controller.storeValues.value.data[index].gameId.id);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              child: Text(
                "Buy Now".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                    color: AppString.buyStoreItem == 'inactive'
                        ? AppColor().reward_grey_bg
                        : AppColor().colorPrimary),
              ),
            ),
          ),
          // )
        ],
      ),
    );
  }

  Widget ListHistoryCall(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 0),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/gradient_rectangular.png")),
        borderRadius:
            BorderRadius.circular(10), /* color: AppColor().optional_payment*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      image: controller.store_p_historyR.value.data[index]
                                  .storeItemId.image.url !=
                              null
                          ? NetworkImage(controller.store_p_historyR.value
                              .data[index].storeItemId.image.url)
                          : AssetImage('assets/images/images.png'),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          controller.store_p_historyR.value.data[index]
                              .storeItemId.name.capitalize,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              color: AppColor().whiteColor)),
                      Text(
                          controller.store_p_historyR.value.data[index]
                              .storeItemId.description.capitalize,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Roboto",
                              color: AppColor().whiteColor)),
                      /* Text("GMNGS9",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: AppColor().whiteColor)),*/
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 3,
                    ),
                    Image(
                      height: 18,
                      image: AssetImage(
                        ImageRes().ic_coin,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                        "${controller.store_p_historyR.value.data[index].totalAmount ~/ 100}",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Roboto",
                            color: AppColor().whiteColor)),
                  ],
                ),
                Text(
                    controller
                        .store_p_historyR.value.data[index].status.capitalize,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Roboto",
                        color: AppColor().colorPrimary)),
                SizedBox(
                  height: 5,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              "assets/images/orange_gradient_back.png")),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    /*    decoration: BoxDecoration(

                        //border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(10)),*/
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "REPORT",
                        style: TextStyle(
                            fontSize: 11,
                            fontFamily: "Roboto",
                            color: Colors.white),
                      ),
                    )),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showInGameDialog(BuildContext context, String store_id, String game_id) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageRes().new_rectangle_box_blank)),
            ),
            height: 300,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "Game Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "InGameName",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  editTitleTextFieldInGame(
                    controller.inGameName,
                    "Enter your InGameName",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        controller.game_id_name.value,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Inter",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  editTitleTextFieldInGame(
                      controller.iNGameId, "Enter your InGameID"),
                  SizedBox(
                    height: 15,
                  ),
                  buttonSubmit(context, store_id, game_id),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  Widget editTitleTextFieldInGame(
      TextEditingController controllerV, String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      margin: EdgeInsets.symmetric(horizontal: 35),
      height: 50,
      child: TextField(
        style: TextStyle(color: AppColor().whiteColor),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            hintText: "${text}"),
        onChanged: (textv) {
          controllerV.text = textv;
          Utils().customPrint("First text field: $textv");
          controllerV.selection = TextSelection.fromPosition(
              TextPosition(offset: controllerV.text.length));
        },
        autofocus: false,
        controller: controllerV,
      ),
    );
  }

  Widget buttonSubmit(BuildContext context, String store_id, String game_id) {
    return GestureDetector(
      onTap: () {
        if (controller.inGameName.text.isEmpty) {
          controller.getINGamePost(game_id, store_id);
        } else {
          controller.getBuyStore(store_id);
        }

        /* if(controller.inGameName.text.isEmpty)
          {
            controller.getINGamePost(game_id, store_id);
          }
        else{

        }*/

        Navigator.pop(context);
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 34),
          height: 50,
          width: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(ImageRes().submit_bg)),
            // color: AppColor().colorPrimary,
          ),
          child: Center(
            child: controller.inGameName.text.isEmpty
                ? Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  )
                : Text(
                    "Update".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  ),
          )),
    );
  }
}
