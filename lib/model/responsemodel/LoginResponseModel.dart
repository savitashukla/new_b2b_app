

import 'package:gmng/model/basemodel/AppBaseResponseModel.dart';

import '../UserModel.dart';

class LoginResponseModel extends AppBaseResponseModel {
  UserModel data;


  LoginResponseModel({this.data});

  static LoginResponseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    LoginResponseModel data = LoginResponseModel();
    data.error = map['error'];
    //data.status = map['status'];
    data.message = map['message'];
    data.data =UserModel.fromMap(map['data']);

    return data;
  }



  Map toJson() => {
        "error": error,
        "message": message,
         "code": code,
         "data": data,
      };

  //,${json.encode(this.data)}

  @override
  String toString() {
    return '{ ${this.error}  ${this.data}}';
  }
}
