import 'package:gmng/model/basemodel/AppBaseModel.dart';

class Pocket52Model {
  int st;
  Data d;
  String er;

  Pocket52Model({this.st, this.d, this.er});

  Pocket52Model.fromJson(Map<String, dynamic> json) {
    st = json['st'];
    d = json['d'] != null ? new Data.fromJson(json['d']) : null;
    er = json['er'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['st'] = this.st;
    if (this.d != null) {
      data['d'] = this.d.toJson();
    }
    data['er'] = this.er;
    return data;
  }
}

class Data extends AppBaseModel {
  String token;
  String p52Guid;
  Kv kv;

  String getToken() {
    return getValidString(this.token);
  }

  Data({this.token, this.p52Guid, this.kv});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    p52Guid = json['p52_guid'];
    kv = json['kv'] != null ? new Kv.fromJson(json['kv']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['p52_guid'] = this.p52Guid;
    if (this.kv != null) {
      data['kv'] = this.kv.toJson();
    }
    return data;
  }
}

class Kv extends AppBaseModel{
  String url;

  Kv({this.url});

  String getUrl(){
    return getValidString(this.url);
  }
  Kv.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
