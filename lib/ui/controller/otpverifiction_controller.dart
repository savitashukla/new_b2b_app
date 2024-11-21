import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';

import '../common/Progessbar.dart';

class OtpVerificationController extends GetxController
{
  TextEditingController passordconrtoller = new TextEditingController();
  var Otp="".obs;
  var bottomSheetController;
  ProgessDialog progessbar;
  var password = "".obs;
  _printLatestValue(String values) {
    Utils().customPrint("Second text field: ${values}");
  }


}
