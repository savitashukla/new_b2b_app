import 'package:gmng/model/basemodel/AppBaseModel.dart';

class LobbyModel extends AppBaseModel {
  String id;
  String eventId;
  String roundId;
  int serialNumber;
  int totalWinners;
  int totalTeams;
  String roomId;
  String roomPassword;
  String completedStatus;
  String status;
  String createdAt;
  String updatedAt;

  LobbyModel(
      {this.id,
        this.eventId,
        this.roundId,
        this.serialNumber,
        this.totalWinners,
        this.totalTeams,
        this.roomId,
        this.roomPassword,
        this.completedStatus,
        this.status,
        this.createdAt,
        this.updatedAt});

  LobbyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['eventId'];
    roundId = json['roundId'];
    serialNumber = json['serialNumber'];
    totalWinners = json['totalWinners'];
    totalTeams = json['totalTeams'];
    roomId = json['roomId'];
    roomPassword = json['roomPassword'];
    completedStatus = json['completedStatus'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['roundId'] = this.roundId;
    data['serialNumber'] = this.serialNumber;
    data['totalWinners'] = this.totalWinners;
    data['totalTeams'] = this.totalTeams;
    data['roomId'] = this.roomId;
    data['roomPassword'] = this.roomPassword;
    data['completedStatus'] = this.completedStatus;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}