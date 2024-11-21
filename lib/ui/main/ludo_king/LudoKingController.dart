
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LudoKingController extends GetxController {
  var checkEventHis=true.obs;
  var colorPrimary = Color(0xFFe55f19).obs;
  var colorwhite = Color(0xFFeffffff).obs;
  var Confirm_test="CONFIRM".obs;
  SharedPreferences prefs;
  String user_id;
  // pagination add

  var scrollcontroller = ScrollController();
  var currentpage = 0.obs;
  var total_limit = 10;
  var totalAmountValues = 0.obs;

  String token;




  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');


  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");

  }


}
