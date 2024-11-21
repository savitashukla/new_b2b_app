import 'package:gmng/model/basemodel/AppBaseModel.dart';

class WalletModel extends AppBaseModel {
  double depositewallet, winningwallet, bonuswallet, coinwallet;

  WalletModel(
      {this.depositewallet,
      this.winningwallet,
      this.bonuswallet,
      this.coinwallet});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      depositewallet: json['depositewallet'],
      winningwallet: json['winningwallet'],
      bonuswallet: json['bonuswallet'],
      coinwallet: json['coinwallet'],

      //  map: json['map'] != null ? (json['map'] as List).map((i) => Map.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['depositewallet'] = this.depositewallet;
    data['winningwallet'] = this.winningwallet;
    data['bonuswallet'] = this.bonuswallet;
    data['coinwallet'] = this.coinwallet;
    return data;
  }

   String getDepositeWalletText() {
    String amount = depositewallet.toString();
    String amount_decimal = depositewallet.toString();
    List<String> list = amount_decimal.split("\\.");
    if (list.length == 2) {
      if (int.parse(list[1]) > 0) {
        amount = depositewallet.toString();
      } else {
        amount = list[0];
      }
    }
    return amount;
  }
}
