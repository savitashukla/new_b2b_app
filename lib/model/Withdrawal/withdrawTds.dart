class WithdrawTDS {
  Data data;

  WithdrawTDS({this.data});

  WithdrawTDS.fromJson(Map<String, dynamic> json) {
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
  WithdrawalFee withdrawalFee;
  PayoutAfterCharges payoutAfterCharges;
  TdsInfo tdsInfo;

  Data({this.withdrawalFee, this.payoutAfterCharges, this.tdsInfo});

  Data.fromJson(Map<String, dynamic> json) {
    withdrawalFee = json['withdrawalFee'] != null
        ? new WithdrawalFee.fromJson(json['withdrawalFee'])
        : null;
    payoutAfterCharges = json['payoutAfterCharges'] != null
        ? new PayoutAfterCharges.fromJson(json['payoutAfterCharges'])
        : null;
    tdsInfo =
        json['tdsInfo'] != null ? new TdsInfo.fromJson(json['tdsInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.withdrawalFee != null) {
      data['withdrawalFee'] = this.withdrawalFee.toJson();
    }
    if (this.payoutAfterCharges != null) {
      data['payoutAfterCharges'] = this.payoutAfterCharges.toJson();
    }
    if (this.tdsInfo != null) {
      data['tdsInfo'] = this.tdsInfo.toJson();
    }
    return data;
  }
}

class WithdrawalFee {
  int value;
  String type;

  WithdrawalFee({this.value, this.type});

  WithdrawalFee.fromJson(Map<String, dynamic> json) {
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



class PayoutAfterCharges {
    int valueP;
  String type;

  PayoutAfterCharges({this.valueP, this.type});

  PayoutAfterCharges.fromJson(Map<String, dynamic> json) {
    valueP = json['value'];
     type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['value'] = this.valueP;
     data['type'] = this.type;
     return data;
   }
 }

class TdsInfo {
  WithdrawalFee tds;
  WithdrawalFee taxableAmount;

  TdsInfo({this.tds, this.taxableAmount});

  TdsInfo.fromJson(Map<String, dynamic> json) {
    tds = json['tds'] != null ? new WithdrawalFee.fromJson(json['tds']) : null;
    taxableAmount = json['taxableAmount'] != null
        ? new WithdrawalFee.fromJson(json['taxableAmount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tds != null) {
      data['tds'] = this.tds.toJson();
    }
    if (this.taxableAmount != null) {
      data['taxableAmount'] = this.taxableAmount.toJson();
    }
    return data;
  }
}
