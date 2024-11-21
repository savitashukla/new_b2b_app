import 'package:gmng/model/basemodel/AppBaseModel.dart';

 class AppBaseResponseModel extends AppBaseModel {

 // String status;
  int statusCode;
  String error;
  String errorCode;

  static AppBaseResponseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AppBaseResponseModel model=new AppBaseResponseModel();
    model.statusCode=map['statusCode'];
    model.error=map['error'];
    model.errorCode=map['errorCode'];
    return model;
  }

  Map toJson() => {
    "statusCode": statusCode,
    "error": error,
    "errorCode": errorCode,
  };

  @override
  String toString() {
    // TODO: implement toString
    return error.toString()+"";
  }

}