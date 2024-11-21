class AppSettingResponse {
  Support support;
  Deposit deposit;
  WithdrawRequest withdrawRequest;
  List<NewUserFlow> newUserFlow;
  List<FeaturesStatus> featuresStatus;
  InstantCash instantCash;
  SignupCreditPolicy signupCreditPolicy;

  AppSettingResponse(
      {this.support,
        this.deposit,
      this.withdrawRequest,
      this.featuresStatus,
      this.signupCreditPolicy});

  AppSettingResponse.fromJson(Map<String, dynamic> json) {
    support =
        json['support'] != null ? new Support.fromJson(json['support']) : null;



    deposit =
    json['deposit'] != null ? new Deposit.fromJson(json['deposit']) : null;
    withdrawRequest = json['withdrawRequest'] != null
        ? new WithdrawRequest.fromJson(json['withdrawRequest'])
        : null;

    if (json['newUserFlow'] != null) {
      newUserFlow = new List<NewUserFlow>();
      json['newUserFlow'].forEach((v) {
        newUserFlow.add(new NewUserFlow.fromJson(v));
      });
    }
    if (json['featuresStatus'] != null) {
      featuresStatus = new List<FeaturesStatus>();
      json['featuresStatus'].forEach((v) {
        featuresStatus.add(new FeaturesStatus.fromJson(v));
      });
    }
    if (json['instantCash'] != null) {
      instantCash = json['instantCash'] != null
          ? new InstantCash.fromJson(json['instantCash'])
          : null;
    }
    if (json['signupCreditPolicy'] != null) {
      signupCreditPolicy = json['signupCreditPolicy'] != null
          ? new SignupCreditPolicy.fromJson(json['signupCreditPolicy'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.support != null) {
      data['support'] = this.support.toJson();
    }




    if (this.deposit != null) {
      data['deposit'] = this.deposit.toJson();
    }
    if (this.withdrawRequest != null) {
      data['withdrawRequest'] = this.withdrawRequest.toJson();
    }
    if (this.featuresStatus != null) {
      data['featuresStatus'] =
          this.featuresStatus.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deposit {
  var  minAmount;


  Deposit({var minAmount}) {
    this.minAmount = minAmount;
  }

  Deposit.fromJson(Map<String, dynamic> json) {
    minAmount = json['minAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minAmount'] = this.minAmount;

    return data;
  }
}



class Support {
  String email;
  int mobile;

  Support({String email, int mobile}) {
    this.email = email;
    this.mobile = mobile;
  }

  Support.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}

class WithdrawRequest {
  int maxAmount;
  int minAmount;
  int noOfTransactionsPerDay;
  TransactionFee transactionFee;

  num getMinimumAmountValue() {
    return this.minAmount ~/ 100;
  }

  WithdrawRequest(
      {int maxAmount,
      int minAmount,
      int noOfTransactionsPerDay,
      TransactionFee transactionFee}) {
    this.maxAmount = maxAmount;
    this.minAmount = minAmount;
    this.noOfTransactionsPerDay = noOfTransactionsPerDay;
    this.transactionFee = transactionFee;
  }

  WithdrawRequest.fromJson(Map<String, dynamic> json) {
    maxAmount = json['maxAmount'];
    minAmount = json['minAmount'];
    noOfTransactionsPerDay = json['noOfTransactionsPerDay'];
    transactionFee = json['transactionFee'] != null
        ? new TransactionFee.fromJson(json['transactionFee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxAmount'] = this.maxAmount;
    data['minAmount'] = this.minAmount;
    data['noOfTransactionsPerDay'] = this.noOfTransactionsPerDay;
    if (this.transactionFee != null) {
      data['transactionFee'] = this.transactionFee.toJson();
    }
    return data;
  }
}

class TransactionFee {
  String type;
  int value;

  String getTransacionFee() {
    if (this.type == "percent") {
      return '${this.value}%';
    } else {
      return '\u{20B9} ${this.value}';
    }
  }

  TransactionFee({String type, int value}) {
    this.type = type;
    this.value = value;
  }

  TransactionFee.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class NewUserFlow {
  String gameId;
  String eventIds;
  String name;
  String img;

  NewUserFlow({this.gameId});

  NewUserFlow.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId']['id'];
    name = json['gameId']['name'];
    img = json['gameId']['banner']['url'];
    try {
      eventIds = json['eventIds'][0]; //we only need for for now
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['eventIds'] = this.eventIds;
    return data;
  }
}

class FeaturesStatus {
  String id;
  String status;

  FeaturesStatus({this.id, this.status});

  FeaturesStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}

class InstantCash {
  double unlockLimit;
  String featureDescription;

  InstantCash({double unlockLimit, String featureDescription}) {
    this.unlockLimit = unlockLimit;
    this.featureDescription = featureDescription;
  }

  InstantCash.fromJson(Map<String, dynamic> json) {
    if (json['unlockLimit'] != null) unlockLimit = json['unlockLimit'] / 100;
    featureDescription = json['featureDescription'];
  }
}

class SignupCreditPolicy {
  String defaultReferCode;
  User user;
  User referrer;
  User clanManager;
  int referrerBonusMaxLimit;
  ReferrerDepositBenefit referrerDepositBenefit;

  SignupCreditPolicy(
      {this.defaultReferCode, this.user, this.referrer, this.clanManager});

  SignupCreditPolicy.fromJson(Map<String, dynamic> json) {
    defaultReferCode = json['defaultReferCode'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    referrer =
        json['referrer'] != null ? new User.fromJson(json['referrer']) : null;
    clanManager = json['clanManager'] != null
        ? new User.fromJson(json['clanManager'])
        : null;
    referrerBonusMaxLimit = json['referrerBonusMaxLimit'];
    referrerDepositBenefit = json['referrerDepositBenefit'] != null
        ? new ReferrerDepositBenefit.fromJson(json['referrerDepositBenefit'])
        : null;
  }
}

class User {
  int value;
  String type;
  String currency;

  User({this.value, this.type, this.currency});

  User.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
    currency = json['currency'];
  }
}

class ReferrerDepositBenefit {
  User minDeposit;
  User benefitAmount;
  int numberOfCreditsPerReferral;

  ReferrerDepositBenefit(
      {this.minDeposit, this.benefitAmount, this.numberOfCreditsPerReferral});

  ReferrerDepositBenefit.fromJson(Map<String, dynamic> json) {
    minDeposit = json['minDeposit'] != null
        ? new User.fromJson(json['minDeposit'])
        : null;
    benefitAmount = json['benefitAmount'] != null
        ? new User.fromJson(json['benefitAmount'])
        : null;
    numberOfCreditsPerReferral = json['numberOfCreditsPerReferral'];
  }
}
