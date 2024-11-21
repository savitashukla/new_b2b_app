class PublicSetting {
  Support support;

  PublicSetting({this.support});

  PublicSetting.fromJson(Map<String, dynamic> json) {
    support =
    json['support'] != null ? new Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.support != null) {
      data['support'] = this.support.toJson();
    }
    return data;
  }
}

class Support {
  int whatsappMobile;
  String email;
  int mobile;

  Support({this.whatsappMobile, this.email, this.mobile});

  Support.fromJson(Map<String, dynamic> json) {
    whatsappMobile = json['whatsappMobile'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsappMobile'] = this.whatsappMobile;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}
