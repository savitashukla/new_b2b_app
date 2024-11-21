class InvoidModel {
  String expiry;
  String merchantId;
  String requestId;
  int statusCode;
  int timestamp;
  String transactionId;
  String url;

  InvoidModel(
      {this.expiry,
        this.merchantId,
        this.requestId,
        this.statusCode,
        this.timestamp,
        this.transactionId,
        this.url});

  InvoidModel.fromJson(Map<String, dynamic> json) {
    expiry = json['expiry'];
    merchantId = json['merchantId'];
    requestId = json['requestId'];
    statusCode = json['statusCode'];
    timestamp = json['timestamp'];
    transactionId = json['transactionId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry'] = this.expiry;
    data['merchantId'] = this.merchantId;
    data['requestId'] = this.requestId;
    data['statusCode'] = this.statusCode;
    data['timestamp'] = this.timestamp;
    data['transactionId'] = this.transactionId;
    data['url'] = this.url;
    return data;
  }
}