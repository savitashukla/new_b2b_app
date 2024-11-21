import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gmng/res/AppColor.dart';
import 'package:gmng/res/changes_language/LocaleString.dart';
import 'package:gmng/routes/routes.dart';
import 'package:gmng/ui/splash/Splash.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  final String flavor;

  App({Key key, this.flavor}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var splashDelay = 0;

  @override
  Future<void> initState() {
    super.initState();
    Utils().getLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: AppColor().colorPrimary,
                  fontFamily: 'Montserrat',
                ),
                translations: LocaleString(),
                navigatorKey: navigatorKey,
                locale:
                    Locale(Utils.language.value, Utils.language_country.value),
                routes: Routes.getRoutes(),
                builder: (context, child) {
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child);
                });
          }
        }
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/splash_back.png"),
            fit: BoxFit.fitWidth,
          )),
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                      height: 70,
                      //width: 40,
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/gmng_logo.png")),
                ),
                Container(
                  height: 0,
                ),
                Image(
                    height: 100,
                    width: 100,
                    //color: Colors.transparent,
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/progresbar_images.gif")),

                //flutterM()
                //  Obx(() =>    splashController.splashPro.value?showProgressUnity(context, "", false):Container(height: 0,))
                //splashController.splashPro.value?showProgressD(context, "", false):Container(height: 0,)
              ],
            ),
          ),
        );
      },
      future: Utils().getLocation(),
    );
  }
}
