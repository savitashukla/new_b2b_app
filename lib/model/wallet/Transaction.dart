import 'package:gmng/model/basemodel/AppBaseModel.dart';
import 'package:gmng/utills/Utils.dart';

class Transaction {
  List<TransactionList> data;
  Pagination pagination;

  Transaction({this.data, this.pagination});

  Transaction.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TransactionList>();
      json['data'].forEach((v) {
        data.add(new TransactionList.fromJson(v));
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

class TransactionList extends AppBaseModel{
  String id;
  Amount amount;
  String mode;
  String walletId;
  String description;
  Operation operation;
  Payment payment;
  String referenceTransactionId;
  var revertedTransactionId;
  bool isReverted;
  String date;
  String status;
  String createdAt;
  String updatedAt;

  TransactionList(
      {this.id,
      this.amount,
      this.mode,
      this.walletId,
      this.description,
      this.operation,
      this.payment,
      this.referenceTransactionId,
      this.revertedTransactionId,
      this.isReverted,
      this.date,
      this.createdAt,
      this.updatedAt,this.status});

  TransactionList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    mode = json['mode'];
    walletId = json['walletId'];
    description = json['description'];
    operation = json['operation'] != null
        ? new Operation.fromJson(json['operation'])
        : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;

    if (revertedTransactionId != null) {
      revertedTransactionId = json['revertedTransactionId'];
    }
    isReverted = json['isReverted'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['mode'] = this.mode;
    data['walletId'] = this.walletId;
    data['description'] = this.description;
    if (this.operation != null) {
      data['operation'] = this.operation.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    data['referenceTransactionId'] = this.referenceTransactionId;
    data['revertedTransactionId'] = this.revertedTransactionId;
    data['isReverted'] = this.isReverted;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Amount {
  var value;
  String type;
  String currency;

  Amount({this.value, this.type, this.currency});
  bool isBonuseType(){
    bool is_bonuse_type =false;
    Utils().customPrint(this.type);
    if(this.type=="bonus"){
      is_bonuse_type=true;
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

class Operation {
  String referenceId;
  String type;

  Operation({this.referenceId, this.type});

  Operation.fromJson(Map<String, dynamic> json) {
    referenceId = json['referenceId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referenceId'] = this.referenceId;
    data['type'] = this.type;
    return data;
  }
}

class Payment {
  String id;
  String source;

  Payment({this.id, this.source});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source'] = this.source;
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
