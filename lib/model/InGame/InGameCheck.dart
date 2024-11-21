import 'package:gmng/model/basemodel/AppBaseModel.dart';

class InGameCheck  extends AppBaseModel{
  String id;
  String userId;
  String gameId;
  String inGameName;
  String inGameId;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  String getInGameName(){
    return getValidString(this.inGameName);
  }

  InGameCheck(
      {this.id,
        this.userId,
        this.gameId,
        this.inGameName,
        this.inGameId,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt});

  InGameCheck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    gameId = json['gameId'];
    inGameName = json['inGameName'];
    inGameId = json['inGameId'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['gameId'] = this.gameId;
    data['inGameName'] = this.inGameName;
    data['inGameId'] = this.inGameId;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
