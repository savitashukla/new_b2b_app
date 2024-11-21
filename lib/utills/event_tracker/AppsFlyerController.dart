import 'dart:async';
import 'dart:convert';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:gmng/webservices/ApiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/UserPreferences.dart';
import '../../ui/controller/ClanController.dart';

class AppsflyerController extends GetxController {
  static var page_name = "".obs;
  static var event_id_call = "".obs;
  static var referral_code_af = "".obs;
  var page_name11 = "".obs;
  static var splashDelayRef = 4.obs;
  static var onChangesV = false.obs;
  AppsflyerSdk appsflyerSdk;
  var mediaSource = "".obs,
      campaign = "".obs,
      CampaignName = "".obs,
      CampaignType = "".obs,
      CampaignId = "".obs,
      is_deferred = false.obs,
      af_adset = "".obs,
      af_adset_id = "".obs,
      af_sub1 = "".obs,
      page = "22".obs,
      id_Call = "".obs,
      link = "".obs;
  UserPreferences userPreferences;
  var splashDelay = 0;
  ClanController clanController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    Utils().customPrint("onInstallConversionData res: check ony ");

    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: ApiUrl.APPSFLYERS_KEY, showDebug: true, appId: "123456789");
    //apps id required or iod only
    appsflyerSdk = AppsflyerSdk(options);
    Utils().customPrint("onInstallConversionData res: check ony ");

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    appsflyerSdk.onInstallConversionData((res) async {
      Utils().customPrint("onInstallConversionData res: " + res.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final pdfText = await json.decode(json.encode(res));

      try {
        prefs.setString("afAdSet", pdfText["payload"]["af_adset"] ?? "");
      } catch (E) {}

      try {
        prefs.setString(
            "mediaSource", pdfText["payload"]["media_source"] ?? "");
      } catch (E) {}

      try {
    //    if (referral_code_af.value != null || referral_code_af.value.isNotEmpty) {
          referral_code_af.value = pdfText["payload"]["referral_code"];
          print("referral_code${pdfText["payload"]["referral_code"]}");
       // }
      } catch (E) {}

      try {
        if (pdfText["payload"]["CampaignID"] != null) {
          CampaignId.value = pdfText["payload"]["CampaignID"] ?? "";
          prefs.setString("appsFlyerId", CampaignId.value ?? "");
          prefs.setString("campaignId", CampaignId.value ?? "");
        } else {
          CampaignId.value = pdfText["payload"]["campaign_id"] ?? "";
          prefs.setString("appsFlyerId", CampaignId.value ?? "");
          prefs.setString("campaignId", CampaignId.value ?? "");
        }
      } catch (E) {}

      try {
        // prefs.setString("campaignId", pdfText["payload"]["CampaignID"] ?? "");

        prefs.setString("campaign", pdfText["payload"]["campaign"] ?? "");
        //prefs.setString("appsFlyerId", pdfText["payload"]["af_web_dp"] ?? "");
        prefs.setString("campaignName", pdfText["payload"]["campaign"] ?? "");
        prefs.setString("afAdSetId", pdfText["payload"]["af_adset"] ?? "");
        prefs.setString(
            "campaignType", pdfText["payload"]["CampaignType"] ?? "");

        prefs.setString("afSub", pdfText["payload"]["af_sub2"] ?? "");
        prefs.setBool(
            "isDeferred", pdfText["payload"]["is_retargeting"] ?? false);
      } catch (E) {}
      //Fluttertoast.showToast(msg: "install ${pdfText["payload"]["install_time"]}");
    });

    appsflyerSdk.onAppOpenAttribution((res) {
      //  Fluttertoast.showToast(msg: "onAppOpenAttribution ${res.toString()}");

      Utils().customPrint("onAppOpenAttribution --->res: " + res.toString());
    });

    appsflyerSdk.onDeepLinking((DeepLinkResult dp) async {
      Utils().customPrint("onDeepLinking res: " + dp.toString());
      //  Fluttertoast.showToast(msg: "msg${dp.toString()}");
      switch (dp.status) {
        case Status.FOUND:
          //    Fluttertoast.showToast(msg: "deeaplink data=>> ${dp.deepLink?.toString()}");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          Utils().customPrint("deeplink data=>>" + dp.deepLink?.toString());

          try {
            if (referral_code_af.value != null ||
                referral_code_af.value.isNotEmpty) {
              referral_code_af.value =
                  dp.deepLink.getStringValue("referral_code");
              print(
                  "referral_code depp${dp.deepLink.getStringValue("referral_code")}  ${referral_code_af.value}");
            }
          } catch (E) {}

          try {
            page_name.value = dp.deepLink?.getStringValue("page") ?? "";

            Utils().customPrint("Apps exception call ${page_name.value}");

            event_id_call.value = dp.deepLink?.getStringValue("id") ?? "";
            id_Call.value = dp.deepLink?.getStringValue("id") ?? "";
            Utils().customPrint("Apps exception call ${id_Call.value}");

            page.value = dp.deepLink?.getStringValue("page") ?? "";
            prefs.setString("page", page.value);
            // prefs.setString("page", page.value ?? "");
            prefs.setString("id_Call", id_Call.value ?? "");
          } on Exception catch (e) {
            Utils().customPrint("Apps exception call $e");
          }

          mediaSource.value = dp.deepLink.getStringValue("media_source");
          campaign.value = dp.deepLink?.getStringValue("campaign");

          prefs.setString("mediaSource", mediaSource.value ?? "");
          prefs.setString("campaign", campaign.value ?? "");
          try {
            if (dp.deepLink?.getStringValue("CampaignID") != null) {
              CampaignId.value =
                  dp.deepLink?.getStringValue("CampaignID") ?? "";
              prefs.setString("appsFlyerId", CampaignId.value ?? "");
              prefs.setString("campaignId", CampaignId.value ?? "");
            } else {
              CampaignId.value =
                  dp.deepLink?.getStringValue("campaign_id") ?? "";
              prefs.setString("appsFlyerId", CampaignId.value ?? "");
              prefs.setString("campaignId", CampaignId.value ?? "");
            }
          } catch (E) {}
          // Utils().customPrint("msg${prefs.getString("campaignId")}");
          //Fluttertoast.showToast(msg: "msg${prefs.getString("campaignId")}");
          Utils().customPrint(
              "storeData data app${prefs.getString("mediaSource")}");
          Utils().customPrint("campaign.value ${campaign.value}");

          CampaignName.value =
              dp.deepLink?.getStringValue("CampaignName") ?? "";

          try {
            prefs.setString(
                "campaignName",
                CampaignName.value == null ||
                        CampaignName.value.compareTo("") == 0
                    ? campaign.value
                    : CampaignName.value);
          } catch (E) {}

          try {
            CampaignType.value =
                dp.deepLink.getStringValue("CampaignType") ?? "";
          } catch (E) {}

          af_adset_id.value = dp.deepLink?.getStringValue("af_adset") ?? "";
          af_sub1.value = dp.deepLink?.getStringValue("af_sub1") ?? "";
          af_adset.value = dp.deepLink?.getStringValue("af_adset") ?? "";
          link.value = dp.deepLink?.getStringValue("link") ?? "";

          prefs.setString("campaignType", CampaignType.value ?? "");
          prefs.setString("afAdSet", af_adset.value ?? "");
          prefs.setString("afAdSetId", af_adset_id.value ?? "");
          prefs.setString("afSub", af_sub1.value ?? "");
          //pid added
          Utils().customPrint('str >>> ${link}');
          try {
            if (link != null && link.value != '') {
              if (link.value.contains('pid')) {
                var str = link.value.split('pid=');
                Utils().customPrint('str >>> ${str[0]}');
                Utils().customPrint('str >>> ${str[1].split('&')[0]}');
                prefs.setString("pid",
                    str[1].split('&')[0] ?? ""); //pid added in sharedPref
              }
            }
          } catch (e) {
            Utils().customPrint('str >>> error ${e.toString()}');
          }

          try {
            if (dp.deepLink.isDeferred != null) {
              is_deferred.value = dp.deepLink.isDeferred != null
                  ? dp.deepLink.isDeferred
                  : false;
            }
          } catch (E) {}

          is_deferred.value =
              dp.deepLink.isDeferred != null ? dp.deepLink.isDeferred : false;
          prefs.setBool("isDeferred", is_deferred.value);
          Utils().customPrint("DEEPLINGING VALUES========");
          break;
        case Status.NOT_FOUND:
          Utils().customPrint("deep link not found");
          //  Fluttertoast.showToast(msg: "deep link not found ${dp.deepLink?.toString()}");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("page", "home");
          prefs.setString("id_Call", "");
          break;
        case Status.ERROR:
          Utils().customPrint("deep link error: ${dp.error}");
          //   Fluttertoast.showToast(msg: "deep link error: ${dp.deepLink?.toString()}");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("page", "home");
          prefs.setString("id_Call", "");
          break;
        case Status.PARSE_ERROR:
          //  Fluttertoast.showToast(msg: "deep link error: ${Status.PARSE_ERROR}");

          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("page", "home");
          prefs.setString("id_Call", "");
          Utils().customPrint("deep link status parsing error");
          break;
      }
    });
  }

  Future<bool> logEventAf(String eventName, Map eventValues) async {
    bool result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception {}
    Utils().customPrint("Result logEvent: $result");
  }

  Future<String> getAppsFlyerID() {
    print("getAppsFlyerID");
    //  Fluttertoast.showToast(msg: "getAppsFlyerID");
    return appsflyerSdk.getAppsFlyerUID();
  }
}
