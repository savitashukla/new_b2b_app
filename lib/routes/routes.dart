import 'package:gmng/ui/HomePageNew.dart';
import 'package:gmng/ui/login/webview_t_c.dart';
import 'package:gmng/ui/main/ballabazzi/BallebaaziWebview.dart';
import 'package:gmng/ui/main/dashbord/DashBord.dart';

import 'package:gmng/ui/main/sidemenu/cms/Cmspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:gmng/ui/main/dashbord/home/Home.dart';
import 'package:gmng/ui/main/wallet/InvoidWebview.dart';
import 'package:gmng/ui/splash/Splash.dart';

import '../ui/login/Login.dart';

class Routes {
  // Route name constants
  static const String List = '/list';
  static const String Splace = '/';
  static const String Detail = '/detail';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/DashBoard';
  static const String home = '/HomePageNew';
  static const String search = '/Search';
  static const String cmspage = '/Cmspage';
  static const String ballbaziGame = '/ballbazi';
  static const String invoide = '/invoide';
  static const String wallet = '/Wallet';
  static const String webview_t_c = '/webview_t_c';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.login: (context) => Login(),
      Routes.Splace: (context) => Splash(),
      Routes.dashboard: (context) => DashBord(2, ""),
      Routes.home: (context) => HomePageNew(),
      Routes.wallet: (context) => DashBord(4, ""),
      Routes.cmspage: (context) => Cmspage("test"),
      Routes.ballbaziGame: (context) => BallebaaziWebview("test"),
      Routes.invoide: (context) => InvoidWebview("test"),
      Routes.webview_t_c: (context) => WebViewTermsConditions(""),
    };
  }
}
