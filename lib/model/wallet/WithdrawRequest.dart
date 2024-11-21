import 'package:gmng/utills/Utils.dart';

class WithdrawRequestNew {
  List<WithdrawRequestNewList> data;

  WithdrawRequestNew({this.data});

  WithdrawRequestNew.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<WithdrawRequestNewList>();
      List<WithdrawRequestNewList> dataTemp= new List<WithdrawRequestNewList>();
      json['data'].forEach((v) {
        dataTemp.add(new WithdrawRequestNewList.fromJson(v));
        /*if (v['status'] == 'approvalRequired') {
          dataTemp.add(new WithdrawRequestNewList.fromJson(v));
        }

        else if(v['status'] == 'pending')
          {
            dataTemp.add(new WithdrawRequestNewList.fromJson(v));
          }
        else if(v['status'] == 'cancelled')
        {
          dataTemp.add(new WithdrawRequestNewList.fromJson(v));

        }*/
      });
      data.addAll(dataTemp.reversed);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WithdrawRequestNewList {
  /*{"data":[{"id":"63a2c1b986c39e2d9ce625cf","amount":{"value":25100,"type":"currency","currency":"inr"},"userId":"630f49c03c464bcbcd2a2851","withdrawMethodId":"63a2b963078b7ef1fa05f341","transactionId":"63a2c1b986c39e2d9ce625d3","status":"cancelled","walletId":"630f49c03c464bcbcd2a2855","isApproved":null,"createdAt":"2022-12-21T08:20:09.570Z","updatedAt":"2022-12-21T08:26:05.916Z","message":"Cancelled By User","updatedBy":"630f49c03c464bcbcd2a2851"}]
  ,"pagination":{"offset":0,"total":1,"count":1,"limit":-1}}*/

  String id;
  Amount amount;
  String mode;
  String walletId;
  String description;
  String referenceTransactionId;
  var revertedTransactionId;
  bool isReverted;
  String createdAt;
  String status;
  String updatedAt;
  String transactionId;

  WithdrawRequestNewList(
      {this.id,
      this.amount,
      this.mode,
      this.walletId,
      this.description,
      this.referenceTransactionId,
      this.revertedTransactionId,
      this.isReverted,
      this.createdAt,
      this.status,

      this.transactionId,
      this.updatedAt});

  WithdrawRequestNewList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    transactionId = json['transactionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['transactionId'] = this.transactionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}

class Amount {
  var value;
  String type;
  String currency;

  Amount({this.value, this.type, this.currency});

  bool isBonuseType() {
    bool is_bonuse_type = false;
    Utils().customPrint(this.type);
    if (this.type == "bonus") {
      is_bonuse_type = true;
    }
    Utils().customPrint("is_bonuse_type==>${is_bonuse_type}");
    return is_bonuse_type;
  }

  Amount.fromJson(Map<String, dynamic> json) {
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
