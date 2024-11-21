import 'dart:core';

class BaseModel {

  bool isValidString(String data) {
    return data != null && !data.isEmpty;
  }

   String getValidString(String data) {
    return data == null ? "" : data;
  }

}