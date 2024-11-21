import 'dart:async';
import 'dart:ui';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/app.dart';
import 'package:gmng/model/cashfree/cashfree_methods_model.dart';
import 'package:gmng/model/cashfree/cashfree_payment_model.dart';
import 'package:gmng/model/cashfree/razorpay_payment_model.dart';
import 'package:gmng/model/cashfree/cashfree_status_model.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/controller/WalletPageController.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/dialog/helperProgressBar.dart';
import 'package:gmng/ui/main/cash_free/webview_cashfree.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/AppsFlyerController.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/utills/event_tracker/EventConstant.dart';
import 'package:gmng/utills/event_tracker/FaceBookEventController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:gmng/webservices/WebServicesHelper.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/CreateRozerpay.dart';
import '../../../model/cashfree/cashfree_methods_model.dart';
import '../../../res/firebase_events.dart';

class CashFreeController extends GetxController {
  var click = false.obs;
  var selectedApp = [].obs;
  SharedPreferences prefs;
  String token;
  String user_id;
  var clickBorder = false.obs;
  var cashFreeModel = CashFreeModel().obs;
  var cashFreeResponseModel = CashfreeResponseModel().obs();
  var razorpayResponseModel = RazorPayResponseModel().obs();
  var cashFreeStatusModel = CashfreeStatusModel().obs();
  var RozerpayOrderid = CreateRozerpay().obs;
  var upiListSelectedColor = 1000.obs;
  var netBankingListSelectedColor = 1000.obs;
  var walletListSelectedColor = 1000.obs;
  var selectedUPIApp = ''.obs;
  var isRazorpayCashfreeNetBanking = ''.obs;
  var amountCashTextController = TextEditingController(text: "").obs;

  var upiSource = '',
      walletSource = '',
      netbankingSource = '',
      cardSource = ''.obs;
  AppsflyerController appsflyerController = Get.put(AppsflyerController());
  CleverTapController cleverTapController = Get.put(CleverTapController());
  WalletPageController walletPageController = Get.put(WalletPageController());

  var enteredUPIid = ''.obs;
  bool click_remove_code = false;
  var promocodeHelper = "".obs;
  int promocodeValue = 0;

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

    //cashfree method to get existing install UPI apps
    getUPIList();
    //get master data from server
    getPaymentGatewayData();

    //Event added for screen view
    Map<String, Object> map = new Map<String, Object>();
    map["USER_ID"] = user_id;
    FirebaseEvent()
        .firebaseEvent(EventConstant.EVENT_payment_screen_view_F, map);
    cleverTapController.logEventCT(
        EventConstant.EVENT_payment_screen_view, map);
    appsflyerController.logEventAf(
        EventConstant.EVENT_payment_screen_view, map); //deposit success
    FaceBookEventController().logEventFacebook(
        EventConstant.EVENT_payment_screen_view, map); //deposit success

    //showing low amount work
    Utils().customPrint('contestAmount walletCon ${AppString.contestAmount}');
    if (AppString.contestAmount != null && AppString.contestAmount > 0) {
      amountCashTextController.value.text =
          Utils().populateAmountToUpper(AppString.contestAmount.toString());
      walletPageController.selectAmount.value =
          Utils().populateAmountToUpper(AppString.contestAmount.toString());
      //Utils().populateAmountToUpper(AppString.contestAmount.toString());
      promocodeAutoFilled(walletPageController.selectAmount.value.toString());
    } else {
      //amountCashTextController.value.text = "1";
      //amountCashTextController.value.text = "";
      //amountCashTextController = TextEditingController(text: "").obs;
      //walletPageController.selectAmount.value = "0";
    }
    print("TESTING:: wall ${amountCashTextController.value.text}");
  }

  Future<void> getUPIList() async {
    CashfreePGSDK.getUPIApps().then((value) => {
          if (value != null && value.length > 0)
            {
              for (int val = 0; val < value.length; val++)
                {
                  selectedApp.add(value[val]),
                  //print('UPIAppList: $selectedApp'),
                  //  log('UPIAppList: $selectedApp'),
                },
            }
          else
            {
              print("UPIAppList Not Found!"),
            }
        });
  }

  Future<void> getPaymentGatewayData() async {
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response =
        await WebServicesHelper().getPaymentGatewayData(token);

    if (response != null) {
      cashFreeModel.value = CashFreeModel.fromJson(response);
      cashFreeModel.value.data.paymentMethods
          .sort((a, b) => a.order.compareTo(b.order));

      cashFreeModel.value.data.paymentMethods.sort((a, b) => a.order.compareTo(b.order));


      print(
          "getPaymentGatewayData paymentMethods length : ${cashFreeModel.value.data.paymentMethods[0].order}");

      //object to array work | new array implementation
      //here we are check what we are using razorpay or cashfree
      if (cashFreeModel.value.data.paymentMethods != null &&
          cashFreeModel.value.data.paymentMethods.length > 0) {
        for (PaymentMethods objPaymentMethods
            in cashFreeModel.value.data.paymentMethods) {
          if (objPaymentMethods.method == 'card') {
            cardSource.value = objPaymentMethods.source;
            print("objPaymentMethods.source${objPaymentMethods.source}");
          }

          if (objPaymentMethods.method == 'upi') {
            upiSource = objPaymentMethods.source;
          } else if (objPaymentMethods.method == 'wallet') {
            walletSource = objPaymentMethods.source;
            if (objPaymentMethods.source == 'razorpay') {
              if (cashFreeModel.value.data.razorpayMethods.wallet != null &&
                  cashFreeModel.value.data.razorpayMethods.wallet.types !=
                      null) {
                //LOOP1
                for (String objStr in razorPayWalletListHelper) {
                  if (response['data']['razorpayMethods']['wallet']['types']
                          [objStr] ==
                      true) {
                    try {
                      final v = {
                        "name": objStr,
                        "status": "true",
                        "icon": response['data']['paymentIcons']['wallet']
                            [objStr]
                      };
                      walletList.add(new WalletList.fromJson(v));
                      //print('razorPaywalletListList :: ${walletList.length} $objStr');
                    } catch (e) {}
                  }
                }
              }
            } else {
              //  wallet icon
              if (cashFreeModel.value.data.cashfreeMethods.wallet != null &&
                  cashFreeModel.value.data.cashfreeMethods.wallet.types !=
                      null) {
                //LOOP1
                for (String objStr in cashFreeWalletListHelper) {
                  if (response['data']['cashfreeMethods']['wallet']['types']
                          [objStr] ==
                      true) {
                    try {
                      final v = {
                        "name": objStr,
                        "status": "true",
                        "icon": response['data']['paymentIcons']['wallet']
                            [objStr]
                      };
                      walletList.add(new WalletList.fromJson(v));
                      print(
                          'cashfreewalletListList :: ${walletList.length} $objStr');
                    } catch (e) {}
                  }
                }
              }
            }
          } else if (objPaymentMethods.method == 'netbanking') {
            netbankingSource = objPaymentMethods.source;
            if (objPaymentMethods.source == 'razorpay') {
              //when razorPay selected from backend
              if (cashFreeModel.value.data.razorpayMethods.netbanking != null &&
                  cashFreeModel.value.data.razorpayMethods.netbanking.banks !=
                      null) {
                //LOOP1
                for (String objStr in razorPayBankListHelper) {
                  if (response['data']['razorpayMethods']['netbanking']['banks']
                          [objStr] ==
                      true) {
                    try {
                      final v = {
                        "name": objStr,
                        "status": "true",
                        "icon": response['data']['paymentIcons']['netbanking']
                            [objStr]
                      };
                      razorPayOrcashFreeBankList
                          .add(new NetBankingList.fromJson(v));
                      print(
                          'razorPayBankList :: ${razorPayOrcashFreeBankList.length} $objStr');
                    } catch (e) {}
                  }
                }
              }
              // wallet call
            } else if (objPaymentMethods.source == 'cashfree') {
              //when cashFree selected from backend
              //LOOP2
              if (cashFreeModel.value.data.cashfreeMethods.netbanking != null &&
                  cashFreeModel.value.data.cashfreeMethods.netbanking.banks !=
                      null) {
                for (String objStr in cashFreeBankListHelper) {
                  if (response['data']['cashfreeMethods']['netbanking']['banks']
                          [objStr] ==
                      true) {
                    try {
                      final v = {
                        "name": objStr,
                        "status": "true",
                        "icon": response['data']['paymentIcons']['netbanking']
                            [objStr]
                      };
                      razorPayOrcashFreeBankList
                          .add(new NetBankingList.fromJson(v));
                      print(
                          'cashFreeBankList :: ${razorPayOrcashFreeBankList.length} $objStr');
                    } catch (e) {}
                  }
                }
              }
            }
          } else if (objPaymentMethods.method == 'card') {
            cardSource.value = objPaymentMethods.source;
          }
        }
      }

      Utils().customPrint(
          'response getPaymentGatewayData ${cashFreeModel.value.data.paymentMethods.length}');
      Utils().customPrint(
          'response getPaymentGatewayData ${cashFreeModel.value.data.razorpayMethods.wallet}');
      Utils().customPrint(
          'response getPaymentGatewayData ${cashFreeModel.value.data.cashfreeMethods}');
    } else {
      Utils().customPrint('response getPaymentGatewayData ERROR');
    }
  }

  Timer mytimer;
  Future<void> paymentGatewayNew(
      BuildContext context, Map<String, dynamic> param, source) async {
    //showProgress(context, '', false);
    Map<String, dynamic> response = await WebServicesHelper()
        .paymentGatewayNew(token, user_id, param, source);
    try {
      //hideProgress(context);
      if (response != null) {
        Utils().customPrint('paymentGatewayNew DATA:: ${response}');
        if (source == 'razorpay') {
          //**************************************************************
          razorpayResponseModel = RazorPayResponseModel.fromJson(response);
          if (response != null) {
            if (response['data'] != null &&
                response['data']['next'] != null &&
                response['data']['next'][0]['url'] != null) {
              Utils().customPrint(
                  'paymentGatewayNew URL:: ${razorpayResponseModel.data.next[0].url}');

              if (razorpayResponseModel.data.next[0].action == 'redirect') {
                //Fluttertoast.showToast(msg: 'redirecting...!');
                Get.to(() => CashFreeWebview(
                    razorpayResponseModel.data.next[0].url, source));
              } else if (razorpayResponseModel.data.next[0].action ==
                  'intent') {
                //Fluttertoast.showToast(msg: 'intent...!');
                String url = razorpayResponseModel.data.next[0].url;
                //'upi://pay?pa=9044503284@upi&pn=GMNGEntertainmentPrivateLimited&tr=xjMGEakzPjCWBrd&tn=razorpay&am=1&cu=INR&mc=5411';
                if (selectedUPIApp.value == 'GPay') {
                  Utils.launchURLApp(url.replaceRange(0, 9, 'tez://upi/pay'));
                } else if (selectedUPIApp.value == 'PhonePe') {
                  Utils.launchURLApp(url.replaceRange(0, 3, 'phonepe'));
                } else if (selectedUPIApp.value == 'Paytm') {
                  Utils.launchURLApp(url.replaceRange(0, 3, 'paytmmp'));
                }
                /* else if (selectedUPIApp.value == 'Amazon') {
                Utils.launchURLApp(
                    url.replaceRange(0, 9, 'amzn://apps/android'));
              }*/
                else if (selectedUPIApp.value == 'BHIM') {
                  Utils.launchURLApp(url.replaceRange(0, 3, 'bhim'));
                } else {
                  Utils.launchURLApp(url);
                }
                //here we call paymentGatewayStatusNew API.
              } else if (razorpayResponseModel.data.next[0].action == 'poll') {
                //Fluttertoast.showToast(msg: 'Please approve the payment in your UPI App');
                //Pop up screen visible
                showProgressDismissible(context);
                //API Call for status
                //status API call after few minutes
                mytimer = Timer.periodic(Duration(seconds: 10), (timer) {
                  //code to run on every 5 seconds
                  statusAPICallWithTimer(context);
                });
              }
            } else {
              Fluttertoast.showToast(msg: 'Url Not Found!');
            }
          }
        } else if (source == 'cashfree') {
          //**************************************************************
          cashFreeResponseModel = CashfreeResponseModel.fromJson(response);
          Utils().customPrint(
              'paymentGatewayNew cashFreeResponseModel:: ${response}');
          if (response != null) {
            if (response['data'] != null && response['data']['data'] != null) {
              if (cashFreeResponseModel.data.data.url != null) {
                Utils().customPrint(
                    'paymentGatewayNew URL:: ${cashFreeResponseModel.data.data.url}');
                //Fluttertoast.showToast(msg: 'redirecting...!');
                Get.to(() => CashFreeWebview(
                    cashFreeResponseModel.data.data.url, source));
              } else if (cashFreeResponseModel.data.data.payload != null) {
                //Fluttertoast.showToast(msg: 'intent...!');

                /*var url =
                    'paytmmp://pay?pa=cf.palynne@hdfcbank&pn=Kundan%20Shop&tr=1138534995&am=1.00&cu=INR&mode=00&purpose=00&mc=5732&tn=test%20note';
                Utils.launchURLApp(url);*/
                if (selectedUPIApp.value == 'GPay') {
                  String url = cashFreeResponseModel.data.data.payload.gpay;
                  Utils.launchURLApp(url);
                } else if (selectedUPIApp.value == 'PhonePe') {
                  String url = cashFreeResponseModel.data.data.payload.phonepe;
                  Utils.launchURLApp(url);
                } else if (selectedUPIApp.value == 'Paytm') {
                  String url = cashFreeResponseModel.data.data.payload.paytm;
                  Utils.launchURLApp(url);
                }
                /* else if (selectedUPIApp.value == 'Amazon') {
                Utils.launchURLApp(
                    url.replaceRange(0, 9, 'amzn://apps/android'));
              }*/
                else if (selectedUPIApp.value == 'BHIM') {
                  String url = cashFreeResponseModel.data.data.payload.bhim;
                  Utils.launchURLApp(url);
                } else {
                  String url =
                      cashFreeResponseModel.data.data.payload.web; //default
                  Utils.launchURLApp(url);
                }
              }
            } else {
              Fluttertoast.showToast(msg: 'Url Not Found!');
            }
          }
        }
      }
    } catch (e) {
      //hideProgress(context);
      Utils().customPrint('paymentGatewayNew Error:: ${e}');
      Fluttertoast.showToast(msg: 'Url Not Found!');
    }
  }

  Future<void> paymentGatewayStatusNew(
      BuildContext context, Map<String, dynamic> param, source) async {
    //showProgress(context, '', true);
    Map<String, dynamic> response = await WebServicesHelper()
        .paymentGatewayStatusNew(token, user_id, param, source);
    try {
      if (response != null) {
        //hideProgress(context);
        Utils().customPrint('paymentGatewayStatusNew DATA:: ${response}');
        cashFreeStatusModel = CashfreeStatusModel.fromJson(response);
        if (response != null) {
          if (cashFreeStatusModel != null && cashFreeStatusModel.data != null) {
            if (cashFreeStatusModel.data.success == true) {
              AppString.instanceAddDepositTime = true;
              //Event Work................
              paymentSuccessEvent(walletPageController.payment_method);
              //end.........................
              //payment deposited successfully
              UserController controller = Get.find();
              controller.currentIndex.value = 4;
              controller.getWalletAmount();
              Get.offAll(() => DashBord(4, ""));
              Fluttertoast.showToast(msg: 'Payment deposited successfully'.tr);

              //POPUP
              //walletPageController.showCustomDialogConfetti(navigatorKey.currentState.context);
              walletPageController.showCustomDialogConfettiNew();

              //for updation of progressbar value
              await controller.getProfileData();
              await walletPageController.getProfileData();
              await controller.getVIPLevel();
              await walletPageController.getPromoCodesBannerData();
              try {
                //Utils().customPrint('TEST:::instantCash: ${controller.instantCashLimitNextLevel.value}');
                Utils().customPrint('TEST1:::instantCash: test0');
                if (controller.instantCashLimitNextLevel.value != null &&
                    controller.instantCashLimitNextLevel.value > 0) {
                  Utils().customPrint('TEST1:::instantCash: test1');
                  Utils().customPrint(
                      'TEST1:::instantCash: ${controller.profileDataRes.value.stats.instantCash.value}');
                  Utils().customPrint(
                      'TEST1:::instantCashLimitNextLevel: ${controller.instantCashLimitNextLevel.value}');
                  walletPageController
                      .percentageVipProgressCircularBar.value = (((controller
                                  .profileDataRes
                                  .value
                                  .stats
                                  .instantCash
                                  .value /
                              100) /
                          (controller.instantCashLimitNextLevel.value / 100)) *
                      1);
                  if (walletPageController
                          .percentageVipProgressCircularBar.value >
                      1) {
                    walletPageController
                        .percentageVipProgressCircularBar.value = 1;
                  }
                  Utils().customPrint(
                      'TEST1::::Success ${walletPageController.percentageVipProgressCircularBar.value}');
                } else {
                  walletPageController.percentageVipProgressCircularBar.value =
                      1;
                  Utils().customPrint('TEST:::instantCash: test2');
                }
              } catch (e) {
                Utils().customPrint('TEST1::::Error ${e.toString()}');
              }
            } else if (cashFreeStatusModel.data.success == false) {
              //Event Work................
              paymentFailedEvent(walletPageController.payment_method);
              //end.........................
              if (cashFreeStatusModel.data.error != null) {
                UserController controller = Get.find();
                controller.currentIndex.value = 4;
                controller.getWalletAmount();
                Get.offAll(() => DashBord(4, ""));
                Fluttertoast.showToast(
                    msg: cashFreeStatusModel.data.error.description);
              } else {
                //Same API call again after few seconds
                //Fluttertoast.showToast(msg: 'No Status Found!');
              }
            }
          }
        }
      }
    } catch (e) {
      //hideProgress(context);
      Utils().customPrint('paymentGatewayStatusNew Error:: ${e}');
      Fluttertoast.showToast(msg: 'Url Not Found!');
    }
  }

  //RAZORPAY
  RxList razorPayOrcashFreeBankList = new List<NetBankingList>().obs;
  RxList walletList = new List<WalletList>().obs;

  List<String> razorPayWalletListHelper = [
    "OlaMoney",
    "MobiKwik",
    "RelianceJioMoney",
    "AirtelMoney",
    "PhonePe",
    "PayZapp"
  ];

  List<String> cashFreeWalletListHelper = [
    "FreeCharge",
    "MobiKwik",
    "OlaMoney",
    "RelianceJioMoney",
    "Paytm",
    "UnionBankOfIndia",
    "AmazonPay",
    "PhonePe",
  ];

  //CASHFREE
  //RxList cashFreeBankList = new List<NetBankingList>().obs;
  //List<NetBankingList> razorPayBankList = [].obs;

  List<String> razorPayBankListHelper = [
    "BankOfBarodaRetail",
    "CatholicSyrianBank",
    "DCBBankPersonal",
    "IndianBank",
    "SaraswatBank",
    "UnionBankOfIndia",
    "UjjivanSmallFinanceBank",
    "UnitedBankOfIndia",
    "OrientalBankOfCommerce"
  ];

  List<String> cashFreeBankListHelper = [
    "AxisBank",
    "BankOfBarodaRetail",
    "BankOfIndia",
    "BankOfMaharashtra",
    "CanaraBank",
    "CatholicSyrianBank",
    "CentralBankOfIndia",
    "CityUnionBank",
    "DeutscheBank",
    "DBSBank",
    "DCBBankPersonal",
    "DhanlakshmiBank",
    "FederalBank",
    "HDFCBank",
    "ICICIBank",
    "IDBIBank",
    "IDFCFIRSTBank",
    "IndianBank",
    "IndianOverseasBank",
    "IndusIndBank",
    "JammuAndKashmirBank",
    "KarnatakaBank",
    "KarurVysyaBank",
    "KotakMahindraBank",
    "LaxmiVilasBankRetail",
    "PunjabSindBank",
    "PunjabNationalBankRetail",
    "RBLBank",
    "SaraswatBank",
    "ShamraoVitthalCoOpBank",
    "SouthIndianBank",
    "StandardCharteredBank",
    "StateBankOfIndia",
    "TamilNaduStateCoOpBank",
    "TamilnadMercantileBank",
    "UCOBank",
    "UnionBankOfIndia",
    "YesBank",
    "BankOfBarodaCorporate",
    "BankOfIndiaCorporate",
    "DCBBankCorporate",
    "LakshmiVilasBankCorporate",
    "PunjabNationalBankCorporate",
    "StateBankOfIndiaCorporate",
    "UnionBankOfIndiaCorporate",
    "AxisBankCorporate",
    "DhanlaxmiBankCorporate",
    "ICICICorporate",
    "RatnakarCorporate",
    "ShamraoVithalBankCorporate",
    "EquitasSmallFinanceBank",
    "YesBankCorporate",
    "BandhanBankCorporatebanking",
    "BarclaysCorporate",
    "IndianOverseasBankCorporate",
    "CityUnionBankOfCorporate",
    "HDFCCorporate",
    "ShivalikBank",
    "AUSmallFinance",
    "BandhanBankRetail",
    "UtkarshSmallFinanceBank",
    "TheSuratPeopleCoOpBank",
    "GujaratStateCoOpBank",
    "HSBCRetail",
    "AndhraPragathiGrameenaBank",
    "BassienCatholicCoOpBank",
    "CapitalSmallFinanceBank",
    "ESAFSmallFinanceBank",
    "FincareBank",
    "JanaSmallFinanceBank",
    "JioPaymentsBank",
    "JanataSahakariBankPune",
    "KalyanJanataSahakariBank",
    "TheKalupurCommercialCoOpBank",
    "KarnatakaVikasGrameenaBank",
    "MaharashtraGraminBank",
    "NorthEastSmallFinanceBank",
    "NKGSBCoOpBank",
    "KarnatakaGraminBank",
    "RBLBankLimitedCorporate",
    "SBMBankIndia",
    "SuryodaySmallFinanceBank",
    "TheSutexCoOpBank",
    "ThaneBharatSahakariBank",
    "TJSBBank",
    "VarachhaCoOpBank",
    "ZoroastrianCoOpBank",
    "UCOBankCorporate",
    "AirtelPaymentsBank"
  ];

  Future<void> generateCashFreeTokenR(String enterAmountS, String username,
      String email, String mobile, String order_id) async {
    int enterAmount = 0;
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    try {
      enterAmount = int.parse(enterAmountS);
    } catch (E) {}

    //String orderId= BaseController().getRandomString(12);

    var payload = {
      "orderId": "$order_id",
      "amount": enterAmount * 100,
      "currency": "INR"
    };

    Map<String, dynamic> response =
        await WebServicesHelper().generateCashFreeToken(payload, token);
    if (response != null) {
      Utils().customPrint(
          'getAppSetting ::::: data call ${response["data"]["cftoken"]}');
      makePayment(enterAmountS, username, email, mobile,
          response["data"]["cftoken"], order_id);
    } else {
      Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> createOrderRazorepay(BuildContext context, String promocode,
      String EnterAmount, String username, String email, String mobile) async {
    showProgress(context, "message", true);

    if (user_id == null && user_id.isEmpty) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }

    int amountS = int.parse(EnterAmount);
    int converAmmount = amountS * 100;
    var param;
    if (Utils.stateV.value != null && Utils.stateV.value.isNotEmpty) {
      param = {
        "amount": converAmmount.toString(),
        "currency": "INR",
        "receipt": "Test order -${converAmmount}",
        "notes": {
          "userId": user_id,
        },
        "promoCode": promocode != "" ? promocode : "",
        "data": {
          "state": Utils.stateV.value ?? "",
          "city": Utils.city.value ?? "",
        }
      };
    } else {
      param = {
        "amount": converAmmount.toString(),
        "currency": "INR",
        "receipt": "Test order -${converAmmount}",
        "notes": {
          "userId": user_id,
        },
        "promoCode": promocode != "" ? promocode : ""
      };
    }

    Map<String, dynamic> response_str =
        await WebServicesHelper().RazorepayCreateOrder(token, user_id, param);
    if (response_str != null) {
      hideProgress(context);
      RozerpayOrderid.value = CreateRozerpay.fromJson(response_str);
      generateCashFreeTokenR(
          EnterAmount, username, email, mobile, RozerpayOrderid.value.id);
    } else {
      // hideProgress(context);
      hideProgress(context);
      Fluttertoast.showToast(msg: "Please try again");
    }
  }

  makePayment(String enterAmountS, String username, String email, String mobile,
      String tokenDataS, String orderIdS) {
    //Replace with actual values
    String orderId = "$orderIdS";
    String stage = "TEST";
    String orderAmount = enterAmountS;
    String tokenData = tokenDataS;
    String customerName = username;
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = ApiUrl.client_ID;
    String customerPhone = "$mobile";
    String customerEmail = email != '' ? email : 'support@gmng.pro';
    String notifyUrl = "https://sandbox.cashfree.com";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,
      "paymentOption": ""
    };

    Utils().customPrint("cashfree inputParams");
    Utils().customPrint(inputParams);

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  //payment success event method
  paymentSuccessEvent(var payment_method) {
    Map<String, Object> map = new Map<String, Object>();
    Get.put(UserController()).callAllProfileData();

    map["Amount"] = walletPageController.selectAmount.value;
    //map["Revenue"] = amountTextController.value.text;
    map["Deposit Method"] = payment_method; //need to update
    //map["Deposit Failure"] = 'NO'; //need to ask
    map["USER_ID"] = user_id; //added for appsflyer

    if (walletPageController.promocode.value != null &&
        walletPageController.promocode.value != '') {
      map["Code Name"] = walletPageController.promocode.value;
      map["Code target wallet"] = walletPageController.walletTypePromocode;
      map["Code percentage"] = walletPageController.percentagePromocode;
    }

    cleverTapController.logEventCT(
        EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map);

    FirebaseEvent()
        .firebaseEvent(EventConstant.EVENT_FIREBASE_Deposit_Success, map);

    appsflyerController.logEventAf(
        EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map); //deposit success

    FaceBookEventController()
        .logEventFacebook(EventConstant.EVENT_Purchase, map);
    FirebaseEvent().firebaseEvent(EventConstant.EVENT_Purchase, map);

    FaceBookEventController().logEventFacebook(
        EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map); //deposit success

    //new Events
    try {
      FaceBookEventController().logPurchase(
          double.parse(walletPageController.selectAmount.value.toString()),
          map);
    } catch (e) {}

    //for Revenue
    Map<String, Object> map_appsflyer = new Map<String, Object>();
    map_appsflyer["af_revenue"] = walletPageController.selectAmount.value;
    map_appsflyer["af_currency"] = "INR";
    map_appsflyer["af_quantity"] = "1";
    map_appsflyer["af_content_id"] = "";
    map_appsflyer["af_order_id"] = "";
    map_appsflyer["af_receipt_id"] = "";
    appsflyerController.logEventAf(
        EventConstant.EVENT_NAME_af_purchase, map_appsflyer); //af_purchase
  }

  paymentFailedEvent(var payment_method) {
    //event handel
    AppsflyerController affiliatedController = Get.put(AppsflyerController());
    UserController _controller = Get.put(UserController());
    Map<String, Object> map = new Map<String, Object>();
    map["Amount"] = walletPageController.selectAmount.value;
    map["user_id"] = _controller.profileDataRes != null
        ? _controller.profileDataRes.value.id
        : "";
    map["USER_ID"] = _controller.profileDataRes != null
        ? _controller.profileDataRes.value.id
        : "";
    map["user_name"] = _controller.profileDataRes != null
        ? _controller.profileDataRes.value.username
        : "";
    map["Deposit Method"] = payment_method; //need to update
    map["Message"] = "payment error";

    Map<String, Object> mapD = new Map<String, Object>();
    map[""] = "";
    //removed
    CleverTapController cleverTapController = Get.put(CleverTapController());
    cleverTapController.logEventCT("Deposit Failed", mapD);

    FirebaseEvent().firebaseEvent(EventConstant.Deposit_Failed_F, mapD);
    affiliatedController.logEventAf(EventConstant.EVENT_ADD_MONEY_CANCEL, map);
  }

  showProgressDismissible(BuildContext context) async {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(0)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          "Please approve the payment in your UPI App",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat",
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Do not refresh this page or press back button",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Montserrat",
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void statusAPICallWithTimer(BuildContext context) {
    //Fluttertoast.showToast(msg: 'UPI Intent after 5 sec...');
    Utils().customPrint('UPI Intent after 30 sec...');
    if (upiSource == 'razorpay') {
      try {
        final param = {
          "paymentId": razorpayResponseModel.data.checkPayment.paymentId,
          "orderId": razorpayResponseModel.data.checkPayment.orderId,
          "userId": razorpayResponseModel.data.checkPayment.userId,
          "gateway": razorpayResponseModel.data.checkPayment.gateway
        };
        paymentGatewayStatusNewForAddUPI(context, param, upiSource);
      } catch (e) {
        //Utils().customPrint('UPI Intent after 15 sec...ERROR');
        Fluttertoast.showToast(
            msg: 'UPI Intent after 15 sec... ${e.toString()}');
      }
    } else {
      try {
        final param = {
          "paymentId": cashFreeResponseModel.data.checkPayment.paymentId,
          "orderId": cashFreeResponseModel.data.checkPayment.orderId,
          "userId": cashFreeResponseModel.data.checkPayment.userId,
          "gateway": cashFreeResponseModel.data.checkPayment.gateway
        };
        paymentGatewayStatusNewForAddUPI(context, param, upiSource);
      } catch (e) {
        Utils().customPrint('UPI Intent after 30 sec...ERROR');
        Fluttertoast.showToast(
            msg: 'UPI Intent after 30 sec... ${e.toString()}');
      }
    }
  }

  Future<void> paymentGatewayStatusNewForAddUPI(
      BuildContext context, Map<String, dynamic> param, source) async {
    //showProgress(context, '', true);
    Map<String, dynamic> response = await WebServicesHelper()
        .paymentGatewayStatusNew(token, user_id, param, source);
    try {
      if (response != null) {
        //hideProgress(context);
        Utils().customPrint('paymentGatewayStatusNew DATA:: ${response}');
        cashFreeStatusModel = CashfreeStatusModel.fromJson(response);
        if (response != null) {
          if (cashFreeStatusModel != null && cashFreeStatusModel.data != null) {
            if (cashFreeStatusModel.data.success == true) {
              AppString.instanceAddDepositTime = true;
              //Event Work................
              mytimer.cancel();
              paymentSuccessEvent(source);
              //end.........................
              //payment deposited successfully
              UserController controller = Get.find();
              controller.currentIndex.value = 4;
              controller.getWalletAmount();
              Get.offAll(() => DashBord(4, ""));
              Fluttertoast.showToast(msg: 'Payment deposited successfully'.tr);

              //walletPageController.showCustomDialogConfetti(navigatorKey.currentState.context);
              walletPageController.showCustomDialogConfettiNew(); //new popup
              //walletPageController.showCustomDialogConfetti(navigatorKey.currentState.context);

              //Navigator.pop(context);
              //for updation of progressbar value
              await controller.getProfileData();
              await walletPageController.getProfileData();
              await controller.getVIPLevel();
              await walletPageController.getPromoCodesBannerData();
              try {
                //Utils().customPrint('TEST:::instantCash: ${controller.instantCashLimitNextLevel.value}');
                Utils().customPrint('TEST1:::instantCash: test0');
                if (controller.instantCashLimitNextLevel.value != null &&
                    controller.instantCashLimitNextLevel.value > 0) {
                  Utils().customPrint('TEST1:::instantCash: test1');
                  Utils().customPrint(
                      'TEST1:::instantCash: ${controller.profileDataRes.value.stats.instantCash.value}');
                  Utils().customPrint(
                      'TEST1:::instantCashLimitNextLevel: ${controller.instantCashLimitNextLevel.value}');
                  walletPageController
                      .percentageVipProgressCircularBar.value = (((controller
                                  .profileDataRes
                                  .value
                                  .stats
                                  .instantCash
                                  .value /
                              100) /
                          (controller.instantCashLimitNextLevel.value / 100)) *
                      1);
                  if (walletPageController
                          .percentageVipProgressCircularBar.value >
                      1) {
                    walletPageController
                        .percentageVipProgressCircularBar.value = 1;
                  }
                  Utils().customPrint(
                      'TEST1::::Success ${walletPageController.percentageVipProgressCircularBar.value}');
                } else {
                  walletPageController.percentageVipProgressCircularBar.value =
                      1;
                  Utils().customPrint('TEST:::instantCash: test2');
                }
              } catch (e) {
                Utils().customPrint('TEST1::::Error ${e.toString()}');
              }
            } else if (cashFreeStatusModel.data.success == false) {
              //Event Work................

              //end.........................
              if (cashFreeStatusModel.data.error != null) {
                paymentFailedEvent(source);
                mytimer.cancel();
                UserController controller = Get.find();
                controller.currentIndex.value = 4;
                controller.getWalletAmount();
                Get.offAll(() => DashBord(4, ""));
                Fluttertoast.showToast(
                    msg: cashFreeStatusModel.data.error.description);

                //Navigator.pop(context);
              } else {
                //Same API call again after few seconds
                //Fluttertoast.showToast(msg: 'No Status Found!');
              }
            }
          }
        }
      }
    } catch (e) {
      //hideProgress(context);
      Utils().customPrint('paymentGatewayStatusNew Error:: ${e}');
      Fluttertoast.showToast(msg: 'Url Not Found!');
    }
  }

  void promocodeAutoFilled(String text) {
    walletPageController.selectAmount.value = text;
    walletPageController.amountTextController.value.text = text;

    if (walletPageController.walletModelPromo.data != null &&
        walletPageController.walletModelPromo.data.length > 0) {
      //GREATER THAN CONDITION
      walletPageController.typeTextCheck.value = 0;
      for (int i = 0;
          i < walletPageController.walletModelPromo.data.length;
          i++) {
        int enteredValue = int.parse(text);
        promocodeValue =
            int.parse(walletPageController.walletModelPromo.data[i].fromValue);
        Utils().customPrint(
            "PROMOCODE FRM GREATER AMT ${walletPageController.walletModelPromo.data[i].fromValue}");

        if (promocodeValue > enteredValue) {
          //saving values
          walletPageController.promo_type.value = walletPageController
              .walletModelPromo.data[i].benefit[0].wallet[0].type;

          walletPageController.promo_minus_amt.value =
              promocodeValue - enteredValue;
          int max_per = int.parse(walletPageController
              .walletModelPromo.data[i].benefit[0].wallet[0].percentage);
          walletPageController.promo_amt.value =
              (promocodeValue * (max_per / 100));

          walletPageController.typeTextCheck.value = 1; //greater

          walletPageController.promo_maximumAmt.value = int.parse(
              walletPageController
                  .walletModelPromo.data[i].benefit[0].wallet[0].maximumAmount);
          if (walletPageController.promo_amt.value >
              walletPageController.promo_maximumAmt.value) {
            walletPageController.profitAmt.value = enteredValue +
                double.parse(
                    walletPageController.promo_maximumAmt.value.toString());
          } else {
            walletPageController.profitAmt.value =
                promocodeValue + walletPageController.promo_amt.value;
          }
          promocodeHelper.value =
              walletPageController.walletModelPromo.data[i].code;
          try {
            //for cleverTap use
            double percentage = double.parse(walletPageController
                .walletModelPromoFull.data[i].benefit[0].wallet[0].percentage);
            walletPageController.percentagePromocode = percentage.toString();
            walletPageController.walletTypePromocode = walletPageController
                .walletModelPromoFull.data[i].benefit[0].wallet[0].type;
          } catch (e) {}

          Utils().customPrint('PROMOCODES GREATER *******************  '
              'CODE: ${walletPageController.walletModelPromo.data[i].code} |'
              'TYPE: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].type} |'
              '%: ${walletPageController.walletModelPromo.data[i].benefit[0].wallet[0].percentage}% |'
              ' calc%: ${walletPageController.promo_amt.value} |'
              'FROM: ${walletPageController.walletModelPromo.data[i].fromValue}|'
              'TO: ${walletPageController.walletModelPromo.data[i].toValue}|'
              'GET AMT: ${walletPageController.profitAmt.value}|'
              'MAX: ${walletPageController.promo_maximumAmt.value}');

          break;
        }
      }
      //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      if (walletPageController.typeTextCheck.value == 0 ||
          walletPageController.typeTextCheck.value == 2) {
        //EQUAL TO CONDITION
        int enteredValue = int.parse(text);

        promocodeValue = int.parse(walletPageController
            .walletModelPromo
            .data[walletPageController.walletModelPromo.data.length - 1]
            .fromValue);
        int promocodeToValue = int.parse(walletPageController
            .walletModelPromo
            .data[walletPageController.walletModelPromo.data.length - 1]
            .toValue);
        Utils().customPrint("--------");
        Utils().customPrint(
            "PROMOCODE FRM EQUAL AMT ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].fromValue}");
        Utils().customPrint(
            "PROMOCODE TO EQUAL AMT ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].toValue}");

        if (enteredValue >= promocodeValue &&
            enteredValue <= promocodeToValue) {
          Utils().customPrint('PROMOCODES EQUALS/BWT *******************  '
              '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].code} |'
              '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].type} |'
              '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].percentage}% |'
              '${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].fromValue}|'
              'MAX: ${walletPageController.walletModelPromo.data[walletPageController.walletModelPromo.data.length - 1].benefit[0].wallet[0].maximumAmount}');
          //saving values
          walletPageController.promo_type.value = walletPageController
              .walletModelPromo
              .data[walletPageController.walletModelPromo.data.length - 1]
              .benefit[0]
              .wallet[0]
              .type;

          walletPageController.promo_minus_amt.value =
              promocodeValue - enteredValue;
          int max_per = int.parse(walletPageController
              .walletModelPromo
              .data[walletPageController.walletModelPromo.data.length - 1]
              .benefit[0]
              .wallet[0]
              .percentage);
          walletPageController.promo_amt.value =
              (enteredValue * (max_per / 100));

          walletPageController.typeTextCheck.value = 2; //eqauls
          promocodeHelper.value = walletPageController.walletModelPromo
              .data[walletPageController.walletModelPromo.data.length - 1].code;

          try {
            //for cleverTap use
            double percentage = double.parse(walletPageController
                .walletModelPromoFull
                .data[walletPageController.walletModelPromo.data.length - 1]
                .benefit[0]
                .wallet[0]
                .percentage);
            walletPageController.percentagePromocode = percentage.toString();
            walletPageController.walletTypePromocode = walletPageController
                .walletModelPromoFull
                .data[walletPageController.walletModelPromo.data.length - 1]
                .benefit[0]
                .wallet[0]
                .type;
          } catch (e) {}

          walletPageController.promo_maximumAmt.value = int.parse(
              walletPageController
                  .walletModelPromo
                  .data[walletPageController.walletModelPromo.data.length - 1]
                  .benefit[0]
                  .wallet[0]
                  .maximumAmount);
          if (walletPageController.promo_amt.value >
              walletPageController.promo_maximumAmt.value) {
            walletPageController.profitAmt.value = enteredValue +
                double.parse(
                    walletPageController.promo_maximumAmt.value.toString());
          } else {
            walletPageController.profitAmt.value =
                enteredValue + walletPageController.promo_amt.value;
          }
        }
      }
    }
  }
}
