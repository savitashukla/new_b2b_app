class CashfreeResponseModel {
  Data data;

  CashfreeResponseModel({this.data});

  CashfreeResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String action;
  String channel;
  Data data;
  String paymentMethod;
  CheckPayment checkPayment;

  String url;
  Payload payload;
  String contentType;
  String method;

  Data(
      {this.action,
      this.channel,
      this.data,
      this.paymentMethod,
      this.checkPayment,
      this.url,
      this.payload,
      this.contentType,
      this.method});

  Data.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    channel = json['channel'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    paymentMethod = json['payment_method'];
    checkPayment = json['checkPayment'] != null
        ? new CheckPayment.fromJson(json['checkPayment'])
        : null;
    url = json['url'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    contentType = json['content_type'];
    method = json['method'];
  }
}

class Payload {
  String bhim;
  String gpay;
  String paytm;
  String phonepe;
  String web;

  Payload({this.bhim, this.gpay, this.paytm, this.phonepe, this.web});

  Payload.fromJson(Map<String, dynamic> json) {
    bhim = json['bhim'];
    gpay = json['gpay'];
    paytm = json['paytm'];
    phonepe = json['phonepe'];
    web = json['web'];
  }
}

class CheckPayment {
  String paymentId;
  String orderId;
  String userId;
  String gateway;

  CheckPayment({this.paymentId, this.orderId, this.userId, this.gateway});

  CheckPayment.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    orderId = json['orderId'];
    userId = json['userId'];
    gateway = json['gateway'];
  }
}
