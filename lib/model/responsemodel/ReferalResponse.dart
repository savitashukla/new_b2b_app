import 'dart:convert';

import 'package:gmng/model/basemodel/AppBaseModel.dart';

class ReferalResponse extends AppBaseModel {
  List<ReferalListModel> data;

  ReferalResponse({this.data});

  ReferalResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ReferalListModel>();
      json['data'].forEach((v) {
        data.add(new ReferalListModel.fromJson(v));
      });
    }
  }

  static String FAQs =
      "[{\"id\":\"1\",\"question\":\"How can I earn money?\",\"answer\":\"Refer a friend and when your friend login into app you get real money.\",\"question_hi\":\"मैं पैसे कैसे कमा सकता हूँ?\",\"answer_hi\":\"किसी मित्र को रेफर करें और जब आपका मित्र ऐप में लॉग इन करेगा तो आपको वास्तविक पैसा मिलेगा।\"},{\"id\":\"2\",\"question\":\"When will the money get credited to my wallet?\",\"answer\":\"Money from a friend gets instantly credited as soon as your friend makes the necessary action.\",\"question_hi\":\"मेरे वॉलेट में पैसा कब जमा होगा?\",\"answer_hi\":\"जैसे ही आपका मित्र आवश्यक कार्रवाई करता है, मित्र का पैसा तुरंत जमा हो जाता है।\"},{\"id\":\"3\",\"question\":\"How much money can I earn?\",\"answer\":\"There is no limit on how much money one can make, Keep referring to earning.\",\"question_hi\":\"मैं कितना पैसा कमा सकता हूँ?\",\"answer_hi\":\"कोई कितना पैसा कमा सकता है इसकी कोई सीमा नहीं है, कमाई करने के लिए रेफर करते रहें।\"},{\"id\":\"4\",\"question\":\"Who can I refer to?\",\"answer\":\"Anyone who is currently not a part of the GMNG app can be referred.\",\"question_hi\":\"मैं किसका उल्लेख कर सकता हूँ?\",\"answer_hi\":\"वर्तमान में GMNG ऐप का हिस्सा नहीं होने वाले किसी भी व्यक्ति को संदर्भित किया जा सकता है।\"},{\"id\":\"5\",\"question\":\"How can I get \u20b910 for step 2?\",\"answer\":\"Once your friend successfully registers on the app, they have to make a minimum deposit of the mentioned amount.\",\"question_hi\":\"मुझे कैसे प्राप्त करना है Rs. 10 स्टेप 2 के लिए?\",\"answer_hi\":\"जब आपका दोस्त सफलतापूर्वक ऐप पर पंजीकृत होता है, तो उन्हें उल्लिखित राशि का न्यूनतम जमा करना होता है।\"}]"; //json.decode("");
}

class ReferalListModel extends AppBaseModel {
  String id;
  String username;
  NameModel name;
  Amount amount;
  Photo photo;
  int count;
  var rank;

  ReferalListModel(
      {this.id,
      this.username,
      this.name,
      this.amount,
      this.photo,
      this.count,
      this.rank});

  ReferalListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'] != null ? new NameModel.fromJson(json['name']) : null;
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    count = json['count'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    data['count'] = this.count;
    data['rank'] = this.rank;
    return data;
  }
}

class Amount {
  int value;
  String type;
  num getAmountValues() {
    int value = this.value;
    if (this.type == 'currency') {
      return value ~/ 100;
    }
    return value;
  }

  Amount({this.value, this.type});

  Amount.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

class NameModel extends AppBaseModel {
  String first;
  String last;

  NameModel({this.first, this.last});

  NameModel.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }

  String getFullname() {
    return getValidString(this.first) + " " + getValidString(this.last);
  }
}

class Photo {
  String id;
  String url;

  Photo({this.id, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class FAQ {
  String id;
  String question;
  String answer;
  bool isShow;

  FAQ({this.id, this.question, this.answer});

  FAQ.fromJson(Map<String, dynamic> json, String lang_code) {
    id = json['id'];
    if (lang_code == 'hi') {
      question = json['question_hi'];
      answer = json['answer_hi'];
    } else {
      question = json['question'];
      answer = json['answer'];
    }

    isShow = false;
  }
}
