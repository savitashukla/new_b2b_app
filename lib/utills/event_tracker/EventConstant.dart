class EventConstant {
  //NOT USED EVENTS
  static const String KYC_EVENT = "kyc_event";
  static const String REFER_EVENT = "refer_event";
  static const String REWARD_EVENT = "reward_event";
  static const String TOURNAMENT_SCREEN_EVENT = "tournament_screen_event";
  static const String LEADERBOARD_SCREEN_EVENT = "leaderboard_screen_event";
  static const String PROFILE_SCREEN_EVENT = "profile_screen_event";
  static const String LOGIN_SCREEN_EVENT = "login_screen_event";
  static const String LOGOUT_SCREEN_EVENT = "logout_event";
  static const String EVENT_REGISTER = "Registration"; //not used
  static const String EVENT_REFERAL = "Referal";
  static const String EVENT_FTD_AMOUNT = "FTD Amount";
  static const String EVENT_FTD = "FTD";
  static const String EVENT_REPEATED_DEPOSITE_COUNT = "Repeat Deposit";
  static const String EVENT_REPEATED_DEPOSITE_AMOUNT = "repeat deposit Amount";
  static const String EVENT_REAL_GAME_PALYED = "real gameplay";
  static const String EVENT_BONUS_GAME_PLAYED_AMOUNT = "bonus gameplay amount";
  static const String EVENT_REAL_GAME_PLAYED_AMOUNT = "real gameplay amount";
  //Rewards event
  static const String EVENT_OPEN_WHEEL = "open_wheel";
  static const String EVENT_SPIN_WHEEL_ROLL = "spin_wheel";
  static const String EVENT_INVITE_SHARED_CODE =
      "event_invite_friends_share_code";
  static const String EVENT_REGISTERTION = "event_register";
  static const String EVENT_LEAVE_CLAN = "event_leave_clan";
  //Tournament event
  static const String EVENT_BANNER_CLICK = "event_banner_click";
  static const String EVENT_VOTE_BUTTON = "event_vote_click";
  static const String EVENT_JOIN_BUTTON = "event_tournament_join_click";
  static const String EVENT_JOIN_BUTTON_UNITY = "event_tournament_join_unity";
  static const String EVENT_JOINED_CONFIRMATION_BUTTON =
      "event_tournament_joined_confirmation_click";
  //Wallet event
  static const String CLICK_ADD_MONEY_BUTTON = "click_add_money_button";
  static const String AMOUNT_SELECTED = "amount_selected";
  static const String ADD_AMOUNT = "add_Amount";
  static const String WITHDRAW_AMOUNT = "withdraw_amount";
  static const String EVENT_PREDEFINED_AMOUNT_SELECT =
      "predefined_amount_select";
  //event user profile
  static const String EVENT_CHNAGE_PORILE_IMAGES = "change_profile_image";

  //.
  //.
  //.
  //WORKING EVENTS
  static const String EVENT_OTP_VERIFICTION = "event_otp_verifiction";
  static const String EVENT_ADD_MONEY_CANCEL = "add_money_failed";
  static const String EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM =
      "common_amount_add_money";
  static const String bottom_click_event = "Bottom bar pages event";

  //event CleaverTab
  static const String EVENT_CLEAVERTAB_Registration = "Registration";
  static const String EVENT_CLEAVERTAB_Registration_COMPLETE =
      "Registration Complete";
  static const String EVENT_CLEAVERTAB_Login = "Login";
  static const String EVENT_CLEAVERTAB_Deposit_Initiated = "Deposit Initiated";
  static const String EVENT_CLEAVERTAB_Deposit_Success = "Deposit Success";
  static const String EVENT_CLEAVERTAB_Withdrawl = "Withdrawal Initiate";
  static const String EVENT_CLEAVERTAB_Withdrawl_Success = "Withdrawal Success";
  static const String EVENT_CLEAVERTAB_Store_Purchase = "Store Purchase";
  static const String EVENT_CLEAVERTAB_Team_Created = "Team Created";
  static const String EVENT_CLEAVERTAB_Team_Registred = "Team Registred";

  // KYC
  static const String EVENT_CLEAVERTAB_KYC_status = "KYC status";
  static const String EVENT_CLEAVERTAB_KYC_KYC_status = "KYC success";
  static const String EVENT_CLEAVERTAB_KYC_KYC_failed = "KYC failed";
  static const String EVENT_CLEAVERTAB_KYC_Add_Event = "Add Event";
  static const String EVENT_CLEAVERTAB_GAME_CLICKED = "Game Clicked";
  static const String EVENT_CLEAVERTAB_BANNER_CLICK = "Banner Clicked";

  //af event
  static const String LOGIN_EVENT = "af_login";

  //event param
  static const String PARAM_USER_NAME = "USER_NAME";
  static const String PARAM_USER_ID = "USER_ID";
  static const String PARAM_METHOD = "Method";
  static const String PARAM_SCREEN_NAME = "Page Name";
  static const String PARAM_BANNER_ID = "Banner ID";
  static const String PARAM_BANNER_NAME = "Banner Name";

  //new events added
  static const String EVENT_CLEAVERTAB_First_Time_Deposit =
      "First Time Deposit";
  static const String EVENT_CLEAVERTAB_Leaderboard_Screen =
      "Leaderboard Screen";
  static const String EVENT_CLEAVERTAB_Reward_Screen = "Reward Screen";
  static const String EVENT_CLEAVERTAB_Clan_Screen = "Clan Screen";
  static const String EVENT_CLEAVERTAB_Wallet_Screen = "Wallet Screen";
/*
  static const String EVENT_CLEAVERTAB_Deposit_initiate="Deposit initiate";
*/
  static const String EVENT_CLEAVERTAB_Profile_Screen = "Profile Screen";
  static const String EVENT_CLEAVERTAB_Support_button_clicked =
      "Support button clicked";
  static const String EVENT_CLEAVERTAB_KYC_Initiated = "KYC Initiated";
  static const String EVENT_CLEAVERTAB_Logout = "Logout";

  static const String ESports_CLEAVERTAB_Joined_Contest =
      "E-Sports Joined Contest"; //eSports
  static const String EVENT_CLEAVERTAB_Joined_Contest =
      "Casual Joined Contest"; //Gmng Originals
  static const String EVENT_Joined_Contest =
      "Joined Contest"; //for appsflyer only
  static const String EVENT_Refer_and_Earn = "Refer and Earn";
  static const String User_Refer_Affiliate = "User Refer Affiliate";
  static const String User_Refer_Affiliate_Again = "User Refer Affiliate Again";
  static const String User_Refer_Affiliate_Final = "User Refer Affiliate Final";
  static const String Become_User_Affiliate = "Become User Affiliate";
  static const String EVENT_Casual_Game_Complete = "Casual Game Complete";
  static const String EVENT_New_User_Game = "New User Game"; //<<<
  static const String EVENT_New_User_Game_Skip = "New User Skip Game";
  static const String EVENT_Game_Over_Pending_Event = "Game Over Pending Event";
  static const String EVENT_Penny_Drop_Initiated = "Penny Drop Initiated";
  static const String EVENT_Penny_Drop_status = "Penny Drop status";
  static const String EVENT_Offerwall = "Offerwall";
  static const String EVENT_payment_screen_view = "payment screen view";
  static const String EVENT_Prelogin = "prelogin"; //not added user id
  static const String State = "state"; //not added user id
  static const String EVENT_NAME_af_purchase =
      "af_purchase"; //not added user id
  static const String app_type = "app type"; //not added user id
  static const String app_type_new = "App Type"; //not added user id
//VIP event added
  static const String Instant_Cash_Clicked = "Instant cash clicked";
  static const String Redeem_clicked = "Redeem clicked";
  static const String EVENGT_REPLAY = "Re Play";
  static const String withdrawMethod = "withdrawMethod Api Error";
  static const String game_favorite_game = "My favorite Game";
  static const String EVENT_Form16Requested = "EVENT_Form16Requested";

  //firebase events
  //firebase events
  static const String EVENT_FIREBASE_Login = "Login";
  static const String EVENT_FIREBASE_Registration = "Registration";
  static const String EVENT_FIREBASE_Deposit_Initiated = "Deposit_Initiated";
  static const String EVENT_FIREBASE_Deposit_Success = "Deposit_Success";
  static const String EVENT_FIREBASE_Withdrawl = "Withdrawal_Initiate";
  static const String EVENT_FIREBASE_Withdrawl_test =
      "Withdrawal_Initiate_test";
  static const String EVENT_CLEAVERTAB_Withdrawl_Success_F =
      "Withdrawal_Success";

// ADD Firebase  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  //WORKING EVENTS
  static const String Deposit_Failed_F = "Deposit Failed";
  static const String EVENT_FIREBASE_Deposit_Initiated_f = "Deposit_Initiated";
  static const String EVENT_FIREBASE_Deposit_Success_F = "Deposit_Success";
  // no need this
  static const String EVENT_ENTER_AMOUNT_ADD_MONEY_COMMOM_F =
      "common_amount_add_money";
  static const String bottom_click_event_F = "Bottom_bar_pages_event";
  //event CleaverTab
  static const String EVENT_CLEAVERTAB_Store_Purchase_F = "Store_Purchase";
  static const String EVENT_CLEAVERTAB_Team_Created_F = "Team_Created";
  static const String EVENT_CLEAVERTAB_Team_Registred_F = "Team_Registred";

  // KYC
  static const String EVENT_CLEAVERTAB_KYC_status_F = "KYC_status";
  static const String EVENT_CLEAVERTAB_KYC_KYC_status_F = "KYC_success";
  static const String EVENT_CLEAVERTAB_KYC_KYC_failed_F = "KYC_failed";
  static const String EVENT_CLEAVERTAB_KYC_Add_Event_F = "Add_Event";
  static const String EVENT_CLEAVERTAB_GAME_CLICKED_F = "Game_Clicked";
  static const String EVENT_CLEAVERTAB_BANNER_CLICK_F = "Banner_Clicked";

  //af event
  static const String LOGIN_EVENT_F = "af_login";

  //event param
  static const String PARAM_USER_NAME_F = "USER_NAME";
  static const String PARAM_USER_ID_F = "USER_ID";
  static const String PARAM_METHOD_F = "Method";
  static const String PARAM_SCREEN_NAME_F = "Page_Name";
  static const String PARAM_BANNER_ID_F = "Banner_ID";
  static const String PARAM_BANNER_NAME_F = "Banner_Name";

  //new events added

  static const String EVENT_CLEAVERTAB_Leaderboard_Screen_F =
      "Leaderboard_Screen";
  static const String EVENT_CLEAVERTAB_Reward_Screen_F = "Reward_Screen";
  static const String EVENT_CLEAVERTAB_Clan_Screen_F = "Clan_Screen";
  static const String EVENT_CLEAVERTAB_Wallet_Screen_F = "Wallet_Screen";
/*
  static const String EVENT_CLEAVERTAB_Deposit_initiate="Deposit initiate";
*/
  static const String EVENT_CLEAVERTAB_Profile_Screen_F = "Profile_Screen";
  static const String EVENT_CLEAVERTAB_Support_button_clicked_F =
      "Support_button_clicked";
  static const String EVENT_CLEAVERTAB_KYC_Initiated_F = "KYC_Initiated";
  static const String EVENT_CLEAVERTAB_Logout_F = "Logout";

  static const String ESports_CLEAVERTAB_Joined_Contest_F =
      "E_Sports_Joined_Contest"; //eSports
  static const String EVENT_CLEAVERTAB_Joined_Contest_F =
      "Casual_Joined_Contest"; //Gmng Originals
  static const String EVENT_Joined_Contest_F =
      "Joined_Contest"; //for appsflyer only
  static const String EVENT_Refer_and_Earn_F = "Refer_and_Earn";
  static const String User_Refer_Affiliate_F = "User_Refer_Affiliate";
  static const String User_Refer_Affiliate_Again_F =
      "User_Refer_Affiliate_Again";
  static const String User_Refer_Affiliate_Final_F =
      "User_Refer_Affiliate_Final";
  static const String Become_User_Affiliate_F = "Become_User_Affiliate";
  static const String EVENT_Casual_Game_Complete_F = "Casual_Game_Complete";
  static const String EVENT_New_User_Game_F = "New_User_Game"; //<<<
  static const String EVENT_New_User_Game_Skip_F = "New_User_Skip_Game";
  static const String EVENT_Game_Over_Pending_Event_F =
      "Game_Over_Pending_Event";
  static const String EVENT_Penny_Drop_Initiated_F = "Penny_Drop_Initiated";
  static const String EVENT_Penny_Drop_status_F = "Penny_Drop_status";
  static const String EVENT_Offerwall_F = "Offerwall";
  static const String EVENT_payment_screen_view_F = "payment_screen_view";
  static const String EVENT_Prelogin_F = "prelogin"; //not added user id
  static const String State_F = "state"; //not added user id
  static const String EVENT_NAME_af_purchase_F =
      "af_purchase"; //not added user id
  static const String app_type_F = "app_type";
//VIP event added
  static const String Instant_Cash_Clicked_F = "Instant_cash_clicked";
  static const String Redeem_clicked_F = "Redeem_clicked";
  static const String EVENGT_REPLAY_F = "Re_Play";
  static const String game_favorite_game_F = "My_favorite_Game";
  static const String EVENT_Form16Requested_F = "EVENT_Form16Requested";
  //facebook new event
  static const String EVENT_Purchase = "Purchase";
}
