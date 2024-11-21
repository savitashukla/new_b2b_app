import '../BannerModel/BannerResC.dart';
import 'Price.dart';

class StoreModelR {
  List<StoreItem> data;
  Pagination pagination;

  StoreModelR({this.data, this.pagination});

  StoreModelR.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<StoreItem>();
      json['data'].forEach((v) {
        if (v['status'] == true) {
          data.add(new StoreItem.fromJson(v));
        }
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

class StoreItem {
  String id;
  Price price;
  String name;
  GameId gameId;
  int quantity;
  bool status;
  String description;
  Image image;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  StoreItem({this.id,
    this.price,
    this.name,
    this.gameId,
    this.quantity,
    this.status,
    this.description,
    this.image,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt});

  StoreItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    name = json['name'];
    gameId = json['gameId']!=null?new GameId.fromJson(json['gameId']):null;
    quantity = json['quantity'];
    status = json['status'];
    description = json['description'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.price != null) {
      data['price'] = this.price.toJson();
    }
    data['name'] = this.name;
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class GameId {
  String id, name;
  GameId({this.id, this.name});
  GameId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Image {
  String id;
  String url;

  Image({this.id, this.url});

  Image.fromJson(Map<String, dynamic> json) {
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
