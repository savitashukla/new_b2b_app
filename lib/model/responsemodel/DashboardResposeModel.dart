
import 'package:gmng/model/DashboardModel.dart';
import 'package:gmng/model/basemodel/AppBaseResponseModel.dart';


class DashboardResposeModel extends AppBaseResponseModel {
  DashboardModel data;

  DashboardResposeModel({this.data});

  static DashboardResposeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DashboardResposeModel data = DashboardResposeModel();
    data.error = map['error'];
    data.message = map['message'];
    data.data = map['data'] != null ? new DashboardModel().fromMap(map['data']) : null;
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
