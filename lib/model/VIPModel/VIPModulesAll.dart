class VIPModulesAll {
  List<Data> data;
  Pagination pagination;

  VIPModulesAll({this.data, this.pagination});

  VIPModulesAll.fromJson(Map<String, dynamic> json) {
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
  Withdrawal withdrawal;
  Cashback cashback;
  String name;
  String description;
  int value;
  Banner banner;
  String status;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;
  Criteria criteria;

  Data(
      {this.id,
      this.withdrawal,
      this.cashback,
      this.name,
      this.description,
      this.value,
      this.banner,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.criteria});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    withdrawal = json['withdrawal'] != null
        ? new Withdrawal.fromJson(json['withdrawal'])
        : null;
    cashback = json['cashback'] != null
        ? new Cashback.fromJson(json['cashback'])
        : null;
    name = json['name'];
    description = json['description'];
    value = json['value'];
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    criteria = json['criteria'] != null
        ? new Criteria.fromJson(json['criteria'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.withdrawal != null) {
      data['withdrawal'] = this.withdrawal.toJson();
    }
    if (this.cashback != null) {
      data['cashback'] = this.cashback.toJson();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    data['value'] = this.value;
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.criteria != null) {
      data['criteria'] = this.criteria.toJson();
    }
    return data;
  }
}

class Withdrawal {
  int fee;
  int perTransactionLimit;
  int maxDailyLimit;

  Withdrawal({this.fee, this.perTransactionLimit, this.maxDailyLimit});

  Withdrawal.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    perTransactionLimit = json['perTransactionLimit'];
    maxDailyLimit = json['maxDailyLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['perTransactionLimit'] = this.perTransactionLimit;
    data['maxDailyLimit'] = this.maxDailyLimit;
    return data;
  }
}

class Cashback {
  int depositPercent;
  int depositMaxCashback;

  Cashback({this.depositPercent, this.depositMaxCashback});

  Cashback.fromJson(Map<String, dynamic> json) {
    depositPercent = json['depositPercent'];
    depositMaxCashback = json['depositMaxCashback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['depositPercent'] = this.depositPercent;
    data['depositMaxCashback'] = this.depositMaxCashback;
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

class Criteria {
  int instantCashLimit;

  Criteria({this.instantCashLimit});

  Criteria.fromJson(Map<String, dynamic> json) {
    instantCashLimit = json['instantCashLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['instantCashLimit'] = this.instantCashLimit;
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
