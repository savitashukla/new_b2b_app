import 'package:facebook_app_events/facebook_app_events.dart';

import '../Utils.dart';

class FaceBookEventController {
  Future<void> logEventFacebook(String eventName, Map eventValues) async {
    final facebookAppEvents = FacebookAppEvents();
    try {
      facebookAppEvents.logEvent(
        name: eventName,
        parameters: eventValues,
      );
      Future<String> id = facebookAppEvents.getAnonymousId();
      Utils().customPrint(id);
    } on Exception catch (e) {
      Utils().customPrint("facebook exception $e");
    }
    facebookAppEvents.setAdvertiserTracking(enabled: true);
  }

  /*Future<void> logPurchase(int amount) async {
    final facebookAppEvents1 = FacebookAppEvents();

    facebookAppEvents1.logPurchase(amount: 10, currency: "INR");
  }*/
  Future<void> logPurchase(double amount, var map) async {
    final facebookAppEvents1 = FacebookAppEvents();
    facebookAppEvents1.logPurchase(
        amount: amount, currency: "INR", parameters: map);
  }
}
