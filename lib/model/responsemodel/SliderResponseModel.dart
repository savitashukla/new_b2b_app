import 'package:gmng/model/SliderModel.dart';
import 'package:gmng/model/basemodel/AppBaseResponseModel.dart';

class SliderResponseModel extends AppBaseResponseModel {
  List<SliderModel> data;


  SliderResponseModel({this.data});

  static SliderResponseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SliderResponseModel data = SliderResponseModel();
    data.error = map['error'];
    //data.status = map['status'];
    data.message = map['message'];
    data.data = List()..addAll(
        (map['data'] as List ?? []).map((o) => SliderModel.fromMap(o))
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
