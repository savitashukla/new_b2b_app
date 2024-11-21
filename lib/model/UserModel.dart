
import 'package:gmng/model/KycModel.dart';
import 'package:gmng/model/wallet/WalletModel.dart';

class UserModel{

  var otp,Mobile,firstname,username,referecode,Email,userphoto,is_Streamers,authenticationkey,bio;
  var id,Userid,userid;
  WalletModel wallet_details;
  KycModel kyc_details;


  static UserModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserModel dataBean = UserModel();
    dataBean.id = map['id'];
    dataBean.Userid = map['Userid'];
    dataBean.userid = map['userid'];
    dataBean.otp = map['otp'];
    dataBean.Mobile = map['Mobile'];
    dataBean.firstname = map['firstname'];
    dataBean.username = map['username'];
    dataBean.referecode = map['referecode'];
    dataBean.Email = map['Email'];
    dataBean.userphoto = map['userphoto'];
    dataBean.is_Streamers = map['is_Streamers'];
    dataBean.authenticationkey = map['authenticationkey'];
    dataBean.bio = map['bio'];
    dataBean.wallet_details = map['wallet_details'] != null ? new WalletModel.fromJson(map['wallet_details']) : null;
    dataBean.kyc_details = map['kyc_details'] != null ? new KycModel.fromJson(map['kyc_details']) : null;

    return dataBean;
  }

  Map toJson() => {
      "id": id,
      "Userid": Userid,
      "userid": userid,
      "otp":otp,
      "Mobile":Mobile,
      "firstname":firstname,
      "username":username,
      "referecode":referecode,
      "Email":Email,
      "userphoto":userphoto,
      "is_Streamers":is_Streamers,
      "authenticationkey":authenticationkey,
      "bio":bio,
      "wallet_details":wallet_details,
      "kyc_details":kyc_details,

  };


}