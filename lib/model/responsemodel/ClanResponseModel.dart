import 'package:gmng/model/ClanModel.dart';

class ClanResponseModel {
  List<ClanModel> data;
  ClanResponseModel({this.data});

  ClanResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] != []) {
      data = new List<ClanModel>();
      json['data'].forEach((v) {
        data.add(new ClanModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
