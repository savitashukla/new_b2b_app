class WebViewTamashaModel {
  bool success;
  DeficitAmount deficitAmount;
  DeficitAmount winning;
  DeficitAmount deposit;
  DeficitAmount bonus;
  String webViewUrl;

  WebViewTamashaModel(
      {this.success,
      this.deficitAmount,
      this.winning,
      this.deposit,
      this.bonus,
      this.webViewUrl});

  WebViewTamashaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    deficitAmount = json['deficitAmount'] != null
        ? new DeficitAmount.fromJson(json['deficitAmount'])
        : null;
    winning = json['winning'] != null
        ? new DeficitAmount.fromJson(json['winning'])
        : null;
    deposit = json['deposit'] != null
        ? new DeficitAmount.fromJson(json['deposit'])
        : null;
    bonus = json['bonus'] != null
        ? new DeficitAmount.fromJson(json['bonus'])
        : null;
    webViewUrl = json['webViewUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.deficitAmount != null) {
      data['deficitAmount'] = this.deficitAmount.toJson();
    }
    if (this.winning != null) {
      data['winning'] = this.winning.toJson();
    }
    if (this.deposit != null) {
      data['deposit'] = this.deposit.toJson();
    }
    if (this.bonus != null) {
      data['bonus'] = this.bonus.toJson();
    }
    data['webViewUrl'] = this.webViewUrl;
    return data;
  }
}

class DeficitAmount {
  int value;
  String type;

  DeficitAmount({this.value, this.type});

  DeficitAmount.fromJson(Map<String, dynamic> json) {
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
