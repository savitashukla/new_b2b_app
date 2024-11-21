class WithdrawalModelR {
  List<Data> data;
  Pagination pagination;
  List<Data> bank_array;
  List<Data> upi_array;

  WithdrawalModelR({this.data, this.pagination});

  WithdrawalModelR.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      bank_array = new List<Data>();
      upi_array = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
        if (v['type'].compareTo("bank") == 0) {
          bank_array.add(new Data.fromJson(v));
        } else if (v['type'].compareTo("upi") == 0) {
          upi_array.add(new Data.fromJson(v));
        }
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
  Data1 data;
  PennyDropCheckStatus pennyDropCheckStatus;
  String type;
  String sId;

  Data({this.data, this.type, this.sId, this.pennyDropCheckStatus});

  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data1.fromJson(json['data']) : null;
    type = json['type'];
    sId = json['_id'];
    pennyDropCheckStatus = json['pennyDropCheckStatus'] != null
        ? new PennyDropCheckStatus.fromJson(json['pennyDropCheckStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['type'] = this.type;
    data['_id'] = this.sId;
    data['pennyDropCheckStatus'] = this.pennyDropCheckStatus;
    return data;
  }
}

class PennyDropCheckStatus {
  String status;
  bool sttusCheck = false;
  String reason;
  var nameAtBank;
  String date;

  PennyDropCheckStatus(
      {this.status,
      this.reason,
      this.nameAtBank,
      this.date});



  PennyDropCheckStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (status.compareTo("notPerformed") == 0) {
      print("penny drop notPerformed ");
      sttusCheck = true;
    } else if (status.compareTo("success") == 0) {
      print("penny drop success ");
      sttusCheck = true;
    } else {
      print("penny drop failure");
      sttusCheck = false;
    }

    reason = json['reason'];
    nameAtBank = json['nameAtBank'] ?? "";
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['reason'] = this.reason;
    data['nameAtBank'] = this.nameAtBank;
    data['date'] = this.date;
    return data;
  }
}

class Data1 {
  Bank bank;
  String razorpayFundAccountId;
  bool isVerified;
  Upi upi;

  Data1({this.bank, this.razorpayFundAccountId, this.isVerified, this.upi});

  Data1.fromJson(Map<String, dynamic> json) {
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
    razorpayFundAccountId = json['razorpayFundAccountId'];
    isVerified = json['isVerified'];
    upi = json['upi'] != null ? new Upi.fromJson(json['upi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bank != null) {
      data['bank'] = this.bank.toJson();
    }
    data['razorpayFundAccountId'] = this.razorpayFundAccountId;
    data['isVerified'] = this.isVerified;
    if (this.upi != null) {
      data['upi'] = this.upi.toJson();
    }
    return data;
  }
}

class Bank {
  String accountNo;
  String ifscCode;
  String name;

  Bank({this.accountNo, this.ifscCode, this.name});

  Bank.fromJson(Map<String, dynamic> json) {
    accountNo = json['accountNo'];
    ifscCode = json['ifscCode'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountNo'] = this.accountNo;
    data['ifscCode'] = this.ifscCode;
    data['name'] = this.name;
    return data;
  }
}

class Upi {
  String link;

  Upi({this.link});

  Upi.fromJson(Map<String, dynamic> json) {
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
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
