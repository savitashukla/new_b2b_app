

import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoader(){
  Get.dialog(const Center(child: CircularProgressIndicator()),
      barrierDismissible: false);
}

hideLoader(){
  Get.back();
}