import 'package:gmng/base/BaseModel.dart';

class PreJoinUnityResponseModel extends BaseModel {
  DeficitAmount1 deficitAmount;
  DeficitAmount1 winning;
  DeficitAmount1 deposit;
  DeficitAmount1 bonus;

  String webViewUrl;

  PreJoinUnityResponseModel(
      {this.deficitAmount, this.winning, this.deposit, this.bonus,this.webViewUrl});

  PreJoinUnityResponseModel.fromJson(Map<String, dynamic> json) {
    deficitAmount = json['deficitAmount'] != null
        ? new DeficitAmount1.fromJson(json['deficitAmount'])
        : null;
    winning = json['winning'] != null
        ? new DeficitAmount1.fromJson(json['winning'])
        : null;
    deposit = json['deposit'] != null
        ? new DeficitAmount1.fromJson(json['deposit'])
        : null;
    bonus = json['bonus'] != null
        ? new DeficitAmount1.fromJson(json['bonus'])
        : null;

    webViewUrl = json['webViewUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class DeficitAmount1 extends BaseModel {
  dynamic _value;
  String _type;

  DeficitAmount1({int value, String type}) {
    if (value != null) {
      this._value = value;
    }
    if (type != null) {
      this._type = type;
    }
  }

  dynamic get value => _value;

  set value(dynamic value) => _value = value;

  String get type => getValidString(_type);

  set type(String type) => _type = type;

  DeficitAmount1.fromJson(Map<String, dynamic> json) {
    _value = json['value'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this._value;
    data['type'] = this._type;
    return data;
  }
}
