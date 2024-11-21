class Version_Update_Model {
  List<Data> data;
  Pagination pagination;

  Version_Update_Model({this.data, this.pagination});

  Version_Update_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
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
  String type;
  String platform;
  String version;
  String downloadUrl;
  bool isCurrent;
  String createdBy;
  String updatedBy;
  String description;
  String createdAt;
  String updatedAt;
  bool isBlocked;

  Data(
      {this.id,
        this.type,
        this.platform,
        this.version,
        this.downloadUrl,
        this.isCurrent,
        this.createdBy,
        this.updatedBy,
        this.description,
        this.createdAt,
        this.updatedAt,this.isBlocked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    platform = json['platform'];
    version = json['version'];
    downloadUrl = json['downloadUrl'];
    isCurrent = json['isCurrent'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    description=json['description'];
    isBlocked=json['isBlocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['platform'] = this.platform;
    data['version'] = this.version;
    data['downloadUrl'] = this.downloadUrl;
    data['isCurrent'] = this.isCurrent;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['description'] = this.description;
    data['isBlocked'] = this.isBlocked;

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
