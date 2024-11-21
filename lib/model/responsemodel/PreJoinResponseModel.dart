
import 'package:gmng/base/BaseModel.dart';

class PreJoinResponseModel extends BaseModel {
  DeficitAmount deficitAmount;
  DeficitAmount winning;
  DeficitAmount deposit;
  DeficitAmount bonus;

  PreJoinResponseModel(
      {this.deficitAmount, this.winning, this.deposit, this.bonus});

  PreJoinResponseModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class DeficitAmount extends BaseModel {
  double _value;
  String _type;

  DeficitAmount({double value, String type}) {
    if (value != null) {
      this._value = value;
    }
    if (type != null) {
      this._type = type;
    }
  }

  double get value => _value;

  set value(double value) => _value = value;

  String get type => getValidString(_type);

  set type(String type) => _type = type;

  DeficitAmount.fromJson(Map<String, dynamic> json) {
    _value = double.parse(json['value'].toString()); //changes
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this._value;
    data['type'] = this._type;
    return data;
  }
}
