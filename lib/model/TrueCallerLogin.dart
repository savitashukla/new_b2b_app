class TrueCallerLogin {
  Null otpRequestId;
  Null otpExpiration;
  String userId;
  bool isNew;
  Auth auth;

  TrueCallerLogin(
      {this.otpRequestId,
        this.otpExpiration,
        this.userId,
        this.isNew,
        this.auth});

  TrueCallerLogin.fromJson(Map<String, dynamic> json) {
    otpRequestId = json['otpRequestId'];
    otpExpiration = json['otpExpiration'];
    userId = json['userId'];
    isNew = json['isNew'];
    auth = json['auth'] != null ? new Auth.fromJson(json['auth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpRequestId'] = this.otpRequestId;
    data['otpExpiration'] = this.otpExpiration;
    data['userId'] = this.userId;
    data['isNew'] = this.isNew;
    if (this.auth != null) {
      data['auth'] = this.auth.toJson();
    }
    return data;
  }
}

class Auth {
  String id;
  String token;
  String expires;
  String now;

  Auth({this.id, this.token, this.expires, this.now});

  Auth.fromJson(Map<String, dynamic> json) {
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
