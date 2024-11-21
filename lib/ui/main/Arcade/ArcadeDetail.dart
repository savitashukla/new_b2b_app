import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/AppColor.dart';
import '../../controller/BaseController.dart';

class ArcadeDetails extends StatelessWidget {
  // ArcadeDetails({Key key}) : super(key: key);
  BaseController base_controller = Get.put(BaseController());

  @override
  Widget build(BuildContext context) {
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
                  image: AssetImage('assets/images/images.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text("GUNS AND BOTTLE"),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 35, bottom: 15, left: 5, right: 5),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            base_controller.checkTr.value = true;
                            base_controller.colorPrimary.value =
                                Color(0xFFe55f19);
                            base_controller.colorwhite.value =
                                Color(0xFFffffff);
                          },
                          child: Column(
                            children: [
                              Text(
                                "Prize Distribution",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              Obx(
                                () => Container(
                                  margin: EdgeInsets.only(top: 5),
                                  color: base_controller.colorPrimary.value,
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
                            base_controller.checkTr.value = false;
                            base_controller.colorPrimary.value =
                                Color(0xFFffffff);
                            base_controller.colorwhite.value =
                                Color(0xFFe55f19);
                          },
                          child: Column(
                            children: [
                              Text(
                                "Rules".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                              Obx(
                                () => Container(
                                  margin: EdgeInsets.only(top: 5),
                                  color: base_controller.colorwhite.value,
                                  height: 3,
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 40,
                color: AppColor().colorPrimary,
                child: Center(child: Text("Prize Distribution")),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                color: AppColor().whiteColor,
                child: Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Start Time"),
                          Text("21 jul "),
                          Text("")
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("End Time"), Text("24 Jul "), Text("")],
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Your Score"), Text("-"), Text("")],
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Your Rank"), Text("-"), Text("")],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                  width: double.infinity,
                  //  height: 220,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(0)),
                  child: Wrap(
                    children: [
                      Container(
                        height: 40,
                        color: AppColor().reward_grey_bg,
                        child: Center(child: Text("Prize Distribution")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 30,
                                              child: Image.asset(
                                                  "assets/images/ic_cron.png"),
                                            ),
                                            CircleAvatar(
                                                radius: 40,
                                                child: Image(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      "assets/images/user.png"),
                                                )

                                                //radius: 20,
                                                )
                                          ],
                                        ),
                                        Container(
                                          // alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: 19, left: 30),
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  AppColor().colorPrimary_light,
                                              child: Text(
                                                "2",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "\u{20B9} 7",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor().colorPrimary),
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                              CircleAvatar(
                                                radius: 55,

                                                child: Image(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      "assets/images/user.png"),
                                                ),

                                                //radius: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin:
                                              EdgeInsets.only(top: 20, left: 0),
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  AppColor().colorPrimary_light,
                                              child: Text(
                                                "1",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "\u{20B9} 4",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor().colorPrimary),
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 30,
                                              child: Image.asset(
                                                  "assets/images/ic_cron.png"),
                                            ),
                                            CircleAvatar(
                                              radius: 40,

                                              child: Image(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    "assets/images/user.png"),
                                              ),

                                              //radius: 20,
                                            )
                                          ],
                                        ),
                                        Container(
                                          // alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: 19, left: 30),
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  AppColor().colorPrimary_light,
                                              child: Text(
                                                "3",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "\u{20B9} ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor().colorPrimary),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              "Ranks".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              "Score ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              "Amount",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: AppColor().blackColor),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                height: 10,
              ),
              InkWell(
                onTap: () {

                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  color: AppColor().DartGreenColorLow,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Entry",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppColor().whiteColor),
                        ),
                        Container(width: 15),
                        Text(
                          "\u{20B9} 0",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppColor().whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Colors.white,
                  radius: Radius.circular(10),
                  strokeWidth: 1.0,
                  dashPattern: [7, 4],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Text("Enter ")),
                        Text("\u{20B9} 0"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
