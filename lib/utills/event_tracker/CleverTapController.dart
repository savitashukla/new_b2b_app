import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';

import '../../res/AppString.dart';
import '../../ui/main/dashbord/DashBord.dart';

class CleverTapController extends GetxController {
  CleverTapPlugin _clevertapPlugin;
  var inboxCount = 0.obs;

  @override
  void onInit() {
    activateCleverTapFlutterPluginHandlers();
    super.onInit();
  }

  Future<void> activateCleverTapFlutterPluginHandlers() async {
    _clevertapPlugin = new CleverTapPlugin();
    CleverTapPlugin.initializeInbox();
    CleverTapPlugin.setDebugLevel(3);
    CleverTapPlugin.createNotificationChannel(
        "GMNG", "GMNG", "Your Channel Description", 5, true);
    CleverTapPlugin.registerForPush();
    CleverTapPlugin.enableDeviceNetworkInfoReporting(true);

    int total = await CleverTapPlugin.getInboxMessageCount();
    Utils().customPrint(
        "Total count = " + total.toString()); // show repeated  data
    List messages = await CleverTapPlugin.getAllInboxMessages();
    Utils().customPrint("messages count = " + messages.toString());
    int unread = await CleverTapPlugin.getInboxMessageUnreadCount();
    inboxCount.value = unread;
    Utils().customPrint("Unread count = " + unread.toString());

    //Handler for receiving Push Clicked Payload
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
    _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
    _clevertapPlugin
        .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
    _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
        inAppNotificationButtonClicked);
    _clevertapPlugin.setCleverTapInAppNotificationDismissedHandler(
        inAppNotificationDismissed);

    getUserCleverTabId();
  }

  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    Utils().customPrint('---------------------> C 1');
    Utils().customPrint("pushClickedPayloadReceived called");
    // var data = jsonEncode(map);
    Utils().customPrint("on Push Click Payload = " + map.toString());
  }

  void inboxDidInitialize() {
    Utils().customPrint('---------------------> C 2');
    Utils().customPrint("inboxDidInitialize called");
  }

  void onDisplayUnitsLoaded(List<dynamic> displayUnits) {
    Utils().customPrint('---------------------> C 3');

    //List displayUnits = await CleverTapPlugin.getAllDisplayUnits();
    Utils().customPrint("inboxDidInitialize called");
    Utils().customPrint("Display Units are " + displayUnits.toString());
  }

  void inAppNotificationButtonClicked(Map<String, dynamic> map) {
    Utils().customPrint('---------------------> C 4');
    //this method
    Utils().customPrint(
        "inAppNotificationButtonClicked called = ${map.toString()}");
    if (map != null) {
      if (map['page'] != null &&
          map['page'] != "" &&
          map['page'] == 'lootbox') {
        AppString.isClickFromHome = true;
        Get.offAll(DashBord(0, ""));
      }
    }
  }

  void inAppNotificationDismissed(Map<String, dynamic> map) {
    Utils().customPrint('---------------------> C 5$map');
    Utils().customPrint("inAppNotificationDismissed called");
  }

  void profileDidInitialize() {
    Utils().customPrint("profileDidInitialize called");
  }

  void profileDidUpdate(Map<String, dynamic> map) {
    Utils().customPrint("profileDidUpdate called");
  }

  Future<void> logEventCT(String eventName, Map eventValues) async {
    try {
      CleverTapPlugin.recordEvent(eventName, eventValues);
    } on Exception {}
  }

  void updateUserProfile(var profile) {
    CleverTapPlugin.onUserLogin(profile); //for passing identity
  }

  void setUserProfile(var profile) {
    CleverTapPlugin.profileSet(profile); //for updation
    //CleverTapPlugin.onUserLogin(profile);//for passing identity
  }

  void getUserCleverTabId() {
    //our method
    CleverTapPlugin.getCleverTapID().then((clevertapId) {
      if (clevertapId == null) return;
      Utils().customPrint("cleverTapID===>${clevertapId.toString()}");
    });
  }

  void setLocation(lat, long) {
    CleverTapPlugin.setLocation(lat, long);
  }

  void inboxMessagesDidUpdate() {
    Utils().customPrint("inboxMessagesDidUpdate called");
  }

  void inboxNotificationButtonClicked(Map<String, dynamic> map) {
    Utils().customPrint(
        "inboxNotificationButtonClicked called = ${map.toString()}");
  }
}
