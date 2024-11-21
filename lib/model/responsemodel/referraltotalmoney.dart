class ReferralTotalMoney {
  List<Data> data;
  Data total;

  ReferralTotalMoney({this.data, this.total});

  ReferralTotalMoney.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    total = json['total'] != null ? new Data.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.total != null) {
      data['total'] = this.total.toJson();
    }
    return data;
  }
}

class Data {
  int value;
  String type;

  Data({this.value, this.type});

  Data.fromJson(Map<String, dynamic> json) {
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
