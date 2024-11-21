class LoginResponse {
  String otpRequestId;
  int otp;
  String userId;
  int statusCode;
  String error;
  bool isNew=false;

  LoginResponse({this.otpRequestId, this.otp, this.userId, this.statusCode,this.error,this.isNew});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    otpRequestId = json['otpRequestId'];
    otp = json['otp'];
    userId = json['userId'];
    statusCode = json['statusCode'];
    error = json['error'];
    isNew = json['isNew']!=null?json['isNew']:false;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpRequestId'] = this.otpRequestId;
    data['otp'] = this.otp;
    data['userId'] = this.userId;
    data['statusCode'] = this.statusCode;
    data['error'] = this.error;
    data['isNew'] = this.isNew;

    return data;
  }
}
