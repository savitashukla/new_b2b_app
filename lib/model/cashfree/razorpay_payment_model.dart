class RazorPayResponseModel {
  Data data;

  RazorPayResponseModel({this.data});

  RazorPayResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Next> next;
  CheckPayment checkPayment;

  Data({this.next, this.checkPayment});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['next'] != null) {
      next = <Next>[];
      json['next'].forEach((v) {
        next.add(new Next.fromJson(v));
      });
    }
    checkPayment = json['checkPayment'] != null
        ? new CheckPayment.fromJson(json['checkPayment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.next != null) {
      data['next'] = this.next.map((v) => v.toJson()).toList();
    }
    if (this.checkPayment != null) {
      data['checkPayment'] = this.checkPayment.toJson();
    }
    return data;
  }
}

class Next {
  String action;
  String url;

  Next({this.action, this.url});

  Next.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['url'] = this.url;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentId'] = this.paymentId;
    data['orderId'] = this.orderId;
    data['userId'] = this.userId;
    data['gateway'] = this.gateway;
    return data;
  }
}
