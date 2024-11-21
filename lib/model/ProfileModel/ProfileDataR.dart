import 'package:gmng/model/AppSettingResponse.dart';
import 'package:gmng/utills/Utils.dart';

import '../basemodel/AppBaseModel.dart';

class ProfileDataR {
  String id;

  //Null referralBonus;
  String username;
  Mobile mobile;
  List<Referral> referral;
  ReferredBy referredBy;
  Name name;
  Email email;
  String discordId;
  String about;
  Photo photo;
  Device device;
  RegisteredThrough registeredThrough;
  Settings settings;
  String role;
  Kyc kyc;
  String status;
  String razorpayContactId;
  List<WithdrawMethod> withdrawMethod;
  String serverTime = '';
  String gupshupOptInId = '';
  Level level; //VIP Module
  Stats stats;
  List<DepositMethods> depositMethods;
  var bureauSecurityData;

  ProfileDataR(
      {this.id,
      // this.referralBonus,
      this.username,
      this.mobile,
      this.referral,
      this.referredBy,
      this.name,
      this.email,
      this.discordId,
      this.about,
      this.photo,
      this.device,
      this.settings,
      this.registeredThrough,
      this.role,
      this.kyc,
      this.status,
      this.razorpayContactId,
      this.withdrawMethod,
      this.stats,
      this.depositMethods});

  ProfileDataR.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // referralBonus = json['referralBonus'];
    username = json['username'];
    mobile =
        json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
    if (json['referral'] != null) {
      referral = new List<Referral>();
      json['referral'].forEach((v) {
        referral.add(new Referral.fromJson(v));
      });
    }
    // referredBy = json['referredBy'];
    referredBy = json['referredBy'] != null
        ? new ReferredBy.fromJson(json['referredBy'])
        : null;

    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    if (json['email'] != null) {
      email = json['email'] != null ? new Email.fromJson(json['email']) : null;
    }

    discordId = json['discordId'];
    about = json['about'];
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
    device =
        json['device'] != null ? new Device.fromJson(json['device']) : null;

    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    registeredThrough = json['registeredThrough'] != null
        ? new RegisteredThrough.fromJson(json['registeredThrough'])
        : null;
    role = json['role'];
    kyc = json['kyc'] != null ? new Kyc.fromJson(json['kyc']) : null;
    status = json['status'];
    razorpayContactId = json['razorpayContactId'];
    if (json['withdrawMethod'] != null) {
      withdrawMethod = new List<WithdrawMethod>();
      json['withdrawMethod'].forEach((v) {
        withdrawMethod.add(new WithdrawMethod.fromJson(v));
      });
    }
    serverTime = json['meta']['serverTime'];

    gupshupOptInId =
        json['gupshupOptInId'] != null && json['gupshupOptInId'] != ''
            ? json['gupshupOptInId']
            : '';

    level = json['level'] != null ? new Level.fromJson(json['level']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    if (json['depositMethods'] != null) {
      depositMethods = <DepositMethods>[];
      json['depositMethods'].forEach((v) {
        depositMethods.add(new DepositMethods.fromJson(v));
      });
    }

    //bureauSecurityData
    bureauSecurityData =
        json['bureauSecurityData'] != null ? json['bureauSecurityData'] : [];
  }

  bool isPennyDropFaild() {
    bool is_varifiedP = null;
    if (withdrawMethod != null) {
      int countNotP = 0;
      if (withdrawMethod.length > 0) {
        for (int index = 0; index < withdrawMethod.length; index++) {
          print("call drop le${withdrawMethod.length}");
          if (withdrawMethod[index].pennyDropCheckStatus != null) {
            if (withdrawMethod[index]
                    .pennyDropCheckStatus
                    .status
                    .compareTo("success") ==
                0) {
              is_varifiedP = false;
              return false;
            } else if (withdrawMethod[index]
                    .pennyDropCheckStatus
                    .status
                    .compareTo("failure") ==
                0) {
              countNotP = countNotP + 1;
              if (countNotP == withdrawMethod.length) {
                is_varifiedP = true;
                return is_varifiedP;
              }
            } else {
              is_varifiedP = null;
            }
          }
        }
      }
    }

    return is_varifiedP;
  }

  bool isPennyDropnotPerformed() {
    bool is_varifiedP = false;
    if (withdrawMethod != null) {
      if (withdrawMethod.length > 0) {
        int countNotP = 0;

        for (int index = 0; index < withdrawMethod.length; index++) {
          if (withdrawMethod[index].pennyDropCheckStatus != null) {
            if (withdrawMethod[index]
                    .pennyDropCheckStatus
                    .status
                    .compareTo("notPerformed") ==
                0) {
              countNotP = countNotP + 1;
              if (countNotP == withdrawMethod.length) {
                is_varifiedP = true;
                return is_varifiedP;
              } else {
                is_varifiedP = false;
              }
            }
          }
        }
      }
    }

    return is_varifiedP;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    // data['referralBonus'] = this.referralBonus;
    data['username'] = this.username;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }
    if (this.referral != null) {
      data['referral'] = this.referral.map((v) => v.toJson()).toList();
    }

    //data['referredBy'] = this.referredBy;

    if (this.referredBy != null) {
      data['referredBy'] = this.referredBy.toJson();
    }
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['email'] = this.email;
    data['discordId'] = this.discordId;
    data['about'] = this.about;
    data['photo'] = this.photo;
    if (this.device != null) {
      data['device'] = this.device.toJson();
    }

    if (this.registeredThrough != null) {
      data['registeredThrough'] = this.registeredThrough.toJson();
    }
    data['role'] = this.role;
    if (this.kyc != null) {
      data['kyc'] = this.kyc.toJson();
    }
    data['status'] = this.status;
    data['razorpayContactId'] = this.razorpayContactId;
    if (this.withdrawMethod != null) {
      data['withdrawMethod'] =
          this.withdrawMethod.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mobile {
  int countryCode;
  int number;
  bool isVerified;

  Mobile({this.countryCode, this.number, this.isVerified});

  Mobile.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    number = json['number'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['number'] = this.number;
    data['isVerified'] = this.isVerified;
    return data;
  }

  String getFullNumber() {
    return "+" + this.countryCode.toString() + "-" + this.number.toString();
  }
}

class Referral {
  String code;
  bool isActive;

  Referral({this.code, this.isActive});

  Referral.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['isActive'] = this.isActive;
    return data;
  }
}

class ReferredBy {
  String code;
  String userId;

  ReferredBy({this.code, this.userId});

  ReferredBy.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['userId'] = this.userId;
    return data;
  }
}

class Name extends AppBaseModel {
  String first;
  String last;

  String getFullname() {
    return getValidString(this.first) + " " + getValidString(this.last);
  }

  Name({this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}

class Photo {
  String id;
  String url;

  Photo({this.id, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class Device {
  String fcmId;
  String info;
  String type;
  String version;

  Device({this.fcmId, this.info, this.type, this.version});

  Device.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcmId'];
    info = json['info'];
    type = json['type'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcmId'] = this.fcmId;
    data['info'] = this.info;
    data['type'] = this.type;
    data['version'] = this.version;
    return data;
  }
}

class RegisteredThrough {
  String appVersion;
  String appType;

  RegisteredThrough({this.appVersion, this.appType});

  RegisteredThrough.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
    appType = json['appType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appVersion'] = this.appVersion;
    data['appType'] = this.appType;
    return data;
  }
}

class Email {
  String address;

  Email({this.address});

  Email.fromJson(Map<String, dynamic> json) {
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    return data;
  }
}

class Kyc {
  List<Documents> documents;
  String govStatus;
  bool verified;
  String message = "";
  String statusPending = "";

  bool isApporved() {
    bool is_varified = false;

    if (this.verified) {
      // is_varified = true;
      if (this.documents != null && this.documents.length > 0) {
        for (int i = 0; i < this.documents.length; i++) {
          try {
            print("document${this.documents[i].type}");
            if (this.documents[i].type == "pan") {
              is_varified = true;
              break;
              /* if (this.documents[i].status == "accepted") {
                is_varified = true;
                statusPending = "";
                break;
              } else if (this.documents[i].status == "pending") {
                statusPending = "pending";
              } else {
                statusPending = "";
              }*/
            }
          } catch (E) {}
        }
      }
    }

    return is_varified;
  }

  bool isrejected() {
    bool is_varified = false;
    if (this.verified != null && this.verified) {
      is_varified = false;

      return is_varified;
    } else {
      if (this.documents != null && this.documents.length > 0) {
        for (int i = 0; i < this.documents.length; i++) {
          try {
            if (this.documents[i].type == "pan") {
              if (this.documents[i].status == "rejected") {
                is_varified = true;
              }
            }
          } catch (E) {
            return is_varified;
          }
          message = this.documents[i].message;
        }
      }
      return is_varified;
    }
  }

  Kyc({this.documents, this.govStatus, this.verified});

  Kyc.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = new List<Documents>();
      json['documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
    govStatus = json['govStatus'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    data['govStatus'] = this.govStatus;
    data['verified'] = this.verified;
    return data;
  }
}

class Documents {
  Storage storage;
  String type;
  String subType;
  String status;
  String sId;
  String message;

  Documents(
      {this.storage,
      this.type,
      this.subType,
      this.status,
      this.sId,
      this.message});

  Documents.fromJson(Map<String, dynamic> json) {
    storage =
        json['storage'] != null ? new Storage.fromJson(json['storage']) : null;
    type = json['type'];
    subType = json['subType'];
    status = json['status'];
    sId = json['_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storage != null) {
      data['storage'] = this.storage.toJson();
    }
    data['type'] = this.type;
    data['subType'] = this.subType;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['message'] = this.message;

    return data;
  }
}

class Storage {
  String id;
  String url;

  Storage({this.id, this.url});

  Storage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class WithdrawMethod {
  Data data;
  String type;
  String sId;
  PennyDropCheckStatus pennyDropCheckStatus;

  WithdrawMethod({this.data, this.type, this.sId, this.pennyDropCheckStatus});

  WithdrawMethod.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    pennyDropCheckStatus = json['pennyDropCheckStatus'] != null
        ? new PennyDropCheckStatus.fromJson(json['pennyDropCheckStatus'])
        : null;
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.pennyDropCheckStatus != null) {
      data['pennyDropCheckStatus'] = this.pennyDropCheckStatus.toJson();
    }
    data['type'] = this.type;
    data['_id'] = this.sId;
    return data;
  }
}

class PennyDropCheckStatus {
  String status;
  String reason;
  String nameAtBank;

  PennyDropCheckStatus({this.status, this.reason, this.nameAtBank});

  PennyDropCheckStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    reason = json['reason'] ?? null;
    nameAtBank = json['nameAtBank'] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status;
    } else {
      data['status'] = "";
    }

    if (this.status != null) {
      data['nameAtBank'] = this.nameAtBank;
    } else {
      data['nameAtBank'] = "";
    }

    if (this.reason != null) {
      data['reason'] = this.reason;
    } else {
      data['reason'] = null;
    }

    return data;
  }
}

class Data {
  Bank bank;
  String razorpayFundAccountId;
  bool isVerified;
  Upi upi;

  Data({this.bank, this.razorpayFundAccountId, this.isVerified, this.upi});

  Data.fromJson(Map<String, dynamic> json) {
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

class Settings {
  WithdrawRequest withdrawRequest;
  int maxPerDayJoinEvents;
  List<FeaturesStatus> featuresStatus;

  Settings({this.withdrawRequest, this.maxPerDayJoinEvents});

  Settings.fromJson(Map<String, dynamic> json) {
    withdrawRequest = json['withdrawRequest'] != null
        ? new WithdrawRequest.fromJson(json['withdrawRequest'])
        : null;
    maxPerDayJoinEvents = json['maxPerDayJoinEvents'];

    if (json['featuresStatus'] != null) {
      featuresStatus = <FeaturesStatus>[];
      json['featuresStatus'].forEach((v) {
        featuresStatus.add(new FeaturesStatus.fromJson(v));
      });
    }
  }
}

class WithdrawRequest {
  TransactionFee transactionFee;
  var maxAmount;
  var minAmount;
  var noOfTransactionsPerDay;
  var maxLimit;

  WithdrawRequest(
      {this.transactionFee,
      this.maxAmount,
      this.minAmount,
      this.noOfTransactionsPerDay,
      this.maxLimit});

  WithdrawRequest.fromJson(Map<String, dynamic> json) {
    transactionFee = json['transactionFee'] != null
        ? new TransactionFee.fromJson(json['transactionFee'])
        : null;
    maxAmount = json['maxAmount'];
    minAmount = json['minAmount'];
    maxLimit = json['maxLimit'] ?? null;
    noOfTransactionsPerDay = json['noOfTransactionsPerDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactionFee != null) {
      data['transactionFee'] = this.transactionFee.toJson();
    }
    data['maxAmount'] = this.maxAmount;
    data['minAmount'] = this.minAmount;
    data['maxLimit'] = this.maxLimit ?? null;
    data['noOfTransactionsPerDay'] = this.noOfTransactionsPerDay;
    return data;
  }
}

class TransactionFee {
  String type;
  var value;

  TransactionFee({this.type, this.value});

  String getTransacionFee() {
    if (this.type == "percent") {
      return '${this.value}%';
    } else {
      return '\u{20B9} ${this.value}';
    }
  }

  TransactionFee.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    // value = json['value'];

    try {
      var value1 = json['value'];
      value = value1 ~/ 1;
    } catch (E) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class Level {
  String id;
  int value;

  Level({this.id, this.value});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }
}

class Stats {
  StatsSubClass totalWin;
  StatsSubClass totalLoss;
  StatsSubClass rummyWin;
  StatsSubClass rummyLoss;
  StatsSubClass pokerWin;
  StatsSubClass pokerLoss;
  StatsSubClass pokerIn;
  StatsSubClass pokerOut;
  StatsSubClass instantCash;
  StatsSubClass depositFromBank;
  StatsSubClass withdrawalToBank;
  StatsSubClass taxableWithdrawalToBank;

  Stats(
      {this.totalWin,
      this.totalLoss,
      this.rummyWin,
      this.rummyLoss,
      this.pokerWin,
      this.pokerLoss,
      this.pokerIn,
      this.pokerOut,
      this.instantCash,
      this.depositFromBank,
      this.withdrawalToBank,
      this.taxableWithdrawalToBank});

  Stats.fromJson(Map<String, dynamic> json) {
    totalWin = json['total_win'] != null
        ? StatsSubClass.fromJson(json['total_win'])
        : null;
    totalLoss = json['total_loss'] != null
        ? StatsSubClass.fromJson(json['total_loss'])
        : null;
    rummyWin = json['rummy_win'] != null
        ? StatsSubClass.fromJson(json['rummy_win'])
        : null;
    rummyLoss = json['rummy_loss'] != null
        ? StatsSubClass.fromJson(json['rummy_loss'])
        : null;
    pokerWin = json['poker_win'] != null
        ? StatsSubClass.fromJson(json['poker_win'])
        : null;
    pokerLoss = json['poker_loss'] != null
        ? StatsSubClass.fromJson(json['poker_loss'])
        : null;
    pokerIn = json['poker_in'] != null
        ? StatsSubClass.fromJson(json['poker_in'])
        : null;
    pokerOut = json['poker_out'] != null
        ? StatsSubClass.fromJson(json['poker_out'])
        : null;
    instantCash = json['instant_cash'] != null
        ? StatsSubClass.fromJson(json['instant_cash'])
        : null;
    depositFromBank = json['deposit_from_bank'] != null
        ? StatsSubClass.fromJson(json['deposit_from_bank'])
        : null;
    withdrawalToBank = json['withdrawal_to_bank'] != null
        ? StatsSubClass.fromJson(json['withdrawal_to_bank'])
        : null;
    taxableWithdrawalToBank = json['taxable_withdrawal_to_bank'] != null
        ? StatsSubClass.fromJson(json['taxable_withdrawal_to_bank'])
        : null;
  }
}

class StatsSubClass {
  var value;
  String type;
  String currency;

  StatsSubClass({this.value, this.type, this.currency});

  StatsSubClass.fromJson(Map<String, dynamic> json) {
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

class DepositMethods {
  DataDeposit data;
  String type;
  String sId;
  bool isSelected;

  DepositMethods({this.data, this.type, this.sId});

  DepositMethods.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataDeposit.fromJson(json['data']) : null;
    type = json['type'];
    sId = json['_id'];
    //isSelected = false;
  }
}

class DataDeposit {
  Upi upi;

  DataDeposit({this.upi});

  DataDeposit.fromJson(Map<String, dynamic> json) {
    upi = json['upi'] != null ? new Upi.fromJson(json['upi']) : null;
  }
}
