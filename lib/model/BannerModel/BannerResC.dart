class BannerModelR {
  List<Data> data;
  Pagination pagination;

  BannerModelR({this.data, this.pagination});

  BannerModelR.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

//for redeep lock pop
  BannerModelR.fromJsonRedeemLockPopup(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        if (v['name'] == 'instantcash') data.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Data {
  String id;
  ImageC image;
  String category;
  String type;
  String name;
  String externalUrl;
  String gameId;
  String eventId;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;
  String screen;

  Data(
      {this.id,
      this.image,
      this.category,
      this.type,
      this.name,
      this.externalUrl,
      this.gameId,
      this.eventId,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.screen});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? new ImageC.fromJson(json['image']) : null;
    category = json['category'];
    type = json['type'];
    name = json['name'];
    externalUrl = json['externalUrl'];
    gameId = json['gameId'];
    eventId = json['eventId'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    screen = json['screen'] != null ? json['screen'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['category'] = this.category;
    data['type'] = this.type;
    data['name'] = this.name;
    data['externalUrl'] = this.externalUrl;
    data['gameId'] = this.gameId;
    data['eventId'] = this.eventId;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ImageC {
  String id;
  String url;

  ImageC({this.id, this.url});

  ImageC.fromJson(Map<String, dynamic> json) {
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

class Pagination {
  int offset;
  int total;
  int count;
  int limit;

  Pagination({this.offset, this.total, this.count, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    total = json['total'];
    count = json['count'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['count'] = this.count;
    data['limit'] = this.limit;
    return data;
  }
}
