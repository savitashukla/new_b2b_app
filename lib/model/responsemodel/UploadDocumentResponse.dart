class UploadDocumentResponse {
  List<Documents> documents;

  UploadDocumentResponse({this.documents});

  UploadDocumentResponse.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = new List<Documents>();
      json['documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  Storage storage;
  String type;
  String subType;
  String status;
  String sId;

  Documents({this.storage, this.type, this.subType, this.status, this.sId});

  Documents.fromJson(Map<String, dynamic> json) {
    storage =
    json['storage'] != null ? new Storage.fromJson(json['storage']) : null;
    type = json['type'];
    subType = json['subType'];
    status = json['status'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storage != null) {
      data['storage'] = this.storage.toJson();
    }
    data['type'] = this.type;
    data['subType'] = this.subType;
    data['status'] = this.status;
    data['_id'] = this.sId;
    return data;
  }
}

class Storage {
  String id;
  String url;

  Storage({this.id, this.url});

  Storage.fromJson(Map<String, dynamic> json) {
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