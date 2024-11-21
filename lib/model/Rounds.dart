
import 'Result.dart';
import 'basemodel/AppBaseModel.dart';

class Rounds extends AppBaseModel {
  String id;
  int serialNumber;
  String name;
  String status;
  String roomId;
  String roomPassword;
  bool isResultDeclared;
  bool isFinalRound;
  Result result;

  Rounds(
      {this.id,
        this.serialNumber,
        this.name,
        this.status,
        this.roomPassword,
        this.roomId,
        this.isResultDeclared,
        this.isFinalRound});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialNumber = json['serialNumber'];
    name = json['name'];
    status = json['status'];
    roomId = json['roomId'];
    roomPassword = json['roomPassword'];
    isResultDeclared = json['isResultDeclared'];
    isFinalRound = json['isFinalRound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serialNumber'] = this.serialNumber;
    data['name'] = this.name;
    data['status'] = this.status;
    data['roomId'] = this.roomId;
    data['roomPassword'] = this.roomPassword;
    data['isResultDeclared'] = this.isResultDeclared;
    data['isFinalRound'] = this.isFinalRound;
    return data;
  }

  String getRoomId() {
    return getValidString(this.roomId);
  }

  String getRoomPassword() {
    return getValidString(this.roomPassword);
  }
}
