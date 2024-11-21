class BallbaziModel {
  String webViewUrl;

  BallbaziModel({this.webViewUrl});

  BallbaziModel.fromJson(Map<String, dynamic> json) {
    if (json['webViewUrl'] != null) {
     webViewUrl=json['webViewUrl'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webViewUrl != null) {
      data['data'] = this.webViewUrl;
    }
    return data;
  }
}

class Data {
  String webViewUrl;

  Data(
      {this.webViewUrl});

  Data.fromJson(Map<String, dynamic> json) {
    webViewUrl = json['webViewUrl'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['webViewUrl'] = this.webViewUrl;
    return data;
  }
}
