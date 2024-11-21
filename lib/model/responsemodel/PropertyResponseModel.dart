

import 'package:gmng/model/basemodel/AppBaseResponseModel.dart';

import '../PropertModel.dart';

class PropertyResponseModel extends AppBaseResponseModel {
  List<PropertModel> data;


  PropertyResponseModel({this.data});

  static PropertyResponseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PropertyResponseModel data = PropertyResponseModel();
    data.error = map['error'];
    //data.status = map['status'];
    data.message = map['message'];
    data.data = List()..addAll(
        (map['data'] as List ?? []).map((o) => PropertModel.fromMap(o))
    );

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
