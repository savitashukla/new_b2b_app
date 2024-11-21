import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/ui/controller/WithdrawalController.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:lottie/lottie.dart';

class WithdrawProcessingScreen extends StatelessWidget {
  WithdrawalController withdrawC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Obx(
                () => withdrawC.responseWithdraw == null ||
                        withdrawC.withdrawProcessingComplete.value == false
                    ? Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 60, bottom: 0),
                              child: Text(
                                "Withdrawal Status",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Lottie.asset(
                                'assets/lottie_files/withdraw_pro.json',
                                repeat: true,
                                height: 320,
                                fit: BoxFit.fill,
                                width: 320,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 300),
                              child: Text(
                                "Processing",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat",
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    : withdrawC.withdrawProcessingStatusCode.value == 200
                        ?withdrawC.responseWithdraw["status"]!=null && withdrawC.responseWithdraw["status"].compareTo("completed") ==
                                0
                            ? Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 60, bottom: 0),
                                      child: Text(
                                        "Withdrawal Status",
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Lottie.asset(
                                        'assets/lottie_files/withdraw_suc.json',
                                        repeat: true,
                                        height: 150,
                                        fit: BoxFit.fill,
                                        width: 150,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          color: AppColor().light_success,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 20, right: 20),
                                            child: Obx(
                                              () => Text(
                                                "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                textScaleFactor: 1.0,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 20, right: 20),
                                            child: Text(
                                              "Processed",
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Montserrat",
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : withdrawC.responseWithdraw["status"]!=null && withdrawC.responseWithdraw["status"]
                                            .compareTo("queued") ==
                                        0 ||
                                    withdrawC.responseWithdraw["status"]
                                            .compareTo("pending") ==
                                        0
                                ? withdrawC.withdrawProcessCompleted.value
                                            .compareTo("completed") ==
                                        0
                                    ? Column(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 60, bottom: 0),
                                              child: Text(
                                                "Withdrawal Status",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: Lottie.asset(
                                                'assets/lottie_files/withdraw_suc.json',
                                                repeat: true,
                                                height: 150,
                                                fit: BoxFit.fill,
                                                width: 150,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: withdrawC.withdrawProcessingSuccessMessage !=
                                                        null &&
                                                    withdrawC
                                                            .withdrawProcessingSuccessMessage !=
                                                        ""
                                                ? Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: AppColor()
                                                            .light_success,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Column(
                                                      children: [
                                                        withdrawC.withdrawProcessingSuccessMessage !=
                                                                    null &&
                                                                withdrawC
                                                                        .withdrawProcessingSuccessMessage !=
                                                                    ""
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child: Text(
                                                                  "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Montserrat",
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                height: 0,
                                                              ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Text(
                                                            "Processed",
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 20,
                                                            right: 20),
                                                    child: Text(
                                                      "Processed",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                          )
                                        ],
                                      )
                                    : withdrawC.withdrawProcessCompleted.value
                                                .compareTo("pending") ==
                                            0
                                        ? Stack(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 60, bottom: 0),
                                                  child: Text(
                                                    "Withdrawal Status",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15),
                                                  child: Lottie.asset(
                                                    'assets/lottie_files/withdraw_pro.json',
                                                    repeat: true,
                                                    height: 320,
                                                    fit: BoxFit.fill,
                                                    width: 320,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 300,
                                                      bottom: 20),
                                                  padding: EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15,
                                                      right: 20,
                                                      left: 20),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColor().light_red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                left: 20,
                                                                right: 20),
                                                        child: Text(
                                                          "Your withdrawal is taking longer than expected",
                                                          textScaleFactor: 1.0,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 20,
                                                          left: 20,
                                                          right: 20,
                                                        ),
                                                        child: Text(
                                                          "Please Check Back in Some Time!",
                                                          textScaleFactor: 1.0,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Obx(
                                                          () => Text(
                                                            "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : withdrawC.withdrawProcessCompleted.value
                                                    .compareTo("failed") ==
                                                0
                                            ? Column(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 60,
                                                              bottom: 0),
                                                      child: Text(
                                                        "Withdrawal Status",
                                                        textScaleFactor: 1.0,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 50),
                                                      child: Lottie.asset(
                                                        'assets/lottie_files/withdrwa_faild.json',
                                                        repeat: true,
                                                        height: 150,
                                                        fit: BoxFit.fill,
                                                        width: 150,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 20,
                                                          bottom: 20),
                                                      padding: EdgeInsets.only(
                                                          top: 15,
                                                          bottom: 15,
                                                          right: 20,
                                                          left: 20),
                                                      decoration: BoxDecoration(
                                                          color: AppColor()
                                                              .light_red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    left: 20,
                                                                    right: 20),
                                                            child: Text(
                                                              "Your Withdrawal Request Has Failed.\n Any Amount Debited will be credited back shortly.",
                                                              textAlign: TextAlign.center,
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      "Montserrat",
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: Obx(
                                                              () => Text(
                                                                "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                                textScaleFactor:
                                                                    1.0,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Stack(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 60,
                                                              bottom: 0),
                                                      child: Text(
                                                        "Withdrawal Status",
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15),
                                                      child: Lottie.asset(
                                                        'assets/lottie_files/withdraw_pro.json',
                                                        repeat: true,
                                                        height: 320,
                                                        fit: BoxFit.fill,
                                                        width: 320,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 300),
                                                      child: Text(
                                                        "Processing",
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                : withdrawC.responseWithdraw["status"]
                                            .compareTo("reversed") ==
                                        0
                                    ? Column(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 60, bottom: 0),
                                              child: Text(
                                                "Withdrawal Status",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: Lottie.asset(
                                                'assets/lottie_files/withdrwa_faild.json',
                                                repeat: true,
                                                height: 150,
                                                fit: BoxFit.fill,
                                                width: 150,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 20,
                                                  bottom: 20),
                                              padding: EdgeInsets.only(
                                                  top: 15,
                                                  bottom: 15,
                                                  right: 20,
                                                  left: 20),
                                              decoration: BoxDecoration(
                                                  color: AppColor().light_red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 20,
                                                            right: 20),
                                                    child: Text(
                                                      "Your Withdrawal Is Reversed!",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Obx(
                                                      () => Text(
                                                        "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                        textAlign: TextAlign.center,
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : withdrawC.responseWithdraw["status"].compareTo("failed") == 0
                                        ? Column(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 60, bottom: 0),
                                                  child: Text(
                                                    "Withdrawal Status",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50),
                                                  child: Lottie.asset(
                                                    'assets/lottie_files/withdrwa_faild.json',
                                                    repeat: true,
                                                    height: 150,
                                                    fit: BoxFit.fill,
                                                    width: 150,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 20,
                                                      bottom: 20),
                                                  padding: EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15,
                                                      right: 20,
                                                      left: 20),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColor().light_red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                left: 20,
                                                                right: 20),
                                                        child: Text(
                                                          "Your Withdrawal Is Failed!",
                                                          textAlign: TextAlign.center,
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Obx(
                                                          () => Text(
                                                            "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 60, bottom: 0),
                                                  child: Text(
                                                    "Withdrawal Status",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50),
                                                  child: Lottie.asset(
                                                    'assets/lottie_files/withdrwa_faild.json',
                                                    repeat: true,
                                                    height: 150,
                                                    fit: BoxFit.fill,
                                                    width: 150,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 20,
                                                      bottom: 20),
                                                  padding: EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15,
                                                      right: 20,
                                                      left: 20),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColor().light_red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                left: 20,
                                                                right: 20),
                                                        child: Text(
                                                          "Your Withdrawal Is Pending!",
                                                          textAlign: TextAlign.center,
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Obx(
                                                          () => Text(
                                                            "${withdrawC.withdrawProcessingSuccessMessage.value}",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                        : Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 60, bottom: 0),
                                  child: Text(
                                    "Withdrawal Status",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Lottie.asset(
                                    'assets/lottie_files/withdrwa_faild.json',
                                    repeat: true,
                                    height: 150,
                                    fit: BoxFit.fill,
                                    width: 150,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 20, bottom: 20),
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, right: 20, left: 20),
                                  decoration: BoxDecoration(
                                      color: AppColor().light_red,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Obx(
                                        () => Text(
                                          "${withdrawC.withdrawProcessingFailedMessage}",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColor().withdrawProcessBox,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "IMPS/UPI - Instant",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "NEFT - Credited within 2 hours between 1:00AM - 6:45PM on NEFT working days.",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "NEFT/RTGS working days - All days except 2nd and 4th Saturday, Sunday and any NEFT/RTGS holiday.",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "*Sometimes banks take 3-4 days to process the request.",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Obx(
                    () => withdrawC.withdrawProcessingStatusCode.value == 200
                        ? withdrawC.responseWithdraw["status"]!=null && withdrawC.responseWithdraw["status"]
                                        .compareTo("queued") ==
                                    0 ||
                                withdrawC.responseWithdraw["status"]
                                        .compareTo("pending") ==
                                    0
                            ? withdrawC.withdrawProcessCompleted.value
                                        .compareTo("failed") ==
                                    0 || withdrawC.withdrawProcessCompleted.value
                        .compareTo("completed") ==
                        0
                                ? Container(
                                    width: MediaQuery.of(context).size.height,
                                    height: 60,
                                    margin: EdgeInsets.only(
                                        left: 50, right: 50, bottom: 70),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          AppColor().button_bg_light,
                                          AppColor().button_bg_dark,
                                        ],
                                      ),

                                      boxShadow: const [
                                        BoxShadow(
                                          offset: const Offset(
                                            0.0,
                                            5.0,
                                          ),
                                          blurRadius: 1.0,
                                          spreadRadius: .3,
                                          color: Color(0xFFA73804),
                                          inset: true,
                                        ),
                                        BoxShadow(
                                          offset: Offset(00, 00),
                                          blurRadius: 00,
                                          color: Color(0xFFffffff),
                                          inset: true,
                                        ),
                                      ],

                                      border: Border.all(
                                          color: AppColor().whiteColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(30),
                                      // color: AppColor().whiteColor
                                    ),
                                    child: Center(
                                      child: TweenAnimationBuilder<Duration>(
                                          duration: Duration(seconds: 5),
                                          tween: Tween(
                                              begin: Duration(seconds: 5),
                                              end: Duration.zero),
                                          onEnd: () {
                                            Get.offAll(() => DashBord(4, ""));
                                          },
                                          builder: (BuildContext context,
                                              Duration value, Widget child) {
                                            String seconds =
                                                (value.inSeconds % 60)
                                                    .toInt()
                                                    .toString()
                                                    .padLeft(2, '0');
                                            String minutes =
                                                ((value.inSeconds / 60) % 60)
                                                    .toInt()
                                                    .toString()
                                                    .padLeft(2, '0');
                                            String hours =
                                                (value.inSeconds ~/ 3600)
                                                    .toString()
                                                    .padLeft(2, '0');

                                            return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Go Back",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: AppColor()
                                                              .whiteColor),
                                                    ),
                                                    Text(
                                                      " Closing in $seconds",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily:
                                                              "Montserrat",
                                                          color: AppColor()
                                                              .whiteColor),
                                                    )
                                                  ],
                                                ));
                                          }),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Get.offAll(() => DashBord(4, ""));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.height,
                                      height: 60,
                                      margin: EdgeInsets.only(
                                          left: 50, right: 50, bottom: 70),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            AppColor().button_bg_light,
                                            AppColor().button_bg_dark,
                                          ],
                                        ),

                                        boxShadow: const [
                                          BoxShadow(
                                            offset: const Offset(
                                              0.0,
                                              5.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: .3,
                                            color: Color(0xFFA73804),
                                            inset: true,
                                          ),
                                          BoxShadow(
                                            offset: Offset(00, 00),
                                            blurRadius: 00,
                                            color: Color(0xFFffffff),
                                            inset: true,
                                          ),
                                        ],

                                        border: Border.all(
                                            color: AppColor().whiteColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                        // color: AppColor().whiteColor
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Go Back",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              color: AppColor().whiteColor),
                                        ),
                                      ),
                                    ),
                                  )
                            : Container(
                                width: MediaQuery.of(context).size.height,
                                height: 60,
                                margin: EdgeInsets.only(
                                    left: 50, right: 50, bottom: 70),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      AppColor().button_bg_light,
                                      AppColor().button_bg_dark,
                                    ],
                                  ),

                                  boxShadow: const [
                                    BoxShadow(
                                      offset: const Offset(
                                        0.0,
                                        5.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: .3,
                                      color: Color(0xFFA73804),
                                      inset: true,
                                    ),
                                    BoxShadow(
                                      offset: Offset(00, 00),
                                      blurRadius: 00,
                                      color: Color(0xFFffffff),
                                      inset: true,
                                    ),
                                  ],

                                  border: Border.all(
                                      color: AppColor().whiteColor, width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                  // color: AppColor().whiteColor
                                ),
                                child: Center(
                                  child: TweenAnimationBuilder<Duration>(
                                      duration: Duration(seconds: 5),
                                      tween: Tween(
                                          begin: Duration(seconds: 5),
                                          end: Duration.zero),
                                      onEnd: () {
                                        Get.offAll(() => DashBord(4, ""));
                                      },
                                      builder: (BuildContext context,
                                          Duration value, Widget child) {
                                        String seconds = (value.inSeconds % 60)
                                            .toInt()
                                            .toString()
                                            .padLeft(2, '0');
                                        String minutes =
                                            ((value.inSeconds / 60) % 60)
                                                .toInt()
                                                .toString()
                                                .padLeft(2, '0');
                                        String hours = (value.inSeconds ~/ 3600)
                                            .toString()
                                            .padLeft(2, '0');

                                        return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Go Back",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .whiteColor),
                                                ),
                                                Text(
                                                  " Closing in $seconds",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: "Montserrat",
                                                      color: AppColor()
                                                          .whiteColor),
                                                )
                                              ],
                                            ));
                                      }),
                                ),
                              )
                        : InkWell(
                            onTap: () {
                              Get.offAll(() => DashBord(4, ""));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.height,
                              height: 60,
                              margin: EdgeInsets.only(
                                  left: 50, right: 50, bottom: 70),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().button_bg_light,
                                    AppColor().button_bg_dark,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFFA73804),
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(00, 00),
                                    blurRadius: 00,
                                    color: Color(0xFFffffff),
                                    inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Center(
                                child: Text(
                                  "Go Back",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
