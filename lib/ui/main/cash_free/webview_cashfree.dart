import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/cash_free/CashFreeController.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utills/Utils.dart';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);

class CashFreeWebview extends StatefulWidget {
  String url, source;
  CashFreeWebview(this.url, this.source);

  @override
  CashFreeState createState() => CashFreeState(url, source);
}

class CashFreeState extends State<CashFreeWebview> {
  String url, source;
  UserController _userController = Get.put(UserController());
  CashFreeController cashFreeController = Get.put(CashFreeController());

  CashFreeState(String url, String source) {
    this.url = url;
    this.source = source;
  }

  Completer<WebViewController> webViewCompleter =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Image(
              height: 80,
              image: AssetImage('assets/images/offerwall_header.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            title: /*Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Text(
                "Loot Wall",
                style: TextStyle(
                  fontFamily: "Montserrat",
                ),
              ), //and Promotions
            )), */
                Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Container(
                height: 80,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(""),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Add Money",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _userController.checkWallet_class_call.value = false;
                        _userController.getWalletAmount();
                        !ApiUrl().isPlayStore
                            ? _userController.wallet_s.value = true
                            : _userController.wallet_s.value = false;

                        if (!ApiUrl().isPlayStore) {
                          _userController.checkWallet_class_call.value = false;
                          _userController.currentIndex.value = 4;
                          Get.to(() => DashBord(4, ""));
                          //Wallet().showBottomSheetAddAmount(context);
                        } else {
                          Get.offAll(() => DashBord(4, ""));
                        }
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2, right: 0, left: 5, bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(
                                        width: 13,
                                        height: 13,
                                        image: ApiUrl().isPlayStore
                                            ? AssetImage(
                                                "assets/images/deposited.webp")
                                            : AssetImage(
                                                "assets/images/rupee_icon.png")),
                                    Obx(
                                      () => Text(
                                        ' ${_userController.getTotalBalnace()}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w400,
                                            color: AppColor().whiteColor),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(
                                        width: 13,
                                        height: 13,
                                        image: AssetImage(
                                            "assets/images/bonus_coin.png")),
                                    Obx(
                                      () => Text(
                                        ' ${_userController.getBonuseCashBalance()}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w400,
                                            color: AppColor().whiteColor),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: !ApiUrl().isPlayStore
                                ? Image(
                                    height: 30,
                                    //width: 40,
                                    fit: BoxFit.fill,
                                    image: AssetImage(ImageRes().plus_new_icon))
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
              child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              webViewCompleter.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) async {
              print("print web values");
              print("${request.url}");

              if (request.url.contains("https://docs.google.com/forms/d/e/")) {
                await launch(
                    "https://docs.google.com/forms/d/e/1FAIpQLSf4hwRTYCjymSAzSYpGwFxKglPe9IwqIzTc5aJldgxMg7HpWg/viewform");
                return NavigationDecision.prevent;
              }
              //  return NavigationDecision.prevent;
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'AndroidBridge',
                  onMessageReceived: (JavascriptMessage message) {
                    Utils().customPrint("----- wevview onMessageReceived");

                    Utils().customPrint(message.message);
                  })
            ]),
            onProgress: (progr) {
              Utils().customPrint('onProgress : $progr');
            },
            onPageFinished: (url) {
              // Get.to(()=>Match_Making_Screen());
              Utils().customPrint('onPageFinished for : $url');

              if (url.contains("callback")) {
                //API CALL for status
                Utils().customPrint('API CALL :::::');

                //API call
                if (source == 'razorpay') {
                  final param = {
                    "paymentId": cashFreeController
                        .razorpayResponseModel.data.checkPayment.paymentId,
                    "orderId": cashFreeController
                        .razorpayResponseModel.data.checkPayment.orderId,
                    "userId": cashFreeController
                        .razorpayResponseModel.data.checkPayment.userId,
                    "gateway": cashFreeController
                        .razorpayResponseModel.data.checkPayment.gateway
                  };
                  cashFreeController.paymentGatewayStatusNew(
                      context, param, source);
                } /*else {
                  final param = {
                    "paymentId": cashFreeController
                        .cashFreeResponseModel.data.checkPayment.paymentId,
                    "orderId": cashFreeController
                        .cashFreeResponseModel.data.checkPayment.orderId,
                    "userId": cashFreeController
                        .cashFreeResponseModel.data.checkPayment.userId,
                    "gateway": cashFreeController
                        .cashFreeResponseModel.data.checkPayment.gateway
                  };
                  cashFreeController.paymentGatewayStatusNew(
                      context, param, source);
                }*/
              } else if (url.contains("cashfree")) {
                final param = {
                  "paymentId": cashFreeController
                      .cashFreeResponseModel.data.checkPayment.paymentId,
                  "orderId": cashFreeController
                      .cashFreeResponseModel.data.checkPayment.orderId,
                  "userId": cashFreeController
                      .cashFreeResponseModel.data.checkPayment.userId,
                  "gateway": cashFreeController
                      .cashFreeResponseModel.data.checkPayment.gateway
                };
                cashFreeController.paymentGatewayStatusNew(
                    context, param, source);
              }
            },
            onPageStarted: (url) {},
            onWebResourceError: (error) {
              Utils().customPrint('onWebResourceError : ${error.errorCode}');
            },
            zoomEnabled: false,
          ))),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
