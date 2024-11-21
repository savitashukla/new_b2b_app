import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ProfileModel/ProfileDataR.dart';
import '../../webservices/WebServicesHelper.dart';

class EditProfileController extends GetxController {
  SharedPreferences prefs;
  var imageFile;
  String token;
  String user_id;
  String fcm_token;
  var profileDataRes = ProfileDataR().obs;
  var path_call;
  var btnControllerProfile = RoundedLoadingButtonController().obs;

  TextEditingController user_name = new TextEditingController();

  TextEditingController full_name = new TextEditingController();
  TextEditingController email_id = new TextEditingController();
  TextEditingController discord_id = new TextEditingController();
  TextEditingController bio = new TextEditingController();

  var mapKey = {}.obs;

  PickedFile pickedFile;

  var image;

  Rx<File> iamges1 = File('file.txt').obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    try {
      fcm_token = prefs.getString("fcm_token");
      getProfileData();
    } catch (E) {}
  }

  getFromGallery() async {
    /*   image = (await ImagePicker().pickImage(source: ImageSource.gallery));
    iamges1 = image;*/
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      path_call = pickedFile.path;
      iamges1.value = File(pickedFile.path);
    }
  }

  Future<void> updateProfileUser() async {
    var map = {
      "name[first]": mapKey["Enter First Name"],
      "name[last]": mapKey["Enter Last Name"],
      "about": mapKey["Enter BIO"],
      "fcmId": fcm_token,
      "email[address]": mapKey["Enter Email Id"],
      "discordId": mapKey["Enter Discord Id"],
      /*  "name[first]": user_name.value,
      "name[last]": full_name.value,
      "about": bio.value,
      "fcmId": "asdsaadasdas",
      "email[address]": email_id.value,
      "discordId": discord_id.value,*/
      "file": imageFile
    };
    Map<String, dynamic> response = await WebServicesHelper()
        .updateUserProfile(map, path_call, token, user_id);
    if (response != null) {
      getProfileData();
    } else {
      btnControllerProfile.value.reset();
    }
  }

  Future<void> getProfileData() async {
    profileDataRes.value = null;
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    Map<String, dynamic> response =
        await WebServicesHelper().getProfileData(token, user_id);
    if (response != null) {
      profileDataRes.value = ProfileDataR.fromJson(response);

      if (profileDataRes.value.name != null &&
          profileDataRes.value.name != '') {
        mapKey["Enter First Name"] = profileDataRes.value.name.first;
        // user_name.text = profileDataRes.value.name.first;
      } else {
        mapKey["Enter First Name"] = "";
      }

      if (profileDataRes.value.name != null &&
          profileDataRes.value.name != '') {
        if (profileDataRes.value.name.last != null &&
            profileDataRes.value.name.last != '') {
          mapKey["Enter Last Name"] = profileDataRes.value.name.last;
          //full_name.text = profileDataRes.value.name.last;
        } else {
          mapKey["Enter Last Name"] = ""; //Enter Last Name
        }
      } else {
        mapKey["Enter Last Name"] = ""; //Enter Last Name
      }

      if (profileDataRes.value.email != null &&
          profileDataRes.value.email != '') {
        mapKey["Enter Email Id"] = profileDataRes.value.email.address;
        // email_id.text = profileDataRes.value.email.address;
      } else {
        mapKey["Enter Email Id"] = ""; //Enter Email Id
      }
      if (profileDataRes.value.discordId != null &&
          profileDataRes.value.discordId != '') {
        mapKey["Enter Discord Id"] = profileDataRes.value.discordId;
        //discord_id.text = profileDataRes.value.discordId;
      } else {
        mapKey["Enter Discord Id"] = ""; //Enter Discord Id
      }

      if (profileDataRes.value.about != null &&
          profileDataRes.value.about != '') {
        mapKey["Enter BIO"] = profileDataRes.value.about;
        //bio.text = profileDataRes.value.about;
      } else {
        mapKey["Enter BIO"] = ""; //Enter BIO
      }
    } else {}
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
