import 'package:gmng/model/basemodel/AppBaseModel.dart';

class LeaderBoardResponse {
  List<LeaderBoardModel> data;

  LeaderBoardResponse({this.data});

  LeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<LeaderBoardModel>();
      json['data'].forEach((v) {
        data.add(new LeaderBoardModel.fromJson(v));
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

class LeaderBoardModel {
  String id;
  String username;
  Name name;
  Amount amount;
  Photo photo;
  int count;
  int rank;

  LeaderBoardModel(
      {this.id,
      this.username,
      this.name,
      this.amount,
      this.photo,
      this.count,
      this.rank});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    count = json['count'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    data['count'] = this.count;
    data['rank'] = this.rank;
    return data;
  }
}

class Name extends AppBaseModel {
  String first;
  String last;

  Name({this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}

class Amount {
  int value;
  String type;

  num getAmountValues(){
    int value=this.value;
    if(this.type=='currency'){
      return value~/100;
    }
    return value;
  }

  Amount({this.value, this.type});

  Amount.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

class Photo {
  String id;
  String url;

  Photo({this.id, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
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
