import 'package:gmng/utills/Utils.dart';

class WalletModelR {
  List<WalletModel> data;

  WalletModelR({this.data});

  WalletModelR.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WalletModel>[];
      json['data'].forEach((v) {
        data.add(new WalletModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  WalletModelR.fromJsonPromo(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WalletModel>[];
      json['data'].forEach((v) {
        if (v['visibleOnApp'] == true)
          data.add(new WalletModel.fromJsonPromoCode(v));
      });
    }
  }

  WalletModelR.fromJsonPromoFull(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WalletModel>[];
      json['data'].forEach((v) {
        data.add(new WalletModel.fromJsonPromoCode(v));
      });
    }
  }
  WalletModelR.fromJsonPromoBanner(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WalletModel>[];
      json['data'].forEach((v) {
        if (v['banner'] != null && v['banner']['url'] != null) {
          //if (v['vipLevelIds'] != null && v['vipLevelIds'].contains(vipID)) {
          data.add(new WalletModel.fromJsonPromoCode(v));
          //}
        }
      });
    }
  }
}

class WalletModel {
  String id;
  String userId;
  String type;
  double balance;
  String currency;
  bool isSystemWallet;
  String createdAt;
  String updatedAt;
  String name;
  String code;
  String description;
  List<Benefit> benefit;
  String fromValue;
  String toValue;
  String perUser;
  String dateFrom;
  String dateTo;
  var visibleOnApp;
  var usesCount;
  var total;
  var vipLevelIds;
  String banner;
  bool isVIP;
  String needDepositAmtForNextVipLevel;
  var ftd;
  int vipLevel; //user define

  WalletModel(
      {this.id,
      this.userId,
      this.type,
      this.balance,
      this.currency,
      this.isSystemWallet,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.code,
      this.description,
      this.usesCount});

  WalletModel.fromJsonPromoCode(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    visibleOnApp = json['visibleOnApp'];
    usesCount = json['usesCount'];
    vipLevelIds = json['vipLevelIds'];
    isVIP = false;
    needDepositAmtForNextVipLevel = '';
    ftd = json['ftd'];
    vipLevel = -1;

    if (json['benefits'] != null) {
      benefit = <Benefit>[];
      json['benefits'].forEach((v) {
        benefit.add(new Benefit.fromJson(v));
      });
    }
    try {
      if (json['deposit']['from']['value'] != null) {
        fromValue =
            ((json['deposit']['from']['value'] / 100).round()).toString();
      }
      if (json['deposit']['to']['value'] != null) {
        toValue = ((json['deposit']['to']['value'] / 100).round()).toString();
      }
      if (json['limits']['perUser'] != null) {
        perUser = json['limits']['perUser'].toString();
      }
      if (json['limits']['total'] != null) {
        total = json['limits']['total'];
      }
      if (json['activationCriteria']['dateFrom'] != null) {
        dateFrom = json['activationCriteria']['dateFrom'].toString();
      }
      if (json['activationCriteria']['dateTo'] != null) {
        dateTo = json['activationCriteria']['dateTo'].toString();
      }
      if (json['banner']['url'] != null) {
        banner = json['banner']['url'].toString();
      }
    } catch (e) {}
  }

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    balance = double.parse(json['balance'].toString());
    currency = json['currency'];
    isSystemWallet = json['isSystemWallet'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['balance'] = this.balance;
    data['currency'] = this.currency;
    data['isSystemWallet'] = this.isSystemWallet;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  double getWalletBalance() {
    double bal = (this.balance ~/ 100) as double;
    return bal;
  }
}

class Benefit {
  String type;

  Benefit({this.type});

  List<WalletPromo> wallet;

  Benefit.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    //print('response promo code ${json['wallet']}');
    try {
      if (json['wallet'] != null) {
        wallet = <WalletPromo>[];
        json['wallet'].forEach((v) {
          wallet.add(new WalletPromo.fromJson(v));
        });
      }
    } catch (e) {
      Utils().customPrint('response promo code catch $e}');
    }
  }
}

class WalletPromo {
  String type;
  String percentage;
  String maximumAmount;

  WalletPromo({this.type, this.percentage, this.maximumAmount});

  WalletPromo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    percentage =
        json['percentage'] != null ? json['percentage'].toString() : '0';
    maximumAmount =
        json['maximumAmount'] != null ? json['maximumAmount'].toString() : '0';
  }
}
