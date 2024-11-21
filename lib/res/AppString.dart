import 'package:get/get.dart';

import '../model/HomeModel/Game.dart';

class AppString {
  //stage
 // String header_Token = "BRAZGMNG8MTI";
  //live
  String header_Token = "AC16B7D60F63439594B421E76132EF1A";

  String txt_bootom_leaderboard = "Leaderboard";
  String appTypes =
      "website"; //changes acc to app type like website, playstore, fantasy etc
  String txt_country = "91";
  String txt_bootom_reward = "Rewards";
  String e_wallet = "Wallet";
  String txt_clan = "Clan";
  String txt_profile = "Profile";
  String txt_add = "ADD";
  String play_now = "Play now";
  String play_now1 = "";
  String txt_share_your_referal_code = "Share your referral code:";
  String txt_share_on = "Share on :-";
  String text_payment_option =
      "Notes : Make sure that you have entered correct details for UPI /Bank Account. We are unable to cross-verify the details.Your money will be transferred to the added UPI ID / Bank Account if the bank accepts. You can't change the details once you have entered them.\n \n You can view and report your transactions history in the transactions tab in the Wallet Menu. In case of any errors, we will refund your money back into your GMNG account within 7 working days. \n \n Please contact our support in case of any issues. We will help in resolving your concerns.";
  String txt_currency_symbole = "\u{20B9}";
  static String depositWalletId = '';
  static String serverTime = '';
  static String gameName = '';
  static var restrictedStatesData = null;
  static String StateNameConcat = '';
  static String mobile = '';
  static String email = '';
  static String username = '';
  static bool isClickFromHome = false;
  static var isUserFTR = false; //need to keep false
  static int helperCountAnimation = 0; //for new users
  static var offerWallLoot = "active".obs;
  static var profileUpdate = "active".obs;
  static var buyStoreItem = "active".obs;
  static var linkAccount = "active".obs;
  static var joinContest = "active".obs;
  static var createTeam = "active".obs;
  static var joinClan = "active".obs;
  static var leaveClan = "active".obs;
  static var acceptTeamInvitation = "active".obs;
  static var esportPaymentEnable = "active".obs;
  static var bureauIdEnable = "active".obs;
  static var promoCodes = "active".obs; //new keys
  static var referAndEarn = "active".obs; //new keys

  static bool rummyisClickable = true;
  static int contestAmount = 0;
  static var userVipLevelString = ''.obs;
  //new
  static var helperContestName = ''.obs;
  static var helperTimer = 0;
  static var helperContestId = '';
  //new myFavGamePopup
  static var isSelectMyGameCount = 0;
  static var instanceAddDepositTime = false;
  static var logoutTrue = true;
  static var appBarHeight = 39.0.obs;
}
