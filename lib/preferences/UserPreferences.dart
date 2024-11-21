import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gmng/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utills/Utils.dart';

class UserPreferences {
  SharedPreferences prefs;
  BuildContext buildContext;
  String USER_LOGIN = "login_user";

  UserPreferences(BuildContext buildContext) {
    this.buildContext = buildContext;
    getinstnace();
  }

  Future<SharedPreferences> getinstnace() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
      return prefs;
    }
  }

  addStringValues(String key, String values) {
    if (prefs != null) prefs.setString(key, values);
  }

  Future<String> getStringValues(String key) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(key);
  }



  setStringUserId(String key, String values) {
    if (prefs != null) prefs.setString(key, values);
  }

  Future<String> getStringUserId(String key) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }



  addUserModelPrfernces(UserModel userModel) {
    if (prefs != null) prefs.setString(USER_LOGIN, jsonEncode(userModel));
  }

  Future<UserModel> getUserModel() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
 Utils().customPrint("Usernodel=="+prefs.getString(USER_LOGIN));
    if(!prefs.getString(USER_LOGIN).isEmpty){
     Map map = jsonDecode(prefs.getString(USER_LOGIN));
       return UserModel.fromMap(map);
    }

    return null;
  }

  removeValues() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
