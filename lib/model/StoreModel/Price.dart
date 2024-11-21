class Price {
  int value;
  String type;
  String currency;

  Price({this.value, this.type, this.currency});

  Price.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    data['currency'] = this.currency;
    return data;
  }
}