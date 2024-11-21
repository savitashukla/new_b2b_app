import 'package:gmng/model/HomeModel/HomePageListModel.dart';

class Games {
  String id;
  Banner banner;
  ThirdParty thirdParty;
  bool isUnity;
  String name;
  int order;
  bool isClickable;
  String howToPlayUrl;

  Games(
      {this.id,
        this.banner,
        this.thirdParty,
        this.isUnity,
        this.name,
        this.order,
        this.isClickable,
        this.howToPlayUrl});

  Games.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    banner = json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    thirdParty = json['thirdParty'] != null
        ? new ThirdParty.fromJson(json['thirdParty'])
        : null;
    isUnity = json['isUnity'];
    name = json['name'];
    order = json['order'];
    isClickable = json['isClickable'];
    howToPlayUrl = json['howToPlayUrl'];
  }




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    if (this.thirdParty != null) {
      data['thirdParty'] = this.thirdParty.toJson();
    }
    data['isUnity'] = this.isUnity;
    data['name'] = this.name;
    data['order'] = this.order;
    data['isClickable'] = this.isClickable;
    data['howToPlayUrl'] = this.howToPlayUrl;
    return data;
  }
}