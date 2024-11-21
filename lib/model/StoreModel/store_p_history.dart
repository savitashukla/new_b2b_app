class Store_p_history {
  List<Data> data;
  Pagination pagination;

  Store_p_history({this.data, this.pagination});

  Store_p_history.fromJson(Map<String, dynamic> json) {
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
  int quantity;
  StoreItemId storeItemId;
  int totalAmount;
  String status;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;
  String bonusTransactionId;
  String depositTransactionId;
  String winningTransactionId;

  Data(
      {this.id,
        this.quantity,
        this.storeItemId,
        this.totalAmount,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.bonusTransactionId,
        this.depositTransactionId,
        this.winningTransactionId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    storeItemId = json['storeItemId'] != null
        ? new StoreItemId.fromJson(json['storeItemId'])
        : null;
    totalAmount = json['totalAmount'];
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bonusTransactionId = json['bonusTransactionId'];
    depositTransactionId = json['depositTransactionId'];
    winningTransactionId = json['winningTransactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    if (this.storeItemId != null) {
      data['storeItemId'] = this.storeItemId.toJson();
    }
    data['totalAmount'] = this.totalAmount;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['bonusTransactionId'] = this.bonusTransactionId;
    data['depositTransactionId'] = this.depositTransactionId;
    data['winningTransactionId'] = this.winningTransactionId;
    return data;
  }
}

class StoreItemId {
  String id;
  String name;
  Image image;
  String description;
/*
  String gameId;
*/
  int quantity;
  bool status;

  StoreItemId(
      {this.id,
        this.name,
        this.image,
        this.description,
/*
        this.gameId,
*/
        this.quantity,
        this.status});

  StoreItemId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    description = json['description'];
    /*if(json['gameId']!=null)
      {
        gameId = json['gameId'];
      }*/

    quantity = json['quantity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['description'] = this.description;
/*
    data['gameId'] = this.gameId;
*/
    data['quantity'] = this.quantity;
    data['status'] = this.status;
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
