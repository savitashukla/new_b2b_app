class CashfreeStatusModel {
  Data data;

  CashfreeStatusModel({this.data});

  CashfreeStatusModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  bool success;
  Error error;

  Data({this.success, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class Error {
  String code;
  String description;
  String reason;
  String source;
  String step;

  Error({this.code, this.description, this.reason, this.source, this.step});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    reason = json['reason'];
    source = json['source'];
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    data['reason'] = this.reason;
    data['source'] = this.source;
    data['step'] = this.step;
    return data;
  }
}
