class PaymentIcons {
  Upi_icon upi;
  Wallet_icon wallet;
  Netbanking_icon netbanking;
  Card_icon card;

  PaymentIcons({this.upi, this.wallet, this.netbanking, this.card});

  PaymentIcons.fromJson(Map<String, dynamic> json) {
    upi = json['upi'] != null ? new Upi_icon.fromJson(json['upi']) : null;
    wallet =
    json['wallet'] != null ? new Wallet_icon.fromJson(json['wallet']) : null;
    netbanking = json['netbanking'] != null
        ? new Netbanking_icon.fromJson(json['netbanking'])
        : null;
    card = json['card'] != null ? new Card_icon.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upi != null) {
      data['upi'] = this.upi.toJson();
    }
    if (this.wallet != null) {
      data['wallet'] = this.wallet.toJson();
    }
    if (this.netbanking != null) {
      data['netbanking'] = this.netbanking.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}

class Upi_icon {
  String bhim;
  String googlePay;
  String paytm;
  String phonePe;

  Upi_icon({this.bhim, this.googlePay, this.paytm, this.phonePe});

  Upi_icon.fromJson(Map<String, dynamic> json) {
    bhim = json['Bhim'];
    googlePay = json['GooglePay'];
    paytm = json['Paytm'];
    phonePe = json['PhonePe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bhim'] = this.bhim;
    data['GooglePay'] = this.googlePay;
    data['Paytm'] = this.paytm;
    data['PhonePe'] = this.phonePe;
    return data;
  }
}

class Wallet_icon {
  String freeCharge;
  String mobiKwik;
  String olaMoney;
  String relianceJioMoney;
  String airtelMoney;
  String paytm;
  String amazonPay;
  String phonePe;
  String payZapp;

  Wallet_icon(
      {this.freeCharge,
        this.mobiKwik,
        this.olaMoney,
        this.relianceJioMoney,
        this.airtelMoney,
        this.paytm,
        this.amazonPay,
        this.phonePe,
        this.payZapp});

  Wallet_icon.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FreeCharge'] = this.freeCharge;
    data['MobiKwik'] = this.mobiKwik;
    data['OlaMoney'] = this.olaMoney;
    data['RelianceJioMoney'] = this.relianceJioMoney;
    data['AirtelMoney'] = this.airtelMoney;
    data['Paytm'] = this.paytm;
    data['AmazonPay'] = this.amazonPay;
    data['PhonePe'] = this.phonePe;
    data['PayZapp'] = this.payZapp;
    return data;
  }
}

class Netbanking_icon {
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

  Netbanking_icon(
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
        this.orientalBankOfCommerce});

  Netbanking_icon.fromJson(Map<String, dynamic> json) {
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
    ujjivanSmallFinanceBank = json['UjjivanSmallFinanceBank'];
    unitedBankOfIndia = json['UnitedBankOfIndia'];
    orientalBankOfCommerce = json['OrientalBankOfCommerce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AxisBank'] = this.axisBank;
    data['BankOfBarodaRetail'] = this.bankOfBarodaRetail;
    data['BankOfIndia'] = this.bankOfIndia;
    data['BankOfMaharashtra'] = this.bankOfMaharashtra;
    data['CanaraBank'] = this.canaraBank;
    data['CatholicSyrianBank'] = this.catholicSyrianBank;
    data['CentralBankOfIndia'] = this.centralBankOfIndia;
    data['CityUnionBank'] = this.cityUnionBank;
    data['DeutscheBank'] = this.deutscheBank;
    data['DBSBank'] = this.dBSBank;
    data['DCBBankPersonal'] = this.dCBBankPersonal;
    data['DhanlakshmiBank'] = this.dhanlakshmiBank;
    data['FederalBank'] = this.federalBank;
    data['HDFCBank'] = this.hDFCBank;
    data['ICICIBank'] = this.iCICIBank;
    data['IDBIBank'] = this.iDBIBank;
    data['IDFCFIRSTBank'] = this.iDFCFIRSTBank;
    data['IndianBank'] = this.indianBank;
    data['IndianOverseasBank'] = this.indianOverseasBank;
    data['IndusIndBank'] = this.indusIndBank;
    data['JammuAndKashmirBank'] = this.jammuAndKashmirBank;
    data['KarnatakaBank'] = this.karnatakaBank;
    data['KarurVysyaBank'] = this.karurVysyaBank;
    data['KotakMahindraBank'] = this.kotakMahindraBank;
    data['LaxmiVilasBankRetail'] = this.laxmiVilasBankRetail;
    data['PunjabSindBank'] = this.punjabSindBank;
    data['PunjabNationalBankRetail'] = this.punjabNationalBankRetail;
    data['RBLBank'] = this.rBLBank;
    data['SaraswatBank'] = this.saraswatBank;
    data['ShamraoVitthalCoOpBank'] = this.shamraoVitthalCoOpBank;
    data['SouthIndianBank'] = this.southIndianBank;
    data['StandardCharteredBank'] = this.standardCharteredBank;
    data['StateBankOfIndia'] = this.stateBankOfIndia;
    data['TamilNaduStateCoOpBank'] = this.tamilNaduStateCoOpBank;
    data['TamilnadMercantileBank'] = this.tamilnadMercantileBank;
    data['UCOBank'] = this.uCOBank;
    data['UnionBankOfIndia'] = this.unionBankOfIndia;
    data['YesBank'] = this.yesBank;
    data['BankOfBarodaCorporate'] = this.bankOfBarodaCorporate;
    data['BankOfIndiaCorporate'] = this.bankOfIndiaCorporate;
    data['DCBBankCorporate'] = this.dCBBankCorporate;
    data['LakshmiVilasBankCorporate'] = this.lakshmiVilasBankCorporate;
    data['PunjabNationalBankCorporate'] = this.punjabNationalBankCorporate;
    data['StateBankOfIndiaCorporate'] = this.stateBankOfIndiaCorporate;
    data['UnionBankOfIndiaCorporate'] = this.unionBankOfIndiaCorporate;
    data['AxisBankCorporate'] = this.axisBankCorporate;
    data['DhanlaxmiBankCorporate'] = this.dhanlaxmiBankCorporate;
    data['ICICICorporate'] = this.iCICICorporate;
    data['RatnakarCorporate'] = this.ratnakarCorporate;
    data['ShamraoVithalBankCorporate'] = this.shamraoVithalBankCorporate;
    data['EquitasSmallFinanceBank'] = this.equitasSmallFinanceBank;
    data['YesBankCorporate'] = this.yesBankCorporate;
    data['BandhanBankCorporatebanking'] = this.bandhanBankCorporatebanking;
    data['BarclaysCorporate'] = this.barclaysCorporate;
    data['IndianOverseasBankCorporate'] = this.indianOverseasBankCorporate;
    data['CityUnionBankOfCorporate'] = this.cityUnionBankOfCorporate;
    data['HDFCCorporate'] = this.hDFCCorporate;
    data['ShivalikBank'] = this.shivalikBank;
    data['AUSmallFinance'] = this.aUSmallFinance;
    data['BandhanBankRetail'] = this.bandhanBankRetail;
    data['UtkarshSmallFinanceBank'] = this.utkarshSmallFinanceBank;
    data['TheSuratPeopleCoOpBank'] = this.theSuratPeopleCoOpBank;
    data['GujaratStateCoOpBank'] = this.gujaratStateCoOpBank;
    data['HSBCRetail'] = this.hSBCRetail;
    data['AndhraPragathiGrameenaBank'] = this.andhraPragathiGrameenaBank;
    data['BassienCatholicCoOpBank'] = this.bassienCatholicCoOpBank;
    data['CapitalSmallFinanceBank'] = this.capitalSmallFinanceBank;
    data['ESAFSmallFinanceBank'] = this.eSAFSmallFinanceBank;
    data['FincareBank'] = this.fincareBank;
    data['JanaSmallFinanceBank'] = this.janaSmallFinanceBank;
    data['JioPaymentsBank'] = this.jioPaymentsBank;
    data['JanataSahakariBankPune'] = this.janataSahakariBankPune;
    data['KalyanJanataSahakariBank'] = this.kalyanJanataSahakariBank;
    data['TheKalupurCommercialCoOpBank'] = this.theKalupurCommercialCoOpBank;
    data['KarnatakaVikasGrameenaBank'] = this.karnatakaVikasGrameenaBank;
    data['MaharashtraGraminBank'] = this.maharashtraGraminBank;
    data['NorthEastSmallFinanceBank'] = this.northEastSmallFinanceBank;
    data['NKGSBCoOpBank'] = this.nKGSBCoOpBank;
    data['KarnatakaGraminBank'] = this.karnatakaGraminBank;
    data['RBLBankLimitedCorporate'] = this.rBLBankLimitedCorporate;
    data['SBMBankIndia'] = this.sBMBankIndia;
    data['SuryodaySmallFinanceBank'] = this.suryodaySmallFinanceBank;
    data['TheSutexCoOpBank'] = this.theSutexCoOpBank;
    data['ThaneBharatSahakariBank'] = this.thaneBharatSahakariBank;
    data['TJSBBank'] = this.tJSBBank;
    data['VarachhaCoOpBank'] = this.varachhaCoOpBank;
    data['ZoroastrianCoOpBank'] = this.zoroastrianCoOpBank;
    data['UCOBankCorporate'] = this.uCOBankCorporate;
    data['AirtelPaymentsBank'] = this.airtelPaymentsBank;
    data['UjjivanSmallFinanceBank'] = this.ujjivanSmallFinanceBank;
    data['UnitedBankOfIndia'] = this.unitedBankOfIndia;
    data['OrientalBankOfCommerce'] = this.orientalBankOfCommerce;
    return data;
  }
}

class Card_icon {
  String aMEX;
  String dICL;
  String mC;
  String mAES;
  String vISA;
  String jCB;
  String rUPAY;
  String bAJAJ;

  Card_icon(
      {this.aMEX,
        this.dICL,
        this.mC,
        this.mAES,
        this.vISA,
        this.jCB,
        this.rUPAY,
        this.bAJAJ});

  Card_icon.fromJson(Map<String, dynamic> json) {
    aMEX = json['AMEX'];
    dICL = json['DICL'];
    mC = json['MC'];
    mAES = json['MAES'];
    vISA = json['VISA'];
    jCB = json['JCB'];
    rUPAY = json['RUPAY'];
    bAJAJ = json['BAJAJ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AMEX'] = this.aMEX;
    data['DICL'] = this.dICL;
    data['MC'] = this.mC;
    data['MAES'] = this.mAES;
    data['VISA'] = this.vISA;
    data['JCB'] = this.jCB;
    data['RUPAY'] = this.rUPAY;
    data['BAJAJ'] = this.bAJAJ;
    return data;
  }
}
