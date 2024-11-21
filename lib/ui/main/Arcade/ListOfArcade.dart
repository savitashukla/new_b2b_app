import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';

import '../../../model/basemodel/AppBaseErrorResponse.dart';
import '../../../model/responsemodel/PreJoinResponseModel.dart';
import '../../../res/AppColor.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../controller/BaseController.dart';
import '../../controller/Pocket52_Controller.dart';
import 'ArcadeController.dart';

class ListOfArcade extends StatelessWidget {
  var gameid;
  String url;
  String name = "";

  ListOfArcade(this.gameid, this.url, this.name);

  ArcadeController controller;
  PreJoinResponseModel preJoinResponseModel;
  Pocket52LoginController _pocket52loginController =
      Get.put(Pocket52LoginController());
  BaseController base_controller = Get.put(BaseController());

  @override
  Widget build(BuildContext context) {
    controller = Get.put(ArcadeController(gameid));
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/login_bg.webp"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColor().reward_card_bg,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    image: NetworkImage(url)

                    // AssetImage('assets/images/images.png'),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(name),
              )
            ],
          ),
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
                                "All Battles".tr,
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Contest".tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Inter", color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              controller.arcadeEventList.value != null
                  ? controller.arcadeEventList.value.data != null
                      ? ListView.builder(
                          itemCount:
                              controller.arcadeEventList.value.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                            return triviaList(context, index);
                          })
                      : Text("")
                  : Container(
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
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget triviaList(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Wrap(
          children: [
            Stack(
              children: [
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      child: Image(
                        height: 40,
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/v_battel.png'),

                        /*NetworkImage(

                            item.image.url)*/
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      controller.arcadeEventList.value.data[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().whiteColor),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Prizepool",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                color: AppColor().colorPrimary),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 13,
                              alignment: Alignment.topCenter,
                              child:
                                  Image.asset("assets/images/arrow_down.png"),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColor().blackColor)),
                          child: Center(
                            child: Text(
                              "\u{20B9} ${controller.arcadeEventList.value.data[index].winner.prizeAmount.value ~/ 100}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColor().reward_card_bg,
                              borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Text(
                              "Tournament",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().whiteColor),
                            ),
                          )),
                      Container(
                        height: 10,
                      ),
                      Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColor().blackColor)),
                          child: Center(
                            child: Text(
                              "Running",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  color: AppColor().colorPrimary),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Entry Fee",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Inter",
                            color: AppColor().colorPrimary),
                      ),
                      Container(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          getPreJoinEvent(
                              controller.arcadeEventList.value.data[index].id,
                              context);
                          //Get.to(() => ArcadeDetails());
                        },
                        child: Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                                color: AppColor().colorPrimary,
                                borderRadius: BorderRadius.circular(3)),
                            child: Center(
                              child: controller.arcadeEventList.value
                                          .data[index].entry.fee.value >
                                      0
                                  ? Text(
                                      "${controller.arcadeEventList.value.data[index].entry.fee.value ~/ 100}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor().whiteColor),
                                    )
                                  : Text(
                                      "Free",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          color: AppColor().whiteColor),
                                    ),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: AppColor().colorPrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Bonus cash Used ",
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Inter",
                        color: AppColor().blackColor),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
                    child: Image.asset("assets/images/gmngcoin.webp"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 5),
                    child: Text(
                      "0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          color: AppColor().blackColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<Map> getPreJoinEvent(String event_id, BuildContext context) async {
    //print("event_id ===>${contest_id}");
    Utils().customPrint("user_id ===> ${controller.user_id}");
    final param = {"userId": controller.user_id};
    showProgress(context, '', true);

    Map<String, dynamic> response = await WebServicesHelper()
        .getPreEventJoin(param, controller.token, event_id);
    Utils().customPrint(' respone is finaly ${response}');

    if (response != null && response['statusCode'] == null) {
      hideProgress(context);
      Utils().customPrint(' respone is finaly1 ${response}');
      preJoinResponseModel = PreJoinResponseModel.fromJson(response);
      if (preJoinResponseModel != null) {
        DeficitAmount deficitAmount = preJoinResponseModel.deficitAmount;
        if (deficitAmount.value > 0) {
          //Fluttertoast.showToast(msg: "Please add Amount.");
          //Get.offAll(() => DashBord(4, ""));
          Utils().alertInsufficientBalance(context);
        } else {
          // _pocket52loginController.OpenUnityGame();

        }
      } else {
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(response);
        Utils().showErrorMessage("", appBaseErrorModel.error);
      }
    } else if (response['statusCode'] != 400) {
      hideProgress(context);
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else if (response['statusCode'] != 500) {
      hideProgress(context);
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      Utils().showErrorMessage("", appBaseErrorModel.error);
    } else {
      hideProgress(context);
      Utils().customPrint('respone is finaly2${response}');
      //hideLoader();
    }
  }
}
