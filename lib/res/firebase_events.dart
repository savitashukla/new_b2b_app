import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseEvent{
   firebaseEvent(String eventName,Map<String ,dynamic> parmse)
   {
     FirebaseAnalytics firebaseAnalytics=FirebaseAnalytics.instance;
     firebaseAnalytics.logEvent(name: eventName,parameters: parmse);
   }
}