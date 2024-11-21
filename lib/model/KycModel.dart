import 'package:gmng/model/basemodel/AppBaseModel.dart';

class KycModel extends AppBaseModel {
   String kycid;
   String kycimage;
   String kycstatus;
   String type;
   String rejectreason;

  KycModel(
      {this.kycid,
      this.kycimage,
      this.kycstatus,
      this.type,
      this.rejectreason

      });

  factory KycModel.fromJson(Map<String, dynamic> json) {
    return KycModel(
      kycid: json['kycid'],
      kycimage: json['kycimage'],
      kycstatus: json['kycstatus'],
      type: json['type'],
      rejectreason: json['rejectreason'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kycid'] = this.kycid;
    data['kycimage'] = this.kycimage;
    data['kycstatus'] = this.kycstatus;
    data['type'] = this.type;
    data['rejectreason'] = this.rejectreason;
    return data;
  }


}
