import 'package:gmng/model/cashfree/PaymentIcons.dart';

class CashFreeModel {
  Data data;

  CashFreeModel({this.data});

  CashFreeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<PaymentMethods> paymentMethods;
  RazorpayMethods razorpayMethods;
  RazorpayMethods cashfreeMethods;
  PaymentIcons paymentIcons;

  Data(
      {this.paymentMethods,
      this.razorpayMethods,
      this.cashfreeMethods,
      this.paymentIcons});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['paymentMethods'] != null) {
      paymentMethods = new List<PaymentMethods>();
      json['paymentMethods'].forEach((v) {
        paymentMethods.add(new PaymentMethods.fromJson(v));
      });
    }
    razorpayMethods = json['razorpayMethods'] != null
        ? new RazorpayMethods.fromJson(json['razorpayMethods'])
        : null;
    cashfreeMethods = json['cashfreeMethods'] != null
        ? new RazorpayMethods.fromJson(json['cashfreeMethods'])
        : null;
    paymentIcons = json['paymentIcons'] != null
        ? new PaymentIcons.fromJson(json['paymentIcons'])
        : null;
  }
}

class PaymentMethods {
  String method;
  String source;
  int order;

  PaymentMethods({this.method, this.source, this.order});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    source = json['source'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['source'] = this.source;
    data['order'] = this.order;
    return data;
  }
}

class RazorpayMethods {
  Upi upi;
  Wallet wallet;
  Netbanking netbanking;
  Card card;

  RazorpayMethods({this.upi, this.wallet, this.netbanking, this.card});

  RazorpayMethods.fromJson(Map<String, dynamic> json) {
    upi = json['upi'] != null ? new Upi.fromJson(json['upi']) : null;
    wallet =
        json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    netbanking = json['netbanking'] != null
        ? new Netbanking.fromJson(json['netbanking'])
        : null;
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }
}

class Upi {
  bool enabled;
  bool intentFlow;
  String bhim;
  String googlePay;
  String paytm;
  String phonePe;

  Upi(
      {this.enabled,
      this.intentFlow,
      this.bhim,
      this.googlePay,
      this.paytm,
      this.phonePe});

  Upi.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    intentFlow = json['intentFlow'];
    bhim = json['Bhim'];
    googlePay = json['GooglePay'];
    paytm = json['Paytm'];
    phonePe = json['PhonePe'];
  }
}

class Wallet {
  bool enabled;
  Types types;
  String freeCharge;
  String mobiKwik;
  String olaMoney;
  String relianceJioMoney;
  String airtelMoney;
  String paytm;
  String amazonPay;
  String phonePe;
  String payZapp;

  Wallet(
      {this.enabled,
      this.types,
      this.freeCharge,
      this.mobiKwik,
      this.olaMoney,
      this.relianceJioMoney,
      this.airtelMoney,
      this.paytm,
      this.amazonPay,
      this.phonePe,
      this.payZapp});

  Wallet.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    types = json['types'] != null ? new Types.fromJson(json['types']) : null;
    freeCharge = json['FreeCharge'];
    mobiKwik = json['MobiKwik'];
    olaMoney = json['OlaMoney'];
    relianceJioMoney = json['RelianceJioMoney'];
    airtelMoney = json['AirtelMoney'];
    paytm = json['Paytm'];
    amazonPay = json['AmazonPay'];
    phonePe = json['PhonePe'];
    payZapp = json['PayZapp'];
  }
}

class Types {
  bool mobiKwik;
  bool olaMoney;
  bool relianceJioMoney;
  bool airtelMoney;
  bool phonePe;
  bool payZapp;
  bool debitCard;
  bool creditCard;
  bool prepaidCard;
  bool amexCard;
  bool googlePayCard;

  Types({
    this.mobiKwik,
    this.olaMoney,
    this.relianceJioMoney,
    this.airtelMoney,
    this.phonePe,
    this.payZapp,
    this.debitCard,
    this.creditCard,
    this.prepaidCard,
    this.amexCard,
    this.googlePayCard,
  });

  Types.fromJson(Map<String, dynamic> json) {
    mobiKwik = json['MobiKwik'];
    olaMoney = json['OlaMoney'];
    relianceJioMoney = json['RelianceJioMoney'];
    airtelMoney = json['AirtelMoney'];
    phonePe = json['PhonePe'];
    payZapp = json['PayZapp'];
    debitCard = json['debitCard'];
    creditCard = json['creditCard'];
    prepaidCard = json['prepaidCard'];
    amexCard = json['amexCard'];
    googlePayCard = json['googlePayCard'];
  }
}

class Banks {
  bool bankOfBarodaRetail;
  bool catholicSyrianBank;
  bool dCBBankPersonal;
  bool indianBank;
  bool saraswatBank;
  bool unionBankOfIndia;
  bool ujjivanSmallFinanceBank;
  bool unitedBankOfIndia;
  bool orientalBankOfCommerce;
  bool axisBank;
  bool bankOfIndia;
  bool bankOfMaharashtra;
  bool canaraBank;
  bool centralBankOfIndia;
  bool cityUnionBank;
  bool deutscheBank;
  bool dBSBank;
  bool dhanlakshmiBank;
  bool federalBank;
  bool hDFCBank;
  bool iCICIBank;
  bool iDBIBank;
  bool iDFCFIRSTBank;
  bool indianOverseasBank;
  bool indusIndBank;
  bool jammuAndKashmirBank;
  bool karnatakaBank;
  bool karurVysyaBank;
  bool kotakMahindraBank;
  bool laxmiVilasBankRetail;
  bool punjabSindBank;
  bool punjabNationalBankRetail;
  bool rBLBank;
  bool shamraoVitthalCoOpBank;
  bool southIndianBank;
  bool standardCharteredBank;
  bool stateBankOfIndia;
  bool tamilNaduStateCoOpBank;
  bool tamilnadMercantileBank;
  bool uCOBank;
  bool yesBank;
  bool bankOfBarodaCorporate;
  bool bankOfIndiaCorporate;
  bool dCBBankCorporate;
  bool lakshmiVilasBankCorporate;
  bool punjabNationalBankCorporate;
  bool stateBankOfIndiaCorporate;
  bool unionBankOfIndiaCorporate;
  bool axisBankCorporate;
  bool dhanlaxmiBankCorporate;
  bool iCICICorporate;
  bool ratnakarCorporate;
  bool shamraoVithalBankCorporate;
  bool equitasSmallFinanceBank;
  bool yesBankCorporate;
  bool bandhanBankCorporatebanking;
  bool barclaysCorporate;
  bool indianOverseasBankCorporate;
  bool cityUnionBankOfCorporate;
  bool hDFCCorporate;
  bool shivalikBank;
  bool aUSmallFinance;
  bool bandhanBankRetail;
  bool utkarshSmallFinanceBank;
  bool theSuratPeopleCoOpBank;
  bool gujaratStateCoOpBank;
  bool hSBCRetail;
  bool andhraPragathiGrameenaBank;
  bool bassienCatholicCoOpBank;
  bool capitalSmallFinanceBank;
  bool eSAFSmallFinanceBank;
  bool fincareBank;
  bool janaSmallFinanceBank;
  bool jioPaymentsBank;
  bool janataSahakariBankPune;
  bool kalyanJanataSahakariBank;
  bool theKalupurCommercialCoOpBank;
  bool karnatakaVikasGrameenaBank;
  bool maharashtraGraminBank;
  bool northEastSmallFinanceBank;
  bool nKGSBCoOpBank;
  bool karnatakaGraminBank;
  bool rBLBankLimitedCorporate;
  bool sBMBankIndia;
  bool suryodaySmallFinanceBank;
  bool theSutexCoOpBank;
  bool thaneBharatSahakariBank;
  bool tJSBBank;
  bool varachhaCoOpBank;
  bool zoroastrianCoOpBank;
  bool uCOBankCorporate;
  bool airtelPaymentsBank;

  Banks(
      {this.bankOfBarodaRetail,
      this.catholicSyrianBank,
      this.dCBBankPersonal,
      this.indianBank,
      this.saraswatBank,
      this.unionBankOfIndia,
      this.ujjivanSmallFinanceBank,
      this.unitedBankOfIndia,
      this.orientalBankOfCommerce,
      this.axisBank,
      this.bankOfIndia,
      this.bankOfMaharashtra,
      this.canaraBank,
      this.centralBankOfIndia,
      this.cityUnionBank,
      this.deutscheBank,
      this.dBSBank,
      this.dhanlakshmiBank,
      this.federalBank,
      this.hDFCBank,
      this.iCICIBank,
      this.iDBIBank,
      this.iDFCFIRSTBank,
      this.indianOverseasBank,
      this.indusIndBank,
      this.jammuAndKashmirBank,
      this.karnatakaBank,
      this.karurVysyaBank,
      this.kotakMahindraBank,
      this.laxmiVilasBankRetail,
      this.punjabSindBank,
      this.punjabNationalBankRetail,
      this.rBLBank,
      this.shamraoVitthalCoOpBank,
      this.southIndianBank,
      this.standardCharteredBank,
      this.stateBankOfIndia,
      this.tamilNaduStateCoOpBank,
      this.tamilnadMercantileBank,
      this.uCOBank,
      this.yesBank,
      this.bankOfBarodaCorporate,
      this.bankOfIndiaCorporate,
      this.dCBBankCorporate,
      this.lakshmiVilasBankCorporate,
      this.punjabNationalBankCorporate,
      this.stateBankOfIndiaCorporate,
      this.unionBankOfIndiaCorporate,
      this.axisBankCorporate,
      this.dhanlaxmiBankCorporate,
      this.iCICICorporate,
      this.ratnakarCorporate,
      this.shamraoVithalBankCorporate,
      this.equitasSmallFinanceBank,
      this.yesBankCorporate,
      this.bandhanBankCorporatebanking,
      this.barclaysCorporate,
      this.indianOverseasBankCorporate,
      this.cityUnionBankOfCorporate,
      this.hDFCCorporate,
      this.shivalikBank,
      this.aUSmallFinance,
      this.bandhanBankRetail,
      this.utkarshSmallFinanceBank,
      this.theSuratPeopleCoOpBank,
      this.gujaratStateCoOpBank,
      this.hSBCRetail,
      this.andhraPragathiGrameenaBank,
      this.bassienCatholicCoOpBank,
      this.capitalSmallFinanceBank,
      this.eSAFSmallFinanceBank,
      this.fincareBank,
      this.janaSmallFinanceBank,
      this.jioPaymentsBank,
      this.janataSahakariBankPune,
      this.kalyanJanataSahakariBank,
      this.theKalupurCommercialCoOpBank,
      this.karnatakaVikasGrameenaBank,
      this.maharashtraGraminBank,
      this.northEastSmallFinanceBank,
      this.nKGSBCoOpBank,
      this.karnatakaGraminBank,
      this.rBLBankLimitedCorporate,
      this.sBMBankIndia,
      this.suryodaySmallFinanceBank,
      this.theSutexCoOpBank,
      this.thaneBharatSahakariBank,
      this.tJSBBank,
      this.varachhaCoOpBank,
      this.zoroastrianCoOpBank,
      this.uCOBankCorporate,
      this.airtelPaymentsBank});

  Banks.fromJson(Map<String, dynamic> json) {
    bankOfBarodaRetail = json['BankOfBarodaRetail'];
    catholicSyrianBank = json['CatholicSyrianBank'];
    dCBBankPersonal = json['DCBBankPersonal'];
    indianBank = json['IndianBank'];
    saraswatBank = json['SaraswatBank'];
    unionBankOfIndia = json['UnionBankOfIndia'];
    ujjivanSmallFinanceBank = json['UjjivanSmallFinanceBank'];
    unitedBankOfIndia = json['UnitedBankOfIndia'];
    orientalBankOfCommerce = json['OrientalBankOfCommerce'];
    axisBank = json['AxisBank'];
    bankOfBarodaRetail = json['BankOfBarodaRetail'];
    bankOfIndia = json['BankOfIndia'];
    bankOfMaharashtra = json['BankOfMaharashtra'];
    canaraBank = json['CanaraBank'];
    catholicSyrianBank = json['CatholicSyrianBank'];
    centralBankOfIndia = json['CentralBankOfIndia'];
    cityUnionBank = json['CityUnionBank'];
    deutscheBank = json['DeutscheBank'];
    dBSBank = json['DBSBank'];
    dCBBankPersonal = json['DCBBankPersonal'];
    dhanlakshmiBank = json['DhanlakshmiBank'];
    federalBank = json['FederalBank'];
    hDFCBank = json['HDFCBank'];
    iCICIBank = json['ICICIBank'];
    iDBIBank = json['IDBIBank'];
    iDFCFIRSTBank = json['IDFCFIRSTBank'];
    indianBank = json['IndianBank'];
    indianOverseasBank = json['IndianOverseasBank'];
    indusIndBank = json['IndusIndBank'];
    jammuAndKashmirBank = json['JammuAndKashmirBank'];
    karnatakaBank = json['KarnatakaBank'];
    karurVysyaBank = json['KarurVysyaBank'];
    kotakMahindraBank = json['KotakMahindraBank'];
    laxmiVilasBankRetail = json['LaxmiVilasBankRetail'];
    punjabSindBank = json['PunjabSindBank'];
    punjabNationalBankRetail = json['PunjabNationalBankRetail'];
    rBLBank = json['RBLBank'];
    saraswatBank = json['SaraswatBank'];
    shamraoVitthalCoOpBank = json['ShamraoVitthalCoOpBank'];
    southIndianBank = json['SouthIndianBank'];
    standardCharteredBank = json['StandardCharteredBank'];
    stateBankOfIndia = json['StateBankOfIndia'];
    tamilNaduStateCoOpBank = json['TamilNaduStateCoOpBank'];
    tamilnadMercantileBank = json['TamilnadMercantileBank'];
    uCOBank = json['UCOBank'];
    unionBankOfIndia = json['UnionBankOfIndia'];
    yesBank = json['YesBank'];
    bankOfBarodaCorporate = json['BankOfBarodaCorporate'];
    bankOfIndiaCorporate = json['BankOfIndiaCorporate'];
    dCBBankCorporate = json['DCBBankCorporate'];
    lakshmiVilasBankCorporate = json['LakshmiVilasBankCorporate'];
    punjabNationalBankCorporate = json['PunjabNationalBankCorporate'];
    stateBankOfIndiaCorporate = json['StateBankOfIndiaCorporate'];
    unionBankOfIndiaCorporate = json['UnionBankOfIndiaCorporate'];
    axisBankCorporate = json['AxisBankCorporate'];
    dhanlaxmiBankCorporate = json['DhanlaxmiBankCorporate'];
    iCICICorporate = json['ICICICorporate'];
    ratnakarCorporate = json['RatnakarCorporate'];
    shamraoVithalBankCorporate = json['ShamraoVithalBankCorporate'];
    equitasSmallFinanceBank = json['EquitasSmallFinanceBank'];
    yesBankCorporate = json['YesBankCorporate'];
    bandhanBankCorporatebanking = json['BandhanBankCorporatebanking'];
    barclaysCorporate = json['BarclaysCorporate'];
    indianOverseasBankCorporate = json['IndianOverseasBankCorporate'];
    cityUnionBankOfCorporate = json['CityUnionBankOfCorporate'];
    hDFCCorporate = json['HDFCCorporate'];
    shivalikBank = json['ShivalikBank'];
    aUSmallFinance = json['AUSmallFinance'];
    bandhanBankRetail = json['BandhanBankRetail'];
    utkarshSmallFinanceBank = json['UtkarshSmallFinanceBank'];
    theSuratPeopleCoOpBank = json['TheSuratPeopleCoOpBank'];
    gujaratStateCoOpBank = json['GujaratStateCoOpBank'];
    hSBCRetail = json['HSBCRetail'];
    andhraPragathiGrameenaBank = json['AndhraPragathiGrameenaBank'];
    bassienCatholicCoOpBank = json['BassienCatholicCoOpBank'];
    capitalSmallFinanceBank = json['CapitalSmallFinanceBank'];
    eSAFSmallFinanceBank = json['ESAFSmallFinanceBank'];
    fincareBank = json['FincareBank'];
    janaSmallFinanceBank = json['JanaSmallFinanceBank'];
    jioPaymentsBank = json['JioPaymentsBank'];
    janataSahakariBankPune = json['JanataSahakariBankPune'];
    kalyanJanataSahakariBank = json['KalyanJanataSahakariBank'];
    theKalupurCommercialCoOpBank = json['TheKalupurCommercialCoOpBank'];
    karnatakaVikasGrameenaBank = json['KarnatakaVikasGrameenaBank'];
    maharashtraGraminBank = json['MaharashtraGraminBank'];
    northEastSmallFinanceBank = json['NorthEastSmallFinanceBank'];
    nKGSBCoOpBank = json['NKGSBCoOpBank'];
    karnatakaGraminBank = json['KarnatakaGraminBank'];
    rBLBankLimitedCorporate = json['RBLBankLimitedCorporate'];
    sBMBankIndia = json['SBMBankIndia'];
    suryodaySmallFinanceBank = json['SuryodaySmallFinanceBank'];
    theSutexCoOpBank = json['TheSutexCoOpBank'];
    thaneBharatSahakariBank = json['ThaneBharatSahakariBank'];
    tJSBBank = json['TJSBBank'];
    varachhaCoOpBank = json['VarachhaCoOpBank'];
    zoroastrianCoOpBank = json['ZoroastrianCoOpBank'];
    uCOBankCorporate = json['UCOBankCorporate'];
    airtelPaymentsBank = json['AirtelPaymentsBank'];
  }
}

class CardNetworks {
  bool mC;
  bool mAES;
  bool vISA;
  bool rUPAY;

  CardNetworks({this.mC, this.mAES, this.vISA, this.rUPAY});

  CardNetworks.fromJson(Map<String, dynamic> json) {
    mC = json['MC'];
    mAES = json['MAES'];
    vISA = json['VISA'];
    rUPAY = json['RUPAY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MC'] = this.mC;
    data['MAES'] = this.mAES;
    data['VISA'] = this.vISA;
    data['RUPAY'] = this.rUPAY;
    return data;
  }
}

class CardSubtype {
  bool consumer;
  bool business;
  bool premium;

  CardSubtype({this.consumer, this.business, this.premium});

  CardSubtype.fromJson(Map<String, dynamic> json) {
    consumer = json['consumer'];
    business = json['business'];
    premium = json['premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumer'] = this.consumer;
    data['business'] = this.business;
    data['premium'] = this.premium;
    return data;
  }
}

class Netbanking {
  String axisBank;
  String bankOfBarodaRetail;
  String bankOfIndia;
  String bankOfMaharashtra;
  String canaraBank;
  String catholicSyrianBank;
  String centralBankOfIndia;
  String cityUnionBank;
  String deutscheBank;
  String dBSBank;
  String dCBBankPersonal;
  String dhanlakshmiBank;
  String federalBank;
  String hDFCBank;
  String iCICIBank;
  String iDBIBank;
  String iDFCFIRSTBank;
  String indianBank;
  String indianOverseasBank;
  String indusIndBank;
  String jammuAndKashmirBank;
  String karnatakaBank;
  String karurVysyaBank;
  String kotakMahindraBank;
  String laxmiVilasBankRetail;
  String punjabSindBank;
  String punjabNationalBankRetail;
  String rBLBank;
  String saraswatBank;
  String shamraoVitthalCoOpBank;
  String southIndianBank;
  String standardCharteredBank;
  String stateBankOfIndia;
  String tamilNaduStateCoOpBank;
  String tamilnadMercantileBank;
  String uCOBank;
  String unionBankOfIndia;
  String yesBank;
  String bankOfBarodaCorporate;
  String bankOfIndiaCorporate;
  String dCBBankCorporate;
  String lakshmiVilasBankCorporate;
  String punjabNationalBankCorporate;
  String stateBankOfIndiaCorporate;
  String unionBankOfIndiaCorporate;
  String axisBankCorporate;
  String dhanlaxmiBankCorporate;
  String iCICICorporate;
  String ratnakarCorporate;
  String shamraoVithalBankCorporate;
  String equitasSmallFinanceBank;
  String yesBankCorporate;
  String bandhanBankCorporatebanking;
  String barclaysCorporate;
  String indianOverseasBankCorporate;
  String cityUnionBankOfCorporate;
  String hDFCCorporate;
  String shivalikBank;
  String aUSmallFinance;
  String bandhanBankRetail;
  String utkarshSmallFinanceBank;
  String theSuratPeopleCoOpBank;
  String gujaratStateCoOpBank;
  String hSBCRetail;
  String andhraPragathiGrameenaBank;
  String bassienCatholicCoOpBank;
  String capitalSmallFinanceBank;
  String eSAFSmallFinanceBank;
  String fincareBank;
  String janaSmallFinanceBank;
  String jioPaymentsBank;
  String janataSahakariBankPune;
  String kalyanJanataSahakariBank;
  String theKalupurCommercialCoOpBank;
  String karnatakaVikasGrameenaBank;
  String maharashtraGraminBank;
  String northEastSmallFinanceBank;
  String nKGSBCoOpBank;
  String karnatakaGraminBank;
  String rBLBankLimitedCorporate;
  String sBMBankIndia;
  String suryodaySmallFinanceBank;
  String theSutexCoOpBank;
  String thaneBharatSahakariBank;
  String tJSBBank;
  String varachhaCoOpBank;
  String zoroastrianCoOpBank;
  String uCOBankCorporate;
  String airtelPaymentsBank;
  String ujjivanSmallFinanceBank;
  String unitedBankOfIndia;
  String orientalBankOfCommerce;
  bool enabled;
  Banks banks;

  Netbanking(
      {this.axisBank,
      this.bankOfBarodaRetail,
      this.bankOfIndia,
      this.bankOfMaharashtra,
      this.canaraBank,
      this.catholicSyrianBank,
      this.centralBankOfIndia,
      this.cityUnionBank,
      this.deutscheBank,
      this.dBSBank,
      this.dCBBankPersonal,
      this.dhanlakshmiBank,
      this.federalBank,
      this.hDFCBank,
      this.iCICIBank,
      this.iDBIBank,
      this.iDFCFIRSTBank,
      this.indianBank,
      this.indianOverseasBank,
      this.indusIndBank,
      this.jammuAndKashmirBank,
      this.karnatakaBank,
      this.karurVysyaBank,
      this.kotakMahindraBank,
      this.laxmiVilasBankRetail,
      this.punjabSindBank,
      this.punjabNationalBankRetail,
      this.rBLBank,
      this.saraswatBank,
      this.shamraoVitthalCoOpBank,
      this.southIndianBank,
      this.standardCharteredBank,
      this.stateBankOfIndia,
      this.tamilNaduStateCoOpBank,
      this.tamilnadMercantileBank,
      this.uCOBank,
      this.unionBankOfIndia,
      this.yesBank,
      this.bankOfBarodaCorporate,
      this.bankOfIndiaCorporate,
      this.dCBBankCorporate,
      this.lakshmiVilasBankCorporate,
      this.punjabNationalBankCorporate,
      this.stateBankOfIndiaCorporate,
      this.unionBankOfIndiaCorporate,
      this.axisBankCorporate,
      this.dhanlaxmiBankCorporate,
      this.iCICICorporate,
      this.ratnakarCorporate,
      this.shamraoVithalBankCorporate,
      this.equitasSmallFinanceBank,
      this.yesBankCorporate,
      this.bandhanBankCorporatebanking,
      this.barclaysCorporate,
      this.indianOverseasBankCorporate,
      this.cityUnionBankOfCorporate,
      this.hDFCCorporate,
      this.shivalikBank,
      this.aUSmallFinance,
      this.bandhanBankRetail,
      this.utkarshSmallFinanceBank,
      this.theSuratPeopleCoOpBank,
      this.gujaratStateCoOpBank,
      this.hSBCRetail,
      this.andhraPragathiGrameenaBank,
      this.bassienCatholicCoOpBank,
      this.capitalSmallFinanceBank,
      this.eSAFSmallFinanceBank,
      this.fincareBank,
      this.janaSmallFinanceBank,
      this.jioPaymentsBank,
      this.janataSahakariBankPune,
      this.kalyanJanataSahakariBank,
      this.theKalupurCommercialCoOpBank,
      this.karnatakaVikasGrameenaBank,
      this.maharashtraGraminBank,
      this.northEastSmallFinanceBank,
      this.nKGSBCoOpBank,
      this.karnatakaGraminBank,
      this.rBLBankLimitedCorporate,
      this.sBMBankIndia,
      this.suryodaySmallFinanceBank,
      this.theSutexCoOpBank,
      this.thaneBharatSahakariBank,
      this.tJSBBank,
      this.varachhaCoOpBank,
      this.zoroastrianCoOpBank,
      this.uCOBankCorporate,
      this.airtelPaymentsBank,
      this.ujjivanSmallFinanceBank,
      this.unitedBankOfIndia,
      this.orientalBankOfCommerce,
      this.enabled,
      this.banks});

  Netbanking.fromJson(Map<String, dynamic> json) {
    axisBank = json['AxisBank'];
    enabled = json['enabled'];
    banks = json['banks'] != null ? new Banks.fromJson(json['banks']) : null;
    bankOfBarodaRetail = json['BankOfBarodaRetail'];
    bankOfIndia = json['BankOfIndia'];
    bankOfMaharashtra = json['BankOfMaharashtra'];
    canaraBank = json['CanaraBank'];
    catholicSyrianBank = json['CatholicSyrianBank'];
    centralBankOfIndia = json['CentralBankOfIndia'];
    cityUnionBank = json['CityUnionBank'];
    deutscheBank = json['DeutscheBank'];
    dBSBank = json['DBSBank'];
    dCBBankPersonal = json['DCBBankPersonal'];
    dhanlakshmiBank = json['DhanlakshmiBank'];
    federalBank = json['FederalBank'];
    hDFCBank = json['HDFCBank'];
    iCICIBank = json['ICICIBank'];
    iDBIBank = json['IDBIBank'];
    iDFCFIRSTBank = json['IDFCFIRSTBank'];
    indianBank = json['IndianBank'];
    indianOverseasBank = json['IndianOverseasBank'];
    indusIndBank = json['IndusIndBank'];
    jammuAndKashmirBank = json['JammuAndKashmirBank'];
    karnatakaBank = json['KarnatakaBank'];
    karurVysyaBank = json['KarurVysyaBank'];
    kotakMahindraBank = json['KotakMahindraBank'];
    laxmiVilasBankRetail = json['LaxmiVilasBankRetail'];
    punjabSindBank = json['PunjabSindBank'];
    punjabNationalBankRetail = json['PunjabNationalBankRetail'];
    rBLBank = json['RBLBank'];
    saraswatBank = json['SaraswatBank'];
    shamraoVitthalCoOpBank = json['ShamraoVitthalCoOpBank'];
    southIndianBank = json['SouthIndianBank'];
    standardCharteredBank = json['StandardCharteredBank'];
    stateBankOfIndia = json['StateBankOfIndia'];
    tamilNaduStateCoOpBank = json['TamilNaduStateCoOpBank'];
    tamilnadMercantileBank = json['TamilnadMercantileBank'];
    uCOBank = json['UCOBank'];
    unionBankOfIndia = json['UnionBankOfIndia'];
    yesBank = json['YesBank'];
    bankOfBarodaCorporate = json['BankOfBarodaCorporate'];
    bankOfIndiaCorporate = json['BankOfIndiaCorporate'];
    dCBBankCorporate = json['DCBBankCorporate'];
    lakshmiVilasBankCorporate = json['LakshmiVilasBankCorporate'];
    punjabNationalBankCorporate = json['PunjabNationalBankCorporate'];
    stateBankOfIndiaCorporate = json['StateBankOfIndiaCorporate'];
    unionBankOfIndiaCorporate = json['UnionBankOfIndiaCorporate'];
    axisBankCorporate = json['AxisBankCorporate'];
    dhanlaxmiBankCorporate = json['DhanlaxmiBankCorporate'];
    iCICICorporate = json['ICICICorporate'];
    ratnakarCorporate = json['RatnakarCorporate'];
    shamraoVithalBankCorporate = json['ShamraoVithalBankCorporate'];
    equitasSmallFinanceBank = json['EquitasSmallFinanceBank'];
    yesBankCorporate = json['YesBankCorporate'];
    bandhanBankCorporatebanking = json['BandhanBankCorporatebanking'];
    barclaysCorporate = json['BarclaysCorporate'];
    indianOverseasBankCorporate = json['IndianOverseasBankCorporate'];
    cityUnionBankOfCorporate = json['CityUnionBankOfCorporate'];
    hDFCCorporate = json['HDFCCorporate'];
    shivalikBank = json['ShivalikBank'];
    aUSmallFinance = json['AUSmallFinance'];
    bandhanBankRetail = json['BandhanBankRetail'];
    utkarshSmallFinanceBank = json['UtkarshSmallFinanceBank'];
    theSuratPeopleCoOpBank = json['TheSuratPeopleCoOpBank'];
    gujaratStateCoOpBank = json['GujaratStateCoOpBank'];
    hSBCRetail = json['HSBCRetail'];
    andhraPragathiGrameenaBank = json['AndhraPragathiGrameenaBank'];
    bassienCatholicCoOpBank = json['BassienCatholicCoOpBank'];
    capitalSmallFinanceBank = json['CapitalSmallFinanceBank'];
    eSAFSmallFinanceBank = json['ESAFSmallFinanceBank'];
    fincareBank = json['FincareBank'];
    janaSmallFinanceBank = json['JanaSmallFinanceBank'];
    jioPaymentsBank = json['JioPaymentsBank'];
    janataSahakariBankPune = json['JanataSahakariBankPune'];
    kalyanJanataSahakariBank = json['KalyanJanataSahakariBank'];
    theKalupurCommercialCoOpBank = json['TheKalupurCommercialCoOpBank'];
    karnatakaVikasGrameenaBank = json['KarnatakaVikasGrameenaBank'];
    maharashtraGraminBank = json['MaharashtraGraminBank'];
    northEastSmallFinanceBank = json['NorthEastSmallFinanceBank'];
    nKGSBCoOpBank = json['NKGSBCoOpBank'];
    karnatakaGraminBank = json['KarnatakaGraminBank'];
    rBLBankLimitedCorporate = json['RBLBankLimitedCorporate'];
    sBMBankIndia = json['SBMBankIndia'];
    suryodaySmallFinanceBank = json['SuryodaySmallFinanceBank'];
    theSutexCoOpBank = json['TheSutexCoOpBank'];
    thaneBharatSahakariBank = json['ThaneBharatSahakariBank'];
    tJSBBank = json['TJSBBank'];
    varachhaCoOpBank = json['VarachhaCoOpBank'];
    zoroastrianCoOpBank = json['ZoroastrianCoOpBank'];
    uCOBankCorporate = json['UCOBankCorporate'];
    airtelPaymentsBank = json['AirtelPaymentsBank'];
    ujjivanSmallFinanceBank = json['UjjivanSmallFinanceBank'];
    unitedBankOfIndia = json['UnitedBankOfIndia'];
    orientalBankOfCommerce = json['OrientalBankOfCommerce'];
  }
}

class Card {
  String aMEX;
  String dICL;
  String mC;
  String mAES;
  String vISA;
  String jCB;
  String rUPAY;
  String bAJAJ;
  bool enabled;
  Types types;
  CardNetworks cardNetworks;
  CardSubtype cardSubtype;

  Card(
      {this.aMEX,
      this.dICL,
      this.mC,
      this.mAES,
      this.vISA,
      this.jCB,
      this.rUPAY,
      this.bAJAJ,
      this.enabled,
      this.types,
      this.cardNetworks,
      this.cardSubtype});

  Card.fromJson(Map<String, dynamic> json) {
    aMEX = json['AMEX'];
    dICL = json['DICL'];
    mC = json['MC'];
    mAES = json['MAES'];
    vISA = json['VISA'];
    jCB = json['JCB'];
    rUPAY = json['RUPAY'];
    bAJAJ = json['BAJAJ'];
    enabled = json['enabled'];
    types = json['types'] != null ? new Types.fromJson(json['types']) : null;
    cardNetworks = json['cardNetworks'] != null
        ? new CardNetworks.fromJson(json['cardNetworks'])
        : null;
    cardSubtype = json['cardSubtype'] != null
        ? new CardSubtype.fromJson(json['cardSubtype'])
        : null;
  }
}

class NetBankingList {
  String name;
  String status;
  String icon;

  NetBankingList({this.name, this.status, this.icon});

  NetBankingList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    icon = json['icon'];
  }
}
class WalletList {
  String name;
  String status;
  String icon;

  WalletList({this.name, this.status, this.icon});

  WalletList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    icon = json['icon'];
  }
}