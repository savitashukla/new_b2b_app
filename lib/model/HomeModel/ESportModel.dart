import '../Pagination.dart';

class EsportModelR {
  List<Data> data;
  Pagination pagination;
  Map<String, dynamic> jso = {"id": "0", "name": "All Game"};

  EsportModelR({this.data, this.pagination});

  EsportModelR.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      data.add(new Data.fromJson(jso));

      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Data {
  String id;
  Banner banner;
  String name;
  int order;
  String gameCategoryId;
  bool isClickable;
  String howToPlayUrl;
  String status;
  ThirdParty thirdParty;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.banner,
      this.name,
      this.order,
      this.gameCategoryId,
      this.isClickable,
      this.howToPlayUrl,
      this.status,
      this.thirdParty,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    name = json['name'];
    order = json['order'];
    gameCategoryId = json['gameCategoryId'];
    isClickable = json['isClickable'];
    howToPlayUrl = json['howToPlayUrl'];
    status = json['status'];
    thirdParty = json['thirdParty'] != null
        ? new ThirdParty.fromJson(json['thirdParty'])
        : null;
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['name'] = this.name;
    data['order'] = this.order;
    data['gameCategoryId'] = this.gameCategoryId;
    data['isClickable'] = this.isClickable;
    data['howToPlayUrl'] = this.howToPlayUrl;
    data['status'] = this.status;
    if (this.thirdParty != null) {
      data['thirdParty'] = this.thirdParty.toJson();
    }
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ThirdParty {
  String name;
  String url;

  ThirdParty({this.name, this.url});

  ThirdParty.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Banner {
  String id;
  String url;

  Banner({this.id, this.url});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
