/*import 'dart:convert';
import 'dart:io';
*/ /*import 'dart:ui';*/ /*

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/wallet/OfferWall/GetUserDealsModel.dart';
import 'package:gmng/model/wallet/OfferWall/OfferWallModel.dart';
import 'package:gmng/model/wallet/WithdrawRequest.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/res/ImageRes.dart';
import 'package:gmng/routes/routes.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/BannerModel/BannerResC.dart';
import '../../model/CreateRozerpay.dart';
import '../../model/ProfileModel/ProfileDataR.dart';
import '../../model/basemodel/AppBaseErrorResponse.dart';
import '../../model/responsemodel/InvoidModel.dart';
import '../../model/wallet/Transaction.dart';
import '../../model/wallet/WalleModelR.dart';
import '../../res/firebase_events.dart';
import '../../utills/Utils.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/CleverTapController.dart';
import '../../utills/event_tracker/EventConstant.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../utills/loader.dart';
import '../../webservices/WebServicesHelper.dart';
import '../dialog/helperProgressBar.dart';*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/model/ProfileModel/ProfileDataR.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/controller/user_controller.dart';
import 'package:gmng/ui/main/wallet/vip_program_screen.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/utills/event_tracker/CleverTapController.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../app.dart';
import '../../model/BannerModel/BannerResC.dart';
import '../../model/CreateRozerpay.dart';
import '../../model/basemodel/AppBaseErrorResponse.dart';
import '../../model/responsemodel/InvoidModel.dart';
import '../../model/wallet/OfferWall/GetUserDealsModel.dart';
import '../../model/wallet/OfferWall/OfferWallModel.dart';
import '../../model/wallet/Transaction.dart';
import '../../model/wallet/WalleModelR.dart';
import '../../model/wallet/WithdrawRequest.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../../res/firebase_events.dart';
import '../../routes/routes.dart';
import '../../utills/event_tracker/AppsFlyerController.dart';
import '../../utills/event_tracker/EventConstant.dart';
import '../../utills/event_tracker/FaceBookEventController.dart';
import '../../utills/loader.dart';
import '../../webservices/WebServicesHelper.dart';
import '../dialog/helperProgressBar.dart';

class WalletPageController extends GetxController
    with GetTickerProviderStateMixin {
  var scrollcontroller = ScrollController();
  UserController controller = Get.put(UserController());
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var checkTr = true.obs;
  var walletModelR = WalletModelR().obs();
  var walletModelPromo = WalletModelR().obs();
  var walletModelPromoFull = WalletModelR().obs();
  var walletModelPromoBanner = WalletModelR().obs;
  var walletIdWithdraw = "".obs;
  var profileDataRes = ProfileDataR().obs;
  var selectAmount = "".obs;
  SharedPreferences prefs;
  var checkRealMoneyOrGMNG = false.obs;
  var type_kyc_document = "".obs;
  var sliderTrue = false.obs;
  var totalAmountValues = 0.obs;
  String token;

  var pennyDropSummaryAmount = 0.obs;

  var pennyDropLockCon = false.obs;

  String user_id, user_mobileNo;
  var result = "Slide to complete KYC".obs;
  Razorpay _razorpay;
  var imageFile;
  var imageFile_camera;
  var path_call_camera;

  var imageFileBack;
  var path_call;
  var back_path_call;

  var RozerpayOrderid = CreateRozerpay().obs;
  var amountTextController = TextEditingController(text: "").obs;
  String wallet_id = "";
  String wallet_id_winning = "";
  var currentpage = 0.obs;
  var total_limit = 10;
  var boolEnterCode = false.obs;
  var promocode = "".obs;
  var gameListSelectedColor = 1000.obs;
  var gameAmtSelectedColor = 0.obs;
  var amtAfterPromoApplied = 0.0.obs;
  var ApplyBtnText = 'Apply'.obs;
  var youWillGet = ''.obs;
  var walletTypePromocode = "";
  var percentagePromocode = "";
  var transactionModelR = Transaction().obs;
  RxList transtsionlist = new List<TransactionList>().obs;
  var whatsAppNo = "";
  bool click = false;
  var selectedList; //for offerwall use
  var isLoadingAdvertisersDeals = false.obs;

  //new work
  var withdrawRequestModelR = WithdrawRequestNew().obs;

//  RxList withdrawRequestlist = new List<WithdrawRequestNewList>().obs;

  //offer wall work
  var colorPrimaryOfferWall = Color(0xFFe55f19).obs;
  var colorwhiteOfferWall = Color(0xFFeffffff).obs;
  var checkTrOfferWall = true.obs;

  var offerWallList = OfferWallModel().obs;
  var offerWallListPopup = OfferWallModel().obs;
  var offerWallHistoryList = GetUserDealsModel().obs;
  var isExpired = false.obs;
  String bannerType = "wallet";
  var bannerModelRV = BannerModelR().obs;
  var bannerModelOfferWallRV = BannerModelR().obs;

  var buttonApplyText = "Apply".tr.obs;
  var havCodeController = TextEditingController(text: "").obs;

  //NEW CODE FOR ADD CASH PROMOCODES
  var promo_type = "".obs;
  var promo_amt = 0.0.obs;
  var promo_minus_amt = 0.obs;
  var typeTextCheck = 0.obs;
  var applyPress = false.obs;
  var profitAmt = 0.0.obs;
  var promo_maximumAmt = 0.obs;

  var viewMore = false.obs;
  var payment_method = '';
  AnimationController animationController;

  //new work Vip level
  var currentIndexSlider = 2.obs;
  var appBtnBgColor = const Color(0xFFc23705).obs;
  var appBtnTxtColor = const Color(0xffFFFFFF).obs;
  var percentageVipProgressCircularBar = 0.0.obs;

  //vip new layout
  var currentIndexSliderVip = 0.obs;
  var appBtnBgColorVip = const Color(0xFF000000).obs;
  var appBtnTxtColorVip = const Color(0xffFFFFFF).obs;
  var totalAmountD_W = 0.0.obs;
  var isclickpopup = false.obs;

  //new code for guided tour
  TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  GlobalKey keyButton6 = GlobalKey();

  //Handle KYC Slide
  var varTimerForKycHelper = 0.obs;
  var isLoadingProfileAPI = false.obs;

  @override
  Future<void> onInit() async {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    super.onInit();

    // scrollcontroller = ScrollController()..addListener(pagination);
    transactionModelR.value = null;
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.atEdge &&
          scrollcontroller.position.pixels != 0) {
        if (totalAmountValues > currentpage.value) {
          currentpage.value = currentpage.value + 10;
          getTransaction();
          getWithdrawRequest();
        }

        Utils().customPrint("data pagination");
        /* if (maxPaginationCount.value > paginationPage.value) {
            pageLoading.value = true;
            getProductList();
          } else {
            noMoreItems.value = true;
          }*/
      }
    });

    _razorpay = Razorpay();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    user_mobileNo = prefs.getString("user_mobileNo");

    //whatsapp dynamic no.
    whatsAppNo = prefs.getString("whatsappMobile");
    getAdvertisersDeals();
    getUserDeals();
    getWithdrawSummary();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    if (user_id != null && user_id != '') {
      getWalletAmount();
    }

    transactionModelR.value = null;

    await getProfileData();
    //offerWall API

    getBanner();
    getBannerForOfferWall();

    //promo codes api call
    getPromoCodesData();
    //promo banner codes api call

    Future.delayed(const Duration(seconds: 3), () async {
      await getPromoCodesBannerData();
      try {
        //Utils().customPrint('TEST:::instantCash: ${controller.instantCashLimitNextLevel.value}');
        Utils().customPrint('TEST:::instantCash: test0');
        if (controller.instantCashLimitNextLevel.value != null &&
            controller.instantCashLimitNextLevel.value > 0) {
          Utils().customPrint('TEST:::instantCash: test1');
          Utils().customPrint(
              'TEST:::instantCash: ${controller.profileDataRes.value.stats.instantCash.value}');
          Utils().customPrint(
              'TEST:::instantCashLimitNextLevel: ${controller.instantCashLimitNextLevel.value}');
          var tempValue =
              (((controller.profileDataRes.value.stats.instantCash.value /
                          100) /
                      (controller.instantCashLimitNextLevel.value / 100)) *
                  1);
          if (tempValue > 1) {
            percentageVipProgressCircularBar.value = 1;
          } else {
            if (tempValue == 0) {
              percentageVipProgressCircularBar.value = 0.01;
            } else {
              percentageVipProgressCircularBar.value = tempValue;
            }
          }
          Utils().customPrint(
              'TEST::::Success ${percentageVipProgressCircularBar.value}');
        } else {
          percentageVipProgressCircularBar.value = 1;
          Utils().customPrint('TEST:::instantCash: LEVEL EXCEED');
        }
      } catch (e) {
        Utils().customPrint('TEST::::Error ${e.toString()}');
      }
    });

    //Vip Progress
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    _razorpay.clear();
  }

  Future<void> createOrderRazorepay(
      BuildContext context, String EnterAmount) async {
    showProgress(context, "message", true);

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
        "promoCode": promocode.value != "" ? promocode.value : "",
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
        "promoCode": promocode.value != "" ? promocode.value : ""
      };
    }

    Map<String, dynamic> response_str =
        await WebServicesHelper().RazorepayCreateOrder(token, user_id, param);
    if (response_str != null) {
      //hideProgress(context);
      hideProgress(context);
      RozerpayOrderid.value = CreateRozerpay.fromJson(response_str);

      // makeUpiPayment(RozerpayOrderid.value.id);

      //  RozerpayOrderid.value.id

      openCheckout(
          profileDataRes.value.username,
          (profileDataRes.value.email != null &&
                  profileDataRes.value.email.address != null)
              ? profileDataRes.value.email.address
              : "",
          profileDataRes.value.mobile.number.toString(),
          EnterAmount);
    } else {
      // hideProgress(context);
      hideProgress(context);
      Fluttertoast.showToast(msg: "Please try again");
    }
  }

  Future<void> createOrderRazorepayOld(
      BuildContext context, String EnterAmount) async {
    //showProgress(context, "message", false);
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
        "promoCode": promocode.value != "" ? promocode.value : "",
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
        "promoCode": promocode.value != "" ? promocode.value : ""
      };
    }

    Map<String, dynamic> response_str =
        await WebServicesHelper().RazorepayCreateOrder(token, user_id, param);
    //hideProgress(context);
    if (response_str != null) {
      //hideProgress(context);

      RozerpayOrderid.value = CreateRozerpay.fromJson(response_str);

      // makeUpiPayment(RozerpayOrderid.value.id);

      //  RozerpayOrderid.value.id

      openCheckoutOld(
          profileDataRes.value.username,
          (profileDataRes.value.email != null &&
                  profileDataRes.value.email.address != null)
              ? profileDataRes.value.email.address
              : "",
          profileDataRes.value.mobile.number.toString(),
          EnterAmount);
    } else {
      Fluttertoast.showToast(msg: "Please try again");
    }
  }

  Future<void> makeUpiPayment(String RozerpayOrderidid) async {
    // print(_selectedApp["id"]);
    //Replace with actual values
    String orderId = RozerpayOrderidid;
    String stage = "TEST";
    String orderAmount = "2";
    String tokenData = "2";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String customerPhone = "6307558161";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "";

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
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doUPIPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  Future<void> RozerpayOrderUpadte(
      String razorpayPaymentId, String razorpayOrderId) async {
    // showLoader();
    final param = {
      "razorpayPaymentId": razorpayPaymentId,
      "razorpayOrderId": razorpayOrderId,
      "userId": user_id,
    };
    var response_str =
        await WebServicesHelper().RozerpayOrderUpadte(token, user_id, param);
    Utils().customPrint("Status code ${response_str.statusCode}");
    // hideLoader();
    if (response_str != null && response_str.statusCode == 200) {
      Fluttertoast.showToast(msg: "Payment desposited successfully.");
      UserController _controller = Get.put(UserController());

      _controller.callAllProfileData();
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  void openCheckoutOld(
      String username, String email, String mobile, EnterAmount) async {
    //getFirstTimeDepositStatus('10');

    int amountS = int.parse(EnterAmount);
    int converAmmount = amountS * 100;
    var options = {
      'key': ApiUrl.ROZERPAY_KEY,
      //'key':'rzp_live_WX6r5eLox4PLrL',
      'amount': converAmmount,
      'order_id': RozerpayOrderid.value.id,
      'name': '$username',
      'description': 'Wallet Recharge',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      //'prefill': {'contact': '$mobile', 'email': '${email},'},
      'prefill': {
        'name': '$username',
        'email': email != '' ? email : 'support@gmng.pro',
        'contact': '$mobile'
      },

      "method": {
        "netbanking": true,
        "card": true,
        "upi": true,
        "wallet": true,
        "paylater": true,
        "emi": true,
      },

      /* "method": {
        "netbanking": false,
        "card": false,
        "upi": false,
        "wallet": true,
        "paylater": false,
        "emi": false,

      },*/
      /* 'external': {
        'wallets': ['paytm', 'freecharge', 'mobikwik'],
      },*/
      "config": {
        "display": {
          "hide": [
            {"method": "emi", "method": "paylater"}
          ],
          "preferences": {
            "show_default_blocks": "true",
          },
        },
      }
    };
    Utils().customPrint("options");
    Utils().customPrint(options);
    try {
      _razorpay.open(options);
    } catch (e) {
      Utils().customPrint("error call");
      Utils().customPrint(e);
    }
  }

  void openCheckout(
      String username, String email, String mobile, EnterAmount) async {
    //getFirstTimeDepositStatus('10');

    int amountS = int.parse(EnterAmount);
    int converAmmount = amountS * 100;
    var options = {
      'key': ApiUrl.ROZERPAY_KEY,
      //'key':'rzp_live_WX6r5eLox4PLrL',
      'amount': converAmmount,
      'order_id': RozerpayOrderid.value.id,
      //'name': '$username',
      'description': 'Wallet Recharge',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      //'prefill': {'contact': '$mobile', 'email': '${email},'},
      'prefill': {
        // 'name': '$username',
        'email': email != '' ? email : 'support@gmng.pro',
        'contact': '$mobile'
      },

      "method": {
        "netbanking": false,
        "card": true,
        "upi": false,
        "wallet": false,
        "paylater": false,
        "emi": false,
      },

      /* "method": {
        "netbanking": false,
        "card": false,
        "upi": false,
        "wallet": true,
        "paylater": false,
        "emi": false,

      },*/
      /* 'external': {
        'wallets': ['paytm', 'freecharge', 'mobikwik'],
      },*/
      "config": {
        "display": {
          "hide": [
            {"method": "emi", "method": "paylater"}
          ],
          "preferences": {
            "show_default_blocks": "true",
          },
        },
      }
    };
    Utils().customPrint("options");
    Utils().customPrint(options);
    try {
      _razorpay.open(options);
    } catch (e) {
      Utils().customPrint("error call");
      Utils().customPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(msg: "payment_sucess: ${response}");
    Utils().customPrint("payment_sucess ${response.orderId}");

    RozerpayOrderUpadte(response.paymentId, response.orderId);
    currentpage.value = 0;
    getTransaction();
    getWithdrawRequest(); //calling withdrawal pending API
    AppString.instanceAddDepositTime = true;
    //Event Work
    Map<String, Object> map = new Map<String, Object>();
    Get.put(UserController()).callAllProfileData();

    map["Amount"] = amountTextController.value.text;
    //map["Revenue"] = amountTextController.value.text;
    map["Deposit Method"] = payment_method; //need to update
    //map["Deposit Failure"] = 'NO'; //need to ask
    map["USER_ID"] = user_id;

    if (promocode.value != null && promocode.value != '') {
      map["Code Name"] = promocode.value;
      map["Code target wallet"] = walletTypePromocode;
      map["Code percentage"] = percentagePromocode;
    }
    AppsflyerController appsflyerController = Get.put(AppsflyerController());
    CleverTapController cleverTapController = Get.put(CleverTapController());
    FirebaseEvent()
        .firebaseEvent(EventConstant.EVENT_FIREBASE_Deposit_Success_F, map);
    cleverTapController.logEventCT(
        EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map);
    appsflyerController.logEventAf(
        EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map); //deposit success
    FaceBookEventController().logEventFacebook(
        EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map); //deposit success

    //for Revenue
    Map<String, Object> map_appsflyer = new Map<String, Object>();
    map_appsflyer["af_revenue"] = amountTextController.value.text;
    map_appsflyer["af_currency"] = "INR";
    map_appsflyer["af_quantity"] = "1";
    map_appsflyer["af_content_id"] = "";
    map_appsflyer["af_order_id"] = "";
    map_appsflyer["af_receipt_id"] = "";
    appsflyerController.logEventAf(
        EventConstant.EVENT_NAME_af_purchase, map_appsflyer); //af_purchase

    //API call for FTD
    //getFirstTimeDepositStatus(amountTextController.value.text);

    hideLoader();

    //show confetii popup
    //showCustomDialogConfetti(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Utils().customPrint("faild deposit Razorpay$response");
    //event handel
    AppsflyerController affiliatedController = Get.put(AppsflyerController());
    UserController _controller = Get.put(UserController());
    Map<String, Object> map = new Map<String, Object>();
    map["Amount"] = amountTextController.value.text;
    map["user_id"] = _controller.profileDataRes != null
        ? _controller.profileDataRes.value.id
        : "";
    map["USER_ID"] = _controller.profileDataRes != null
        ? _controller.profileDataRes.value.id
        : "";
    map["user_name"] = _controller.profileDataRes != null
        ? _controller.profileDataRes.value.username
        : "";
    map["Deposit_Method"] = payment_method;
    map["Message"] = "payment error";

    Map<String, Object> mapD = new Map<String, Object>();
    map[""] = "";
    //removed
    CleverTapController cleverTapController = Get.put(CleverTapController());
    cleverTapController.logEventCT("Deposit Failed", mapD);
    affiliatedController.logEventAf(EventConstant.EVENT_ADD_MONEY_CANCEL, map);
    FaceBookEventController()
        .logEventFacebook(EventConstant.Deposit_Failed_F, map);
    FirebaseEvent().firebaseEvent(EventConstant.Deposit_Failed_F, map);
    //hideLoader();

    //  Get.to(()=>Wallet());
    /*Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);*/
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    hideLoader();

    // Get.to(()=>Wallet());
    //Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ");
  }

  Future<void> getWalletAmount() async {
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getWalletData(token, user_id);
    if (responsestr != null) {
      walletModelR = WalletModelR.fromJson(responsestr);
      wallet_id =
          "${walletModelR.data[0].id},${walletModelR.data[1].id},${walletModelR.data[2].id},${walletModelR.data[3].id},${walletModelR.data[4].id}";
      var winning_bal, deposit_bal;
      Utils().customPrint('all wallates -> ${wallet_id}');
      for (int a = 0; walletModelR.data.length > a; a++) {
        if (walletModelR.data[a].type.compareTo("deposit") == 0) {
          AppString.depositWalletId = walletModelR.data[a].id;
          Utils().customPrint('depositWalletId : ${walletModelR.data[a].id}');
          deposit_bal = walletModelR.data[a].balance;
        } else if (walletModelR.data[a].type.compareTo("winning") == 0) {
          walletIdWithdraw.value = walletModelR.data[a].id;
          wallet_id_winning = walletModelR.data[a].id;
          winning_bal = walletModelR.data[a].balance;
        } else if (walletModelR.data[a].type.compareTo("bonus") == 0) {
          //bonus.value = walletModelR.data[a].balance;
        } else if (walletModelR.data[a].type.compareTo("coin") == 0) {
          //gmng_coin.value = walletModelR.data[a].balance;
        } else if (walletModelR.data[a].type.compareTo("instantCash") == 0) {
          //gmng_coin.value = walletModelR.data[a].balance;
        }
      }

      totalAmountD_W.value = (winning_bal / 100 + deposit_bal ~/ 100);
      //totalAmountD_W.value = total.toPrecision(2);
      print("totalAmountD_W: ${totalAmountD_W.value}");
      if (totalAmountD_W.value >= 5) {
        isclickpopup.value = false;
      }
      print("totalAmountD_W: true/false ${isclickpopup.value}");

      //new
      getTransaction();
      getWithdrawRequest();
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<bool> getCreateKYC(BuildContext context, String document_type,
      String subType, File local, path_call) async {
    var map = {"type": document_type, "subType": subType, "image": local};

    showProgress(context, '', true);

    Map<String, dynamic> response =
        await WebServicesHelper().getCreateKYC(map, path_call, token, user_id);
    Navigator.pop(context);
    Navigator.pop(context);
    // Fluttertoast.showToast(msg: "Response $response");
    Utils().customPrint('response=== $response');

    Map<String, Object> clever_map = new Map<String, Object>();
    Map<String, Object> clever_map_f = new Map<String, Object>();

    clever_map["USER_ID"] = user_id;
    clever_map_f["USER_ID"] = user_id;
    clever_map[EventConstant.EVENT_CLEAVERTAB_KYC_Add_Event] = document_type;
    clever_map_f[EventConstant.EVENT_CLEAVERTAB_KYC_Add_Event_F] =
        document_type;
    if (response != null) {
      Utils().customPrint("data===1");
      clever_map[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_failed] = "No";
      clever_map[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_status] = "Yes";
      CleverTapController cleverTapController = Get.put(CleverTapController());
      cleverTapController.logEventCT(
          EventConstant.EVENT_CLEAVERTAB_KYC_status, clever_map); //KYC STATUS
      // firebase
      clever_map_f[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_failed_F] = "No";
      clever_map_f[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_status_F] = "Yes";
      FirebaseEvent().firebaseEvent(
          EventConstant.EVENT_CLEAVERTAB_KYC_status_F, clever_map_f);

      getProfileData();
      return true;
    } else {
      clever_map[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_failed] = "yes";
      clever_map[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_status] = "No";
      CleverTapController cleverTapController = Get.put(CleverTapController());
      cleverTapController.logEventCT(
          EventConstant.EVENT_CLEAVERTAB_KYC_status, clever_map); //KYC STATUS

      // firebase
      clever_map_f[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_failed_F] = "yes";
      clever_map_f[EventConstant.EVENT_CLEAVERTAB_KYC_KYC_status_F] = "No";
      FirebaseEvent().firebaseEvent(
          EventConstant.EVENT_CLEAVERTAB_KYC_status_F, clever_map_f);
      Utils().customPrint("data===2");
      //AppBaseResponseModel appBaseErrorModel = AppBaseResponseModel.fromMap(response);
      getProfileData();
      Fluttertoast.showToast(
          msg: "KYC Failed Please Try Again/Contact Support!");
      return false;
      //Utils.showCustomTosstError(appBaseErrorModel.error);
    }
  }

  Future<void> checkInvoidAadharcard(
    BuildContext context,
  ) async {
    var map = {
      "docType": "aadhaar",
      "userName": user_id,
      "callbackUrl": ApiUrl().INVOID_CALLBACK_URL + user_id,
      "cancelUrl": ApiUrl().INVOID_CALLBACK_CANCEL_URL + user_id
    };

    showProgress(context, '', true);

    final response_final = await WebServicesHelper().checkInvoidAadharcard(map);
    Navigator.pop(context);
    Utils().customPrint(
        'checkInvoid response=== ${response_final.body.toString()}');
    if (response_final != null && response_final.statusCode == 200) {
      Utils().customPrint("data===1");
      hideProgress(context);
      Map<String, dynamic> response =
          json.decode(response_final.body.toString());
      InvoidModel invoidModel = InvoidModel.fromJson(response);
      Get.toNamed(Routes.invoide, arguments: invoidModel.url);
      // Utils.showCustomTosstError("Success");
    } else {
      hideProgress(context);
      Map<String, dynamic> response =
          json.decode(response_final.body.toString());
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(response);
      //Utils.showCustomTosstError(appBaseErrorModel.error);
    }
  }

  getFromGallery(BuildContext context) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      if (type_kyc_document.value == ApiUrl.DOCUMENT_TYPE_DL) {
        if (imageFile == null) {
          path_call = pickedFile.path;
          imageFile = File(pickedFile.path);
          Fluttertoast.showToast(msg: "Please upload Back images");
          return;
        }
        if (imageFileBack == null) {
          back_path_call = pickedFile.path;
          imageFileBack = File(pickedFile.path);
        }
        if (imageFile != null && imageFileBack != null) {
          Future<bool> status = getCreateKYC(context, type_kyc_document.value,
              ApiUrl.DOCUMENT_SUBTYPE_FRONT, File(path_call), path_call);

          if (status == true) {
            Utils().customPrint("front call");
            getCreateKYC(
                context,
                type_kyc_document.value,
                ApiUrl.DOCUMENT_SUBTYPE_BACK,
                File(back_path_call),
                back_path_call);
          } else {}
          /*
          getCreateKYC(
              context,
              type_kyc_document.value,
              ApiUrl.DOCUMENT_SUBTYPE_BACK,
              File(back_path_call),
              back_path_call);*/
        }
      } else {
        path_call = pickedFile.path;
        imageFile = File(pickedFile.path);
        await getCreateKYC(context, type_kyc_document.value,
            ApiUrl.DOCUMENT_SUBTYPE_FRONT, File(path_call), path_call);

        //Fluttertoast.showToast(msg: path_call.toString());
        Utils().customPrint("Image Path===>${path_call.toString()}");
      }
    }
  }

  /// Get from Camera
  getFromCamera(BuildContext context) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (type_kyc_document.value == ApiUrl.DOCUMENT_TYPE_DL) {
      if (imageFile_camera == null) {
        path_call_camera = pickedFile.path;
        imageFile_camera = File(pickedFile.path);
        Fluttertoast.showToast(msg: "Please upload Back images");
        return;
      }
      if (imageFileBack == null) {
        back_path_call = pickedFile.path;
        imageFileBack = File(pickedFile.path);
      }
      if (imageFile_camera != null && imageFileBack != null) {
        Future<bool> status = getCreateKYC(
            context,
            type_kyc_document.value,
            ApiUrl.DOCUMENT_SUBTYPE_FRONT,
            File(path_call_camera),
            path_call_camera);

        if (status == true) {
          Utils().customPrint("front call");
          getCreateKYC(
              context,
              type_kyc_document.value,
              ApiUrl.DOCUMENT_SUBTYPE_BACK,
              File(back_path_call),
              back_path_call);
        } else {}
      }
    } else {
      imageFile_camera = File(pickedFile.path);
      path_call_camera = pickedFile.path;
      getCreateKYC(
          context,
          type_kyc_document.value,
          ApiUrl.DOCUMENT_SUBTYPE_FRONT,
          File(path_call_camera),
          path_call_camera);
      Utils().customPrint("Image Path===>${path_call_camera.toString()}");

      /// imageFile = File(pickedFile.path);
    }
  }

  funShare(String message) async {
    try {
      await Share.share(message);
    } catch (e) {
      return null;
    }
  }

  //first time event
  /*Future<void> getFirstTimeDepositStatus(String amount) async {
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> responsestr =
        await WebServicesHelper().getFirstTimeDepositStatus(token, user_id);

    if (responsestr != null) {
      WalletModelR walletModelR = WalletModelR.fromJson(responsestr);
     Utils().customPrint('responsestr $responsestr');
     Utils().customPrint('responsestr ${walletModelR.data}');
      CleverTapController cleverTapController = Get.put(CleverTapController());
      AppsflyerController appsflyerController = Get.put(AppsflyerController());
      Map<String, Object> map = new Map<String, Object>();
      if (walletModelR.data.length == 0) {
       Utils().customPrint('responsestr Data not available!');
        Map<String, dynamic> map_clevertapv1 = {"Amount": amount};
        cleverTapController.logEventCT(
            EventConstant.EVENT_CLEAVERTAB_First_Time_Deposit,
            map_clevertapv1); //first time deposit
        appsflyerController.logEventAf(
            EventConstant.EVENT_CLEAVERTAB_First_Time_Deposit,
            map_clevertapv1); //first time deposit
        map["FTD"] = 'YES';
      } else {
       Utils().customPrint('responsestr Data available!');
        map["FTD"] = 'NO';
      }
      map["Amount"] = amount;
      map["Revenue"] = amount;
      map["Deposit Method"] = 'Online'; //need to update
      map["Deposit Failure"] = 'NO'; //need to ask
      cleverTapController.logEventCT(
          EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map);
      appsflyerController.logEventAf(
          EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map); //deposit success
      FaceBookEventController().logEventFacebook(
          EventConstant.EVENT_CLEAVERTAB_Deposit_Success, map); //deposit success
    }
  }*/

  //transaction history api
  Future<void> getTransaction() async {
    Utils().customPrint('getWithdrawRequest DATA:: 0');
    if (wallet_id != null && wallet_id != '') {
      Map<String, dynamic> response = await WebServicesHelper().getTransaction(
          token, user_id, wallet_id, currentpage.value, total_limit);
      Utils().customPrint('getWithdrawRequest DATA:: 1');
      if (response != null) {
        //transtsionlist.clear();
        transactionModelR.value = Transaction.fromJson(response);
        /*   Utils().customPrint('getWithdrawRequest DATA:: 2');
        Utils().customPrint(
            'getWithdrawRequest DATA:: 2.5 ${transtsionlist.length}');*/

        for (int index = 0;
            index < transactionModelR.value.data.length;
            index++) {
          if (transactionModelR.value.data[index].operation.type
                  .compareTo("withdrawRequest") ==
              0) {
            Map<String, dynamic> response = await WebServicesHelper()
                .getWithdrawRequestAccordingTran(
                    token, user_id, transactionModelR.value.data[index].id);

            withdrawRequestModelR.value = WithdrawRequestNew.fromJson(response);
            print("call here transactionId ${response.toString()}");

            if (withdrawRequestModelR.value.data.length > 0) {
              if (transactionModelR.value.data[index].id ==
                  withdrawRequestModelR.value.data[0].transactionId) {
                transactionModelR.value.data[index].status =
                    withdrawRequestModelR.value.data[0].status;
              }
            }

            //   int indexwwww = withdrawRequestModelR.value.data.indexWhere((item) => item.containsValue(transactionModelR.value.data[index].id));

            /* int index1111 = withdrawRequestModelR.value.data.indexWhere((item) => item.transactionId==transactionModelR.value.data[index].id);

            print("index1111 $index1111");
            if(index1111>=0)
              {
                transactionModelR.value.data[index].status =
                    withdrawRequestModelR.value.data[index1111].status;
              }*/

//

            /* if (
                withdrawRequestModelR.value.data.contains("${transactionModelR.value.data[index].id}")) {


              transactionModelR.value.data[index].status =
                  withdrawRequestModelR.value.data[indexWiR].status;
            }*/

            /*for (int indexWiR = 0;
                indexWiR < withdrawRequestModelR.value.data.length;
                indexWiR++) {
              if (transactionModelR.value.data[index].id ==
                  withdrawRequestModelR.value.data[indexWiR].transactionId) {
                transactionModelR.value.data[index].status =
                    withdrawRequestModelR.value.data[indexWiR].status;
              }
            }*/
          }
        }

        transtsionlist.addAll(transactionModelR.value.data);

        totalAmountValues.value = transactionModelR.value.pagination.total;
        Utils().customPrint('getWithdrawRequest DATA:: 3');
      } else {
        Utils().customPrint('getWithdrawRequest DATA:: 4');
        // Fluttertoast.showToast(msg: "Some Error");
      }
    }
  }

  //withdrawal pending api
  Future<void> getWithdrawRequest() async {
    withdrawRequestModelR.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getWithdrawRequest(token, user_id);
    getProfileData();
    getWithdrawSummary();
    if (response != null) {
      withdrawRequestModelR.value = WithdrawRequestNew.fromJson(response);
    }
  }

  Future<void> getWithdrawSummary() async {
    if (token != null && token.isNotEmpty) {
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }

    Map<String, dynamic> response =
        await WebServicesHelper().getWithdrawalSummary(token, user_id);
    if (response != null) {
      pennyDropSummaryAmount.value = response["total"]["value"];
      pennyDropSummaryAmount.value = pennyDropSummaryAmount.value;

      if (profileDataRes != null &&
          profileDataRes.value != null &&
          profileDataRes.value.settings != null &&
          profileDataRes.value.settings.withdrawRequest != null &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus != null) {
        /* if (profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.status
                .compareTo("notPerformed") ==
            0) {
        }
*/

        if (profileDataRes.value.isPennyDropnotPerformed()) {
        } else if (profileDataRes.value.isPennyDropFaild() != null &&
            profileDataRes.value.isPennyDropFaild())
        /* else if (profileDataRes
                .value.withdrawMethod[0].pennyDropCheckStatus.status
                .compareTo("failure") ==
            0) */
        {
          if (profileDataRes.value.settings.withdrawRequest.maxLimit >
              pennyDropSummaryAmount.value) {
            pennyDropLockCon.value = true;
            //sliderTrue.value = true;
          } else {
            pennyDropLockCon.value = false;
            //pennyDropLock.value=false;
            //sliderTrue.value = false;
          }
        }
      }

      // withdrawRequestModelR.value = WithdrawRequestNew.fromJson(response);
      // withdrawRequestlist.addAll(withdrawRequestModelR.value.data);
    }
  }

  //withdrawal cancel api
  Future<void> cancelWithdrawRequest(BuildContext context,
      String wallet_request_id, Map<String, dynamic> param) async {
    showProgress(context, '', false);
    Map<String, dynamic> response = await WebServicesHelper()
        .cancelWithdrawRequest(token, user_id, wallet_request_id, param);
    try {
      hideProgress(context);
      if (response != null) {
        Utils().customPrint('cancelWithdrawRequest DATA:: ${response}');
        if (response != null) {
          Fluttertoast.showToast(msg: 'Withdrawal cancelled successfully!');

          await getWithdrawRequest();
        }
      }
    } catch (e) {
      hideProgress(context);
      //Fluttertoast.showToast(msg: 'Something went wrong!');
    }
  }

  //offerwall create api
  Future<void> getAdvertisersDeals() async {
    Utils().customPrint('response getAdvertisersDeals code CALLING...');
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    isLoadingAdvertisersDeals.value = false;
    Map<String, dynamic> response = await WebServicesHelper()
        .getAdvertisersDeals(
            token, "", "", "", "active", "order:ASC,createdAt:DESC", user_id);
    Utils().customPrint('response getAdvertisersDeals code IN WAY...');
    isLoadingAdvertisersDeals.value = true;
    if (response != null) {
      offerWallList.value = OfferWallModel.fromJson(response);
      //for game contest lootbox modules
      Utils().customPrint(
          'response getAdvertisersDeals code length ${offerWallList.value.data.length}');
    } else {
      Utils().customPrint('response getAdvertisersDeals ERROR');
    }
  }

  //offerwall create api
  Future<void> getAdvertisersDealsPopUp(BuildContext context) async {
    Utils().customPrint('response getAdvertisersDeals code CALLING...');
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    showProgress(context, '', true);
    Map<String, dynamic> response = await WebServicesHelper()
        .getAdvertisersDeals(
            token, "", "", "", "active", "order:ASC,createdAt:DESC", user_id);
    Utils().customPrint('response getAdvertisersDeals code IN WAY...');
    hideProgress(context);
    if (response != null) {
      //offerWallList.value = OfferWallModel.fromJson(response);
      //for game contest lootbox modules
      offerWallList.value = OfferWallModel.fromJson(response);
      Utils().customPrint(
          'response getAdvertisersDeals code length ${offerWallList.value.data.length}');
    } else {
      Utils().customPrint('response getAdvertisersDeals ERROR');
    }
  }

  //withdrawal cancel api
  Future<void> createUserDeal(
      BuildContext context, Map<String, dynamic> param) async {
    showProgress(context, '', true);

    Map<String, dynamic> response =
        await WebServicesHelper().createUserDeal(token, user_id, param);

    try {
      if (response != null) {
        if (response["errorCode"] != null &&
            response["errorCode"] == "ERR2302") {
          hideProgress(context);
          Utils().creatDealPopupError(navigatorKey.currentState.context,
              "Offer Already used on this Device.");
          return;
        }
        Utils().customPrint('createUserDeal DATA:: ${response}');
        if (response != null) {
          hideProgress(context);
          Fluttertoast.showToast(msg: 'Offer created successfully!');

          if (response['url'] != null && response['url'] != '') {
            String url = response['url'].toString();
            if (url.contains("{clickid}")) {
              url = url.replaceAll("{clickid}", response['userDealId']);
            }
            Utils().customPrint('createUserDeal DATA:: ${url}');
            Utils.launchURLApp(url);
            //Utils().showCustomDialogWebViewInvible(context, url);
            //api calling
            await getAdvertisersDeals();
            getUserDeals();
          } else {
            Fluttertoast.showToast(msg: 'URL not found!');
          }
        }
      } else {
        //Fluttertoast.showToast(msg: 'Request already placed!');
        Utils().customPrint('Request already placed!');
        hideProgress(context);
      }
    } catch (e) {
      hideProgress(context);
      Fluttertoast.showToast(msg: 'Something went wrong!');
    }
  }

  //offerwall user deals api
  Future<void> getUserDeals() async {
    if (user_id == null && user_id != '' && token == null && token != '') {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    try {
      Map<String, dynamic> response =
          await WebServicesHelper().getUserDeals(token, user_id);

      if (response != null) {
        Utils().customPrint('response getUserDeals code STARTING...');
        offerWallHistoryList.value = GetUserDealsModel.fromJson(response);

        Utils().customPrint(
            'response getUserDeals code ${offerWallHistoryList.value.data.length}');
      } else {
        Utils().customPrint('response getUserDeals ERROR');
      }
    } catch (e) {}
  }

  subtractDate(DateTime expireDate) {
    var apiDate = expireDate.toUtc();
    var utcCurrentDate = DateTime.now().toUtc();
    //Utils().customPrint("current system date $utcCurrentDate");

    var difference = apiDate.difference(utcCurrentDate.toUtc()).inSeconds;
    var differencem = difference * 60;
    Utils().customPrint("current system date utcCurrentDate $utcCurrentDate");
    Utils().customPrint("current system date expireDate $expireDate");
    Utils().customPrint("current system date difference $differencem");
    return difference;
  }

  Future<void> getBannerForOfferWall() async {
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getUserBanner(token, "offerWall");
      if (response_str != null) {
        bannerModelOfferWallRV.value = BannerModelR.fromJson(response_str);
      }
      //Utils().customPrint("bannerModelOfferWallRV:: ${bannerModelOfferWallRV.value.data.length}");
    }
  }

  void alertOldWallet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 180,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 30),
                      child: Text(
                        'Please Enter Amount And Click on This Banner Again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(() => DashBord(4, ""));
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width - 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor().green_color_light,
                              AppColor().green_color,
                            ],
                          ),

                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF067906),
                              //inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              //inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }

  Widget normalListView(int index, String eventID) {
    return Container(
      height: offerWallList.value.data[index].banner != null ? 270 : 75,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      width: MediaQuery.of(navigatorKey.currentState.context).size.width,
      decoration: BoxDecoration(
          color: AppColor().border_outside,
          // image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/gradient_rectangular.png")),

          borderRadius: BorderRadius.circular(10)),
      child: offerWallList.value.data[index].banner != null
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: offerWallList.value.data[index].logoUrl !=
                                    null &&
                                offerWallList.value.data[index].logoUrl != ''
                            ? Image(
                                //color: AppColor().whiteColor,
                                width: 50,
                                height: 50,
                                //fit: BoxFit.cover,
                                image: NetworkImage(
                                    offerWallList.value.data[index].logoUrl))
                            : Image(
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/hotstar.png'),
                              ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showBottomSheetInfo(
                                navigatorKey.currentState.context,
                                offerWallList.value.data[index].terms);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0, top: 0),
                                child: Text(
                                  "${offerWallList.value.data[index].name}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: AppColor().colorPrimary),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10, left: 5),
                                child: Image.asset(
                                  "assets/images/blue_circle_info.png",
                                  width: 13,
                                  height: 13,
                                  //color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 5),
                          child: Text(
                            '${offerWallList.value.data[index].description}',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                offerWallList.value.data[index].banner != null &&
                        offerWallList.value.data[index].banner.url != null
                    ? Image(
                        //color: AppColor().whiteColor,
                        //width: 50,
                        height: 140,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                            offerWallList.value.data[index].banner.url))
                    : Image(
                        //height: 120,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                            'assets/images/offer_wall_middle_banner.png'),
                      ),
                GestureDetector(
                  onTap: () async {
                    if (offerWallList.value.data[index].userDeal != null &&
                        subtractDate((DateTime.parse(
                                "${offerWallList.value.data[index].userDeal.expireDate}"))) >
                            0) {
                      if (offerWallList.value.data[index].url != null &&
                          offerWallList.value.data[index].url != '') {
                        String url =
                            offerWallList.value.data[index].url.toString();
                        if (url.contains("{clickid}")) {
                          url = url.replaceAll("{clickid}",
                              offerWallList.value.data[index].userDeal.id);
                        }
                        Utils().customPrint('createUserDeal DATA:: ${url}');
                        //Utils.launchURLApp(url);
                        //showProgress(navigatorKey.currentState.context, '', true);
                        Utils.launchURLApp(url);
                        //Utils().showCustomDialogWebViewInvible(navigatorKey.currentState.context, url);
                        return;
                        //api calling
                        //await getAdvertisersDeals();
                        //await getUserDeals();
                      } else {
                        Fluttertoast.showToast(msg: 'URL not found!');
                      }
                    }
                    //Event Saving
                    Map<String, Object> map = new Map<String, Object>();
                    map["offer_name"] = offerWallList.value.data[index].name;
                    map["offer_clicked"] = "Yes";
                    map["USER_ID"] = user_id;
                    map["deviceId"] = await Utils().getUniqueDeviceId();
                    try {
                      if (offerWallList.value.data[index].gmngEarning != null &&
                          offerWallList.value.data[index].gmngEarning.value !=
                              null &&
                          offerWallList.value.data[index].gmngEarning.value !=
                              '') {
                        int amt =
                            offerWallList.value.data[index].gmngEarning.value;
                        map["offer_gmngEarning"] = amt / 100;
                      }
                      if (offerWallList.value.data[index].userEarning != null &&
                          offerWallList.value.data[index].userEarning.value !=
                              null &&
                          offerWallList.value.data[index].userEarning.value !=
                              '') {
                        int amt =
                            offerWallList.value.data[index].userEarning.value;
                        map["offer_userEarning"] = amt / 100;
                      }
                    } catch (e) {}
                    //appsflyer
                    AppsflyerController c = Get.put(AppsflyerController());
                    c.logEventAf(EventConstant.EVENT_Offerwall, map);
                    //clevertap
                    CleverTapController cleverTapController =
                        Get.put(CleverTapController());
                    cleverTapController.logEventCT(
                        EventConstant.EVENT_Offerwall, map);

                    FirebaseEvent()
                        .firebaseEvent(EventConstant.EVENT_Offerwall_F, map);
                    //end
                    //app checking insalled or not
                    String appInstalled = "false";
                    if (offerWallList.value.data[index].appPackage != null &&
                        offerWallList.value.data[index].appPackage.android !=
                            null) {
                      Utils().customPrint(
                          "open App: ${await findAppByPkgName("${offerWallList.value.data[index].appPackage.android}")}");
                      appInstalled = await findAppByPkgName(
                          "${offerWallList.value.data[index].appPackage.android}");
                    }
                    /* //return;
                    final param = {
                      "advertiserDealId":
                          "${offerWallList.value.data[index].id}",
                      "appInstalled": appInstalled,
                      "deviceId": await Utils().getUniqueDeviceId()
                    };*/

                    var param;
                    eventID != ""
                        ? param = {
                            "advertiserDealId":
                                "${offerWallList.value.data[index].id}",
                            "appInstalled": appInstalled,
                            "deviceId": await Utils().getUniqueDeviceId(),
                            "eventId": eventID
                          }
                        : param = {
                            "advertiserDealId":
                                "${offerWallList.value.data[index].id}",
                            "appInstalled": appInstalled,
                            "deviceId": await Utils().getUniqueDeviceId()
                          };
                    //return;
                    await createUserDeal(
                        navigatorKey.currentState.context, param);
                    await getWalletAmount();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5.0),
                    child: Container(
                        height: 40,
                        // width: 64,
                        width: MediaQuery.of(navigatorKey.currentState.context)
                                .size
                                .width -
                            208,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            //  stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              offerWallList.value.data[index].userDeal !=
                                          null &&
                                      subtractDate((DateTime.parse(
                                              "${offerWallList.value.data[index].userDeal.expireDate}"))) <
                                          0
                                  ? AppColor().clan_header_light
                                  : AppColor().button_bg_redlight,
                              offerWallList.value.data[index].userDeal !=
                                          null &&
                                      subtractDate((DateTime.parse(
                                              "${offerWallList.value.data[index].userDeal.expireDate}"))) <
                                          0
                                  ? AppColor().clan_header_dark
                                  : AppColor().button_bg_reddark,
                              //AppColor().green_color_light,
                              //AppColor().green_color,
                            ],
                          ),
                          border: Border.all(
                              color: AppColor().whiteColor, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              offset: const Offset(
                                0.0,
                                3.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: Color(0xFF333232),
                              inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFffffff),
                              inset: true,
                            ),
                          ],
                          // color: AppColor().whiteColor
                        ),
                        child: Obx(
                          () => Center(
                            child: offerWallList.value.data[index].userDeal !=
                                    null
                                ? subtractDate((DateTime.parse(
                                            "${offerWallList.value.data[index].userDeal.expireDate}"))) >
                                        0
                                    ? TweenAnimationBuilder<Duration>(
                                        duration: Duration(
                                            seconds: subtractDate(DateTime.parse(
                                                "${offerWallList.value.data[index].userDeal.expireDate}"))),
                                        tween: Tween(
                                            begin: Duration(
                                                seconds: subtractDate(
                                                    DateTime.parse(
                                                        "${offerWallList.value.data[index].userDeal.expireDate}"))),
                                            end: Duration.zero),
                                        onEnd: () {
                                          Utils().customPrint('Timer ended');
                                          //isExpired.value = true;
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
                                          return Text(
                                            "Pending",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          );
                                        })
                                    : Text(
                                        "Expired",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: Colors.white),
                                      )
                                : Text(
                                    "${offerWallList.value.data[index].buttonText}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                          ),
                        )),
                  ),
                ),
                //webViewPysudo(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: offerWallList.value.data[index].logoUrl != null &&
                            offerWallList.value.data[index].logoUrl != ''
                        ? Image(
                            //color: AppColor().whiteColor,
                            width: 50,
                            height: 50,
                            //fit: BoxFit.cover,
                            image: NetworkImage(
                                offerWallList.value.data[index].logoUrl))
                        : Image(
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/netflix.png'),
                          ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showBottomSheetInfo(navigatorKey.currentState.context,
                              offerWallList.value.data[index].terms);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 15),
                              child: Text(
                                "${offerWallList.value.data[index].name}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: AppColor().colorPrimary),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 5),
                              child: Image.asset(
                                "assets/images/blue_circle_info.png",
                                width: 13,
                                height: 13,
                                //color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 5),
                        child: Text(
                          '${offerWallList.value.data[index].description}',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      if (offerWallList.value.data[index].userDeal != null &&
                          subtractDate((DateTime.parse(
                                  "${offerWallList.value.data[index].userDeal.expireDate}"))) >
                              0) {
                        if (offerWallList.value.data[index].url != null &&
                            offerWallList.value.data[index].url != '') {
                          String url =
                              offerWallList.value.data[index].url.toString();
                          if (url.contains("{clickid}")) {
                            url = url.replaceAll("{clickid}",
                                offerWallList.value.data[index].userDeal.id);
                          }
                          Utils().customPrint('createUserDeal DATA:: ${url}');
                          //showProgress(navigatorKey.currentState.context, '', true);
                          //Utils().showCustomDialogWebViewInvible(navigatorKey.currentState.context, url);
                          Utils.launchURLApp(url);
                          return;
                          //Utils.launchURLApp(url);
                          //Get.to(() => PokerHowToPlayWebview(url));
                          //Utils.launchURLApp('market://details?id=com.byjus.thelearningapp&referrer=af_tranid%3D5i2682Uzq617AoAU9pmImA%26af_sub1%3D1437%26af_c_id%3D8364262%26pid%3Dxyads_int%26af_click_lookback%3D7d%26af_prt%3Dxyadsagency%26expires%3D1682233927396%26signature%3DTuT4v-YmAFImt-eE9Fqx4VZy2AJMYc0NX432lrjkEdE%26af_sub2%3D%7Bsubid%7D%26af_web_id%3D2a4c51ee-ed67-469e-a6c0-5116263487e8-c%26clickid%3D026090E8FFEA21674457927394752%26af_siteid%3D15901%26af_sub_siteid%3D%7Bsubid%7D%26af_sub3%3D123472%26c%3DAffiliate_xyadsagency');
                          //api calling
                          //await getAdvertisersDeals();
                          //await getUserDeals();
                        } else {
                          Fluttertoast.showToast(msg: 'URL not found!');
                        }
                      }

                      //Event Calling
                      Map<String, Object> map = new Map<String, Object>();
                      map["offer_name"] = offerWallList.value.data[index].name;
                      map["offer_clicked"] = "Yes";
                      map["USER_ID"] = user_id;
                      map["deviceId"] = await Utils().getUniqueDeviceId();
                      try {
                        if (offerWallList.value.data[index].gmngEarning !=
                                null &&
                            offerWallList.value.data[index].gmngEarning.value !=
                                null &&
                            offerWallList.value.data[index].gmngEarning.value !=
                                '') {
                          int amt =
                              offerWallList.value.data[index].gmngEarning.value;
                          map["offer_gmngEarning"] = amt / 100;
                        }
                        if (offerWallList.value.data[index].userEarning !=
                                null &&
                            offerWallList.value.data[index].userEarning.value !=
                                null &&
                            offerWallList.value.data[index].userEarning.value !=
                                '') {
                          int amt =
                              offerWallList.value.data[index].userEarning.value;
                          map["offer_userEarning"] = amt / 100;
                        }
                      } catch (e) {}
                      //appsflyer
                      AppsflyerController c = Get.put(AppsflyerController());
                      c.logEventAf(EventConstant.EVENT_Offerwall, map);
                      //clevertap
                      CleverTapController cleverTapController =
                          Get.put(CleverTapController());
                      cleverTapController.logEventCT(
                          EventConstant.EVENT_Offerwall, map);

                      FirebaseEvent()
                          .firebaseEvent(EventConstant.EVENT_Offerwall_F, map);
                      //end

                      //app checking insalled or not
                      String appInstalled = "false";
                      if (offerWallList.value.data[index].appPackage != null &&
                          offerWallList.value.data[index].appPackage.android !=
                              null) {
                        Utils().customPrint(
                            "open App: ${await findAppByPkgName("${offerWallList.value.data[index].appPackage.android}")}");
                        appInstalled = await findAppByPkgName(
                            "${offerWallList.value.data[index].appPackage.android}");
                      }
                      var param;
                      eventID != ""
                          ? param = {
                              "advertiserDealId":
                                  "${offerWallList.value.data[index].id}",
                              "appInstalled": appInstalled,
                              "deviceId": await Utils().getUniqueDeviceId(),
                              "eventId": eventID
                            }
                          : param = {
                              "advertiserDealId":
                                  "${offerWallList.value.data[index].id}",
                              "appInstalled": appInstalled,
                              "deviceId": await Utils().getUniqueDeviceId()
                            };
                      //return;

                      await createUserDeal(
                          navigatorKey.currentState.context, param);
                      await getWalletAmount();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5.0),
                      child: Container(
                          height: 35,
                          // width: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              //  stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                // Colors are easy thanks to Flutter's Colors class.
                                offerWallList.value.data[index].userDeal !=
                                            null &&
                                        subtractDate((DateTime.parse(
                                                "${offerWallList.value.data[index].userDeal.expireDate}"))) <
                                            0
                                    ? AppColor().clan_header_light
                                    : AppColor().green_color_light,
                                offerWallList.value.data[index].userDeal !=
                                            null &&
                                        subtractDate((DateTime.parse(
                                                "${offerWallList.value.data[index].userDeal.expireDate}"))) <
                                            0
                                    ? AppColor().clan_header_dark
                                    : AppColor().green_color,
                                //AppColor().green_color_light,
                                //AppColor().green_color,
                              ],
                            ),
                            border: Border.all(
                                color: AppColor().whiteColor, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                offset: const Offset(
                                  0.0,
                                  3.0,
                                ),
                                blurRadius: 1.0,
                                spreadRadius: .3,
                                color: Color(0xFF4F4F4F),
                                inset: true,
                              ),
                              BoxShadow(
                                offset: Offset(00, 00),
                                blurRadius: 00,
                                color: Color(0xFFffffff),
                                inset: true,
                              ),
                            ],
                            // color: AppColor().whiteColor
                          ),
                          child: Obx(
                            () => Center(
                              child: offerWallList.value.data[index].userDeal !=
                                      null
                                  ? subtractDate((DateTime.parse(
                                              "${offerWallList.value.data[index].userDeal.expireDate}"))) >
                                          0
                                      ? TweenAnimationBuilder<Duration>(
                                          duration: Duration(
                                              seconds: subtractDate(DateTime.parse(
                                                  "${offerWallList.value.data[index].userDeal.expireDate}"))),
                                          tween: Tween(
                                              begin: Duration(
                                                  seconds: subtractDate(
                                                      DateTime.parse(
                                                          "${offerWallList.value.data[index].userDeal.expireDate}"))),
                                              end: Duration.zero),
                                          onEnd: () {
                                            Utils().customPrint('Timer ended');
                                            //isExpired.value = true;
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
                                            return Text(
                                              "In Progress",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            );
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                child: Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                            "${offerWallList.value.data[index].buttonText}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 11)),
                                                        Text(
                                                            //"(Time remaining: $hours\:$minutes\:$seconds)",
                                                            "(Pending)",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 9)),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          })
                                      : Text(
                                          "Expired",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              color: Colors.white),
                                        )
                                  : ApiUrl().isPlayStore
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${offerWallList.value.data[index].buttonText.split("₹")[0]}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Container(
                                              height: 10,
                                              child: Image.asset(
                                                  "assets/images/winning_coin.webp"),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${offerWallList.value.data[index].buttonText.split("₹")[1]}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      : Text(
                                          "${offerWallList.value.data[index].buttonText}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void showBottomSheetInfo(BuildContext context, String terms) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 10,
                    right: 10),
                decoration: BoxDecoration(
                    color: AppColor().reward_card_bg,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            "Terms & Conditions",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 5),
                      height: .5,
                      color: AppColor().colorGray,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /* Text(
                          "Complete following tasks",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12),
                        ),*/
                        /* Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "${terms}",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),*/
                        Html(
                          data: terms,
                          /* onLinkTap: (url, _, __, ___) {
                           Utils().customPrint("Opening $url");
                          makeLaunch(url!);
                        },*/
                          style: {
                            "body": Style(
                              fontSize: FontSize(10.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            'h1': Style(
                              color: Colors.white,
                              textAlign: TextAlign.left,
                            ),
                            'p': Style(
                                textAlign: TextAlign.left,
                                color: Colors.white,
                                alignment: Alignment.topLeft,
                                fontSize: FontSize.small),
                            'ul': Style(
                              color: Colors.white,
                              textAlign: TextAlign
                                  .left, /*margin:  EdgeInsets.only(left: 10)*/
                            )
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                        width: MediaQuery.of(context).size.width - 200,
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
                              color: Color(0xFFED234B),
                              inset: true,
                            ),
                            BoxShadow(
                              offset: Offset(00, 00),
                              blurRadius: 00,
                              color: Color(0xFFEC8479),
                              inset: true,
                            ),
                          ],

                          border: Border.all(
                              color: AppColor().whiteColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor().whiteColor
                        ),
                        child: Text(
                          "Close",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  findAppByPkgName(String pkgName) async {
    try {
      bool isInstalled = await DeviceApps.isAppInstalled(pkgName);
      if (isInstalled) {
        Utils().customPrint('open App...IF');
        return "true";
      } else {
        Utils().customPrint('open App...ELSE');
        return "false";
      }
    } catch (e) {
      Utils().customPrint('open App...E');
      return "false";
    }
  }

  void alertLookBox(String freegame) {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Stack(
            children: [
              Obx(
                () => Image(
                    height: viewMore.isTrue ? 600 : 410,
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg)),
              ),
              Obx(
                () => Container(
                  width: MediaQuery.of(navigatorKey.currentState.context)
                      .size
                      .width,
                  decoration: viewMore.isTrue
                      ? BoxDecoration(
                          color: AppColor().border_inside,
                          border: Border.all(
                            width: 4,
                            color: AppColor().border_outside,
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(
                                0.0,
                                5.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: .3,
                              color: AppColor().border_outside_Dark,
                              inset: true,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)))
                      : BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().large_bg))),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: viewMore.isTrue ? 600 : 410,
                  child: Card(
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    elevation: 0,
                    //  color: AppColor().wallet_dark_grey,
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 120,
                            margin:
                                EdgeInsets.only(top: 10, right: 10, left: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: freegame.compareTo("freegame") == 0
                                  ? Image(
                                      height: 80,
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/mini_lootbox_banner_freegame.png"),
                                    )
                                  : Image(
                                      height: 80,
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/Instant_lootbox_out_of_money_minilootbox.png"),
                                    ),
                            ),
                          ),

                          /*     Obx(() => bannerModelOfferWallRV.value != null &&
                                  bannerModelOfferWallRV.value.data != null
                              ? bannerModelOfferWallRV.value.data.length > 0
                                  ? bannerModelOfferWallRV.value.data.length > 1
                                      ? CarouselSlider(
                                          items: bannerModelOfferWallRV
                                              .value.data
                                              .map(
                                                (item) => GestureDetector(
                                                  onTap: () {
                                                    //launchURLApp(item.externalUrl);
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 6),
                                                    child: Center(
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            height: 120,
                                                            width: MediaQuery.of(
                                                                    navigatorKey
                                                                        .currentState
                                                                        .context)
                                                                .size
                                                                .width,
                                                            fit: BoxFit.cover,
                                                            imageUrl: (item
                                                                .image.url),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          options: CarouselOptions(
                                            height: 120.0,
                                            autoPlay: true,
                                            disableCenter: true,
                                            viewportFraction: .9,
                                            aspectRatio: 3,
                                            enlargeCenterPage: false,
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enableInfiniteScroll: true,
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 1000),
                                            onPageChanged: (index, reason) {
                                              // controller.currentIndexSlider.value = index;
                                            },
                                          ),
                                        )
                                      : Container(
                                          height: 120,
                                          margin: EdgeInsets.only(
                                              top: 10, right: 10, left: 10),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Obx(
                                                () => Image(
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  image: bannerModelOfferWallRV
                                                                  .value.data !=
                                                              null &&
                                                          bannerModelOfferWallRV
                                                                  .value.data !=
                                                              null &&
                                                          bannerModelOfferWallRV
                                                                  .value
                                                                  .data
                                                                  .length >=
                                                              1
                                                      ? NetworkImage(
                                                          bannerModelOfferWallRV
                                                              .value
                                                              .data[0]
                                                              .image
                                                              .url)
                                                      : AssetImage(
                                                          "assets/images/offer_wall_banner.png"),
                                                ),
                                              )),
                                        )
                                  : Container(
                                      height: 0,
                                    )
                              : Shimmer.fromColors(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: MediaQuery.of(navigatorKey
                                                .currentState.context)
                                            .size
                                            .width *
                                        0.3,
                                    width: MediaQuery.of(
                                            navigatorKey.currentState.context)
                                        .size
                                        .width,
                                  ),
                                  baseColor: Colors.grey.withOpacity(0.2),
                                  highlightColor: Colors.grey.withOpacity(0.4),
                                  enabled: true,
                                )),*/
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 2, bottom: 7, top: 20),
                            child: Obx(() => offerWallList.value.data != null &&
                                    offerWallList.value.data.length > 0
                                ? ListView.builder(
                                    padding: EdgeInsets.only(top: 0),
                                    itemCount: viewMore.isTrue
                                        ? offerWallList.value.data.length
                                        : offerWallList.value.data.length >= 2
                                            ? 2
                                            : offerWallList.value.data.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, int index) {
                                      return normalListView(index, "");
                                    })
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      height: 250,
                                      width: 350,
                                      child: Image.asset(
                                          'assets/images/empty_lootbox.png'),
                                      //fit: BoxFit.cover,
                                    ),
                                  )),
                          ),
                          Obx(
                            () => viewMore == false
                                ? GestureDetector(
                                    onTap: () {
                                      viewMore.value = true;
                                    },
                                    child: Text(
                                      'View More',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  )
                                : SizedBox(
                                    height: 10,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      viewMore.value = false;
                      Navigator.pop(navigatorKey.currentState.context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20, right: 30),
                      height: 18,
                      width: 18,
                      child: Image.asset(ImageRes().close_icon),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getBanner() async {
    if (token != null && token != '') {
      Map<String, dynamic> response_str =
          await WebServicesHelper().getUserBanner(token, bannerType);
      if (response_str != null) {
        bannerModelRV.value =
            BannerModelR.fromJsonRedeemLockPopup(response_str);
        Utils()
            .customPrint("bannerModelRV:: ${bannerModelRV.value.data.length}");
      }
    } else {
      Utils().customPrint("banner reword null token");
    }
  }

  //VIP Module redeep API
  Future<void> claimInstantCash(
      BuildContext context, Map<String, dynamic> param) async {
    showProgress(context, '', true);
    Map<String, dynamic> response =
        await WebServicesHelper().claimInstantCash(token, user_id, param);
    hideProgress(context);

    if (response != null) {
      controller.callAllProfileData();
    }
  }

  //promo codes api call
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
        token, user_id, Utils().getTodayDatesWithFormat(), "");

    if (response != null) {
      walletModelPromo = WalletModelR.fromJsonPromo(response);
      walletModelPromoFull = WalletModelR.fromJsonPromoFull(response);
      //walletModelPromoBanner = WalletModelR.fromJsonPromoBanner(response);
      print('response promo code size ${walletModelPromo.data.length}');
      print(
          'response promo code full size ${walletModelPromoFull.data.length}');
      //print('response promo code banner size ${walletModelPromoBanner.data.length}');

      if (walletModelPromo.data.length > 0) {
        walletModelPromo.data.sort((a, b) {
          //sorting in descending order
          return int.parse(a.fromValue).compareTo(int.parse(b.fromValue));
        });
      }
      /*for (int i = 0; i < walletModelPromo.data.length; i++) {
        print('response promo code ftd ${walletModelPromo.data[i].ftd}');
      }*/
      //sorting
      if (walletModelPromoFull.data.length > 0) {
        walletModelPromoFull.data.sort((a, b) {
          //sorting in descending order
          return int.parse(a.fromValue).compareTo(int.parse(b.fromValue));
        });
      }
      for (int i = 0; i < walletModelPromoFull.data.length; i++) {
        print(
            'response promo code full size ${walletModelPromoFull.data[i].fromValue}'); //DEPOSIT100
      }
    } else {
      Utils().customPrint('response promo code ERROR');
    }
  }

  String needDepositAmtForNextVipLevel() {
    var userInstantAmount =
        controller.profileDataRes.value.stats.instantCash.value / 100;
    Utils().customPrint('vip testing: userInstantAmount ${userInstantAmount}');
    Utils().customPrint(
        'vip testing: descriptionAccordingVIPLevel ${controller.descriptionAccordingVIPLevel.value}');
    Utils().customPrint(
        'vip testing: instantCashLimitNextLevel ${controller.instantCashLimitNextLevel.value}');
    var instantCashLimit = 0.0;
    if (controller.profileDataRes.value.level.value == 1) {
      instantCashLimit =
          (controller.instantCashLimitNextLevel.value / 100); // +
      // controller.instantCashLimitPrevLevel.value / 100;
      //Utils().customPrint('vip testing: instantCashLimit U1 ${controller.instantCashLimitNextLevel.value}');
      //Utils().customPrint('vip testing: instantCashLimit U2 ${controller.instantCashLimitPrevLevel.value}');
      Utils()
          .customPrint('vip testing: instantCashLimit U ${instantCashLimit}');
    } else if (controller.profileDataRes.value.level.value == 0) {
      instantCashLimit = controller.instantCashLimitNextLevel.value / 100;
      Utils()
          .customPrint('vip testing: instantCashLimit L ${instantCashLimit}');
    }
    var needInstantCash = instantCashLimit - userInstantAmount;
    Utils().customPrint('vip testing: needInstantCash ${needInstantCash}');
    Utils().customPrint(
        'vip testing: cashback_depositPercent ${controller.cashback_depositPercent.value}');
    var needToDepositAmt =
        needInstantCash * (100 / controller.cashback_depositPercent.value);
    Utils().customPrint(
        'vip testing: needToDepositAmt ${needToDepositAmt.ceil()}');
    return needToDepositAmt.ceil().toStringAsFixed(0);
  }

  //testing
  //GlobalKey gk_instant_cash = GlobalKey();
  //GlobalKey gk_bonus_cash = GlobalKey();
  //GlobalKey<CartIconKey> gkCart = GlobalKey<CartIconKey>();
  // GlobalKey<CartIconKey> gkCartSec = GlobalKey<CartIconKey>();
  //Function(GlobalKey) runAddToCardAnimation;

  /*void listClick(GlobalKey gkImageContainer) async {
    await runAddToCardAnimation(gkImageContainer);
    //await gkCart.currentState.runCartAnimation((++_cartQuantityItems).toString());
  }*/

  //not used
  void showBottomSheetVipCircularProgress() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: navigatorKey.currentState.context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(navigatorKey.currentState.context)
                        .viewInsets
                        .bottom,
                    left: 10,
                    right: 10),
                decoration: BoxDecoration(
                    color: AppColor().border_inside,
                    border: Border.all(
                      width: 5,
                      color: AppColor().border_outside,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(
                          0.0,
                          5.0,
                        ),
                        blurRadius: 1.0,
                        spreadRadius: .3,
                        color: AppColor().border_outside_Dark,
                        inset: true,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0),
                          child: Text(
                            "Benefits of your VIP level",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(
                                    navigatorKey.currentState.context);
                              }),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0),
                          child: Text(
                            "Current Points",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0),
                          child: Text(
                            "Required Points",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 10),
                          child: Text(
                            "${(controller.profileDataRes.value.stats.instantCash.value / 100).toStringAsFixed(0)}   ",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: AppColor().colorPrimary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 0),
                          child: Text(
                            "${(controller.instantCashLimitNextLevel.value / 100).toStringAsFixed(0)}",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: AppColor().colorPrimary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () => controller.descriptionAccordingNextVIPLevel.value !=
                              null
                          ? Html(
                              data: controller
                                  .descriptionAccordingNextVIPLevel.value,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  fontWeight: FontWeight.normal,
                                  textAlign: TextAlign.left,
                                  color: Colors.white,
                                ),
                                'h1': Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  color: Colors.white,
                                  textAlign: TextAlign.left,
                                ),
                                'p': Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  textAlign: TextAlign.left,
                                  color: Colors.white,
                                  //   alignment: Alignment.centerLeft,
                                  fontFamily: "Montserrat",
                                ),
                                'ul': Style(
                                  fontSize: FontSize(12 *
                                      MediaQuery.of(
                                              navigatorKey.currentState.context)
                                          .textScaleFactor),
                                  color: Colors.white,
                                  textAlign: TextAlign
                                      .left, /*margin:  EdgeInsets.only(left: 10)*/
                                )
                              },
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  //confetii popup-up
  void showCustomDialogConfetti(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Container(
          child: Center(
            child: Container(
              height: 220,
              width: 320,
              //color: Colors.white,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.all(5),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("     "),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                              icon: new Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Lottie.asset(
                                'assets/lottie_files/tick.json',
                                repeat: false,
                                height: 100,
                                width: 100,
                              ),
                              Lottie.asset(
                                'assets/lottie_files/bust.json',
                                repeat: false,
                                height: 200,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 70.0),
                            child: Text(
                              "Deposited \u{20B9}${selectAmount.value} Successfully",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: AppColor().reward_grey_bg),
                            ),
                          ),
                          promocode.value != null &&
                                  promocode.value != '' &&
                                  walletTypePromocode != null &&
                                  walletTypePromocode == 'bonus'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 140.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Extra Instant",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().colorPrimary),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Image.asset(
                                            "assets/images/instant_coin.png",
                                            width: 20,
                                            height: 20),
                                      ),
                                      Text(
                                        "& Bonus",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().colorPrimary),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Image.asset(
                                            "assets/images/bonus_coin.png",
                                            width: 20,
                                            height: 20),
                                      ),
                                      Text(
                                        "added!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().colorPrimary),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 140.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Extra Instant",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().colorPrimary),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Image.asset(
                                            "assets/images/instant_coin.png",
                                            width: 20,
                                            height: 20),
                                      ),
                                      Text(
                                        "added!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Montserrat",
                                            color: AppColor().colorPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showCustomDialogConfettiNew() {
    showGeneralDialog(
      context: navigatorKey.currentState.context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.0),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(navigatorKey.currentState.context);
          },
          child: Stack(children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900].withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            Container(
                height: double.infinity,
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/images/confetti_2.png'),
                  fit: BoxFit.fitHeight,
                )),
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 210,
                      width: 250,
                      //color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20)),
                      child: Card(
                        color: Colors.black.withOpacity(0.0),
                        //color: Colors.blue,
                        elevation: 0,
                        //margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Stack(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            alignment: Alignment.center,
                            children: [
                              OverflowBox(
                                maxHeight: 250,
                                maxWidth: 250,
                                child: Lottie.asset(
                                  'assets/lottie_files/tick_addmoney.json',
                                  repeat: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 135.0),
                                child: Text(
                                  //"Deposited \u{20B9}${selectAmount.value} Successfully",
                                  "Money Deposited Successfully".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: AppColor().whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 10,
                      //   key: gkCartSec,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  //promo codes api call
  Future<void> getPromoCodesBannerData() async {
    //blocking promocodes
    if (AppString.promoCodes.value == "inactive") {
      return;
    }
    Utils().customPrint(
        "test getPromoCodesBannerData ${AppString.userVipLevelString.value}");
    if (user_id == null) {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    Map<String, dynamic> response = await WebServicesHelper()
        .getPromoCodesBannerData(
            token,
            user_id,
            Utils().getTodayDatesWithFormat(),
            AppString.userVipLevelString
                .value /*'6421654c877a4fe09abe1681,641bfebdbae1aad5bd381fcb,641bfb5f071fb03eaa25556f'*/);

    if (response != null &&
        controller.profileDataRes != null &&
        controller.profileDataRes.value != null &&
        controller.profileDataRes.value.level != null &&
        controller.profileDataRes.value.level.id != null) {
      walletModelPromoBanner.value = WalletModelR.fromJsonPromoBanner(response);

      for (int i = 0; i < walletModelPromoBanner.value.data.length; i++) {
        if (walletModelPromoBanner.value.data[i].vipLevelIds
            .contains(controller.profileDataRes.value.level.id)) {
          print(
              'userVipLevel MATCH obj ${walletModelPromoBanner.value.data[i].code}');
          walletModelPromoBanner.value.data[i].isVIP = true;
        }
        /*try {
          walletModelPromoBanner.value.data[i].needDepositAmtForNextVipLevel = needDepositAmtForNextVipLevel();
        } catch (e) {
          print('userVipLevel MATCH obj error ${e.toString()}');
        }*/

        //Dynamic work of assigning level to promo-code
        Utils().customPrint(
            'Dynamic VIP work:length 1 ${walletModelPromoBanner.value.data[i].vipLevelIds.length}');

        if (controller.vipmodulesAllL != null &&
            controller.vipmodulesAllL.value.data != null &&
            controller.vipmodulesAllL.value.data.length > 0) {
          for (int index = 0;
              index < controller.vipmodulesAllL.value.data.length;
              index++) {
            Utils().customPrint(
                'Dynamic VIP work:value 2 ${controller.vipmodulesAllL.value.data[index].value}');
            var firstId = walletModelPromoBanner.value.data[i].vipLevelIds[
                walletModelPromoBanner.value.data[i].vipLevelIds.length -
                    1]; //pick first one
            Utils().customPrint('Dynamic VIP work:firstId 3 ${firstId}');
            if (controller.vipmodulesAllL.value.data[index].id == firstId) {
              walletModelPromoBanner.value.data[i].vipLevel =
                  controller.vipmodulesAllL.value.data[index].value;
              Utils().customPrint(
                  'Dynamic VIP work: 4 ${controller.vipmodulesAllL.value.data[index].id} ${controller.vipmodulesAllL.value.data[index].value}');
              break;
            }
          }
        }

        Utils().customPrint(
            'Dynamic VIP work:vipLevel  ${walletModelPromoBanner.value.data[i].vipLevel}');
        //end

        //setting up temporary vip level acc to vipLevelIds[]
        /*if (walletModelPromoBanner.value.data[i].vipLevelIds != null) {
          if (walletModelPromoBanner.value.data[i].vipLevelIds.length == 1) {
            walletModelPromoBanner.value.data[i].vipLevel = 2;
          } else if (walletModelPromoBanner.value.data[i].vipLevelIds.length ==
              2) {
            walletModelPromoBanner.value.data[i].vipLevel = 1;
          } else if (walletModelPromoBanner.value.data[i].vipLevelIds.length ==
              3) {
            walletModelPromoBanner.value.data[i].vipLevel = 0;
          }
        }*/
      }
      //Utils().customPrint('userVipLevel banner VIP ${walletModelPromoBanner.data[0].isVIP}');
    } else {
      Utils().customPrint('response promo-banner code ERROR');
    }
  }

  //guided tour code
  Future<void> showTutorial(
    BuildContext context,
  ) async {
    prefs = await SharedPreferences.getInstance();
    bool guided_tour = prefs.getBool("guided_tour");
    Utils().customPrint("guided_tour prefs: $guided_tour");
    if (guided_tour == null || guided_tour) {
      prefs.setBool("guided_tour", false);
      tutorialCoachMark.show(context: context); //to show the tutorial
    }
    tutorialCoachMark.show(context: context); //to show always
    //starting line
  }

  //guided tour code
  void createTutorial() {
    Utils().customPrint('guided tour: started');
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP".tr,
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("guided tour: finish");
      },
      onClickTarget: (target) {
        print('guided tour: onClickTarget: $target');
        print('guided tour: onClickTarget: ${target.identify}');
        if (target.identify == "Target 2") {
          if (controller.profileDataRes != null &&
              controller.profileDataRes.value != null &&
              controller.profileDataRes.value.level != null) {
            Get.to(() => VipProgramScreen());
            //controller_.next();
          } else {
            Fluttertoast.showToast(
                msg: "Some thing went wrong, please restart App!");
          }
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("guided tour: onClickTargetWithTapPosition: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('guided tour: onClickOverlay: $target');
      },
      onSkip: () {
        print("guided tour: skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    //1st
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton1,
        alignSkip: Alignment.topRight,
        color: AppColor().light_red,
        enableOverlayTab: false,
        contents: [
          TargetContent(
            //align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "This page updates every time you play".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      hoverColor: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller.next();
                      },
                      child: Text(
                        "NEXT".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.underline,
                            color: Colors.green),
                        //style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    //2nd
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton2,
        alignSkip: Alignment.topRight,
        color: AppColor().light_red,
        enableOverlayTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "This wallet contains your cashback, It doesn’t have a lot of money in it as of now."
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "LET’S CLICK HERE".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        decoration: TextDecoration.underline,
                        color: Colors.white),
                    //style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      hoverColor: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (controller.profileDataRes != null &&
                            controller.profileDataRes.value != null &&
                            controller.profileDataRes.value.level != null) {
                          Get.to(() => VipProgramScreen());
                          controller_.next();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Some thing went wrong, please restart App!");
                        }
                      },
                      child: Text(
                        "NEXT".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.underline,
                            color: Colors.green),
                        //style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    //3rd
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyButton3,
        alignSkip: Alignment.topRight,
        color: AppColor().light_red,
        enableOverlayTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "This bar fills up with Real money as you play, Fill it to unlock special offers and codes!"
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      hoverColor: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller.next();
                        //Get.to(() => VipProgramScreen());
                      },
                      child: Text(
                        "NEXT".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.underline,
                            color: Colors.green),
                        //style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    //4th
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: keyButton4,
        alignSkip: Alignment.topRight,
        color: AppColor().light_red,
        enableOverlayTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "This is your current VIP level.".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      hoverColor: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller.next();
                        //Get.to(() => VipProgramScreen());
                      },
                      child: Text(
                        "NEXT".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.underline,
                            color: Colors.green),
                        //style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    //5th
    targets.add(
      TargetFocus(
        identify: "Target 5",
        keyTarget: keyButton5,
        alignSkip: Alignment.topRight,
        color: AppColor().light_red,
        enableOverlayTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Congrats! \nYou have unlocked a special code, Use this to make a deposit"
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      hoverColor: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller.next();
                        //Get.to(() => VipProgramScreen());
                      },
                      child: Text(
                        "FINISH".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.underline,
                            color: Colors.green),
                        //style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    return targets;
  }

  //WALLET PROFILE
  Future<void> getProfileData() async {
    isLoadingProfileAPI.value = false;
    Utils().customPrint('isLoadingProfileAPI: ${isLoadingProfileAPI}');
    if (token != null && token.isNotEmpty) {
      token = prefs.getString("token");
      user_id = prefs.getString("user_id");
    }
    profileDataRes.value = null;
    Map<String, dynamic> response =
        await WebServicesHelper().getProfileData(token, user_id);
    isLoadingProfileAPI.value = true;
    Utils().customPrint('isLoadingProfileAPI: ${isLoadingProfileAPI}');
    if (response != null) {
      profileDataRes.value = ProfileDataR.fromJson(response);
      if (profileDataRes.value.kyc != null) {
        if (profileDataRes.value.kyc.isApporved()) {
          sliderTrue.value = true;
          result.value = "KYC Approved";
        } else if (profileDataRes.value.kyc.statusPending
                .compareTo("pending") ==
            0) {
          sliderTrue.value = false;
          result.value = "KYC Pending";
        } else {
          sliderTrue.value = false;
          result.value = "Slide to complete KYC";
        }
      } else {
        sliderTrue.value = false;
        result.value = "Slide to complete KYC";
      }
      //Utils().customPrint('Slide to complete KYC::${result.value}');

      if (profileDataRes.value != null &&
          profileDataRes.value.withdrawMethod != null &&
          profileDataRes.value.withdrawMethod.length > 0 &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus != null &&
          profileDataRes.value.isPennyDropFaild() != null &&
          profileDataRes.value.isPennyDropFaild()) {
        /*if (profileDataRes.value != null &&
          profileDataRes.value.withdrawMethod != null &&
          profileDataRes.value.withdrawMethod.length > 0 &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus != null &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.status
                  .compareTo("failure") ==
              0) {*/
        pennyDropLockCon.value = false;
        //sliderTrue.value = false;
        AppsflyerController appsflyerController =
            Get.put(AppsflyerController());
        CleverTapController cleverTapController =
            Get.put(CleverTapController());
        Map<String, dynamic> map = {"penny_drop_status": "failure"};
        map["USER_ID"] = user_id;
        cleverTapController.logEventCT(
            EventConstant.EVENT_Penny_Drop_status, map);
        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_Penny_Drop_status_F, map);
        appsflyerController.logEventAf(
            EventConstant.EVENT_Penny_Drop_status, map);

        if (pennyDropSummaryAmount.value != null) {
          if (profileDataRes.value.settings.withdrawRequest.maxLimit >
              pennyDropSummaryAmount.value) {
            //pennyDropLockCon.value = true;
          } else {
            pennyDropLockCon.value = false;
            // sliderTrue.value = false;
          }
        }
      }

      if (profileDataRes.value != null &&
          profileDataRes.value.withdrawMethod != null &&
          profileDataRes.value.withdrawMethod.length > 0 &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus != null &&
          profileDataRes.value.isPennyDropFaild() != null &&
          !profileDataRes.value.isPennyDropFaild()) {
        /*  if (profileDataRes.value != null &&
          profileDataRes.value.withdrawMethod != null &&
          profileDataRes.value.withdrawMethod.length > 0 &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus != null &&
          profileDataRes.value.withdrawMethod[0].pennyDropCheckStatus.status
                  .compareTo("success") ==
              0) {*/
        AppsflyerController appsflyerController =
            Get.put(AppsflyerController());
        CleverTapController cleverTapController =
            Get.put(CleverTapController());
        Map<String, dynamic> map = {"penny_drop_status": "success"};
        map["USER_ID"] = user_id;
        cleverTapController.logEventCT(
            EventConstant.EVENT_Penny_Drop_status, map);
        FirebaseEvent()
            .firebaseEvent(EventConstant.EVENT_Penny_Drop_status_F, map);
        appsflyerController.logEventAf(
            EventConstant.EVENT_Penny_Drop_status, map);
        pennyDropLockCon.value = true;

        // sliderTrue.value = true;
      }
    } else {
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
