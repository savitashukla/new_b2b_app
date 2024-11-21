class OtpVerificationModel {
  String id;
  String token;
  String expires;
  String now;

  OtpVerificationModel({this.id, this.token, this.expires, this.now});

  OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    expires = json['expires'];
    now = json['now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['expires'] = this.expires;
    data['now'] = this.now;
    return data;
  }
}