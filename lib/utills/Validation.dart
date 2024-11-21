import 'package:flutter/cupertino.dart';

import 'Utils.dart';

class Validation {
  BuildContext context;

  Validation(BuildContext context) {
    this.context = context;
  }

  // String EMAIL_REGEX = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
  static String emailMessageEmpty = "Please enter your valid email.";
  static String EMAIL_MSG_INVALID =
      "You have entered an invalid email address.";

  //String MOBILE_REGEX = "^[+]?[0-9]{7,15}$";
  static String MOBILENUMBER_MSG_EMPTY = "Please enter your mobile number.";
  static String MOBILENUMBER_MSG_INVALID =
      "You have entered an invalid mobile number.";
  static String EMAIL_OR_MOBILE_MSG_EMPTY =
      "Please enter your valid email / mobile number.";
  static String PASSWORD_MSG_EMPTY = "Please enter your password.";
  static String PASSWORD_MSG_INVALID =
      "Your password can't start or end with a blank space.";
  static String PASSWORD_MSG_INVALID_LENGTH =
      "You must be provide at least 6 to 30 characters for password.";
  static String CONFIRM_PASSWORD_MSG_EMPTY =
      "Please enter your confirm password.";
  static String CONFIRM_PASSWORD_MSG_INVALID =
      "Password and confirm password does not match.";
  static String OTP_MSG_EMPTY = "Please enter your OTP.";
  static String OTP_MSG_INVALID = "You have entered an invalid OTP.";
  static String FIRST_NAME_MSG_EMPTY = "Please enter your first name.";
  static String FIRST_NAME_MSG_INVALID =
      "Your first name can't start or end with a blank space.";
  static String FIRST_NAME_MSG_INVALID_LENGTH =
      "First name should be 3 to 20 Alphabetic Characters only.";
  static String LAST_NAME_MSG_EMPTY = "Please enter your last name.";
  static String LAST_NAME_MSG_INVALID =
      "Your last name can't start or end with a blank space.";
  static String LAST_NAME_MSG_INVALID_LENGTH =
      "Last name should be 3 to 20 Alphabetic Characters only.";
  static String NAME_MSG_EMPTY = "Please enter your  name.";
  static String NAME_MSG_INVALID =
      "Your name can't start or end with a blank space.";
  static String NAME_MSG_INVALID_LENGTH =
      "Name should be 3 to 20 Alphabetic Characters only.";

  static bool isValidString(String data) {
    return data != null && !data.trim().isEmpty;
  }

  static bool isvalidEmail(String email) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
  Utils().customPrint("email=>"+regExp.hasMatch(email).toString());
    return regExp.hasMatch(email);
  }

  static bool validMobileNumber(String mobileNumber) {
    if (isValidString(mobileNumber)) {
      return false;
    }
    return true;
  }

  static bool validMobileNumberLength(String mobileNumber) {
    if (mobileNumber.length < 7 || mobileNumber.length > 15) {
      return false;
    }

    return true;
  }
}