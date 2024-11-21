
import 'package:gmng/model/CmsPageModel.dart';
import 'package:gmng/model/basemodel/AppBaseResponseModel.dart';

class CmsPageResponseModel extends AppBaseResponseModel {
  CmsPageModel data;
  CmsPageResponseModel({this.data});

  static CmsPageResponseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CmsPageResponseModel data = CmsPageResponseModel();
    data.error = map['error'];
    //data.status = map['status'];
    data.message = map['message'];
    data.data =CmsPageModel.fromMap(map['data']);

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
