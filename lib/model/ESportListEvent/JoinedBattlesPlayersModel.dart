import 'package:gmng/model/ESportListEvent/UserJoinedResult.dart';
import 'package:gmng/model/basemodel/AppBaseModel.dart';
import 'package:gmng/utills/Utils.dart';

import '../UserLobboyModel.dart';

class JoinedBattlesPlayersModel  extends AppBaseModel{
  List<Users> users;
  List<Teams> teams;
  Pagination pagination;

  JoinedBattlesPlayersModel({this.users, this.teams, this.pagination});

  JoinedBattlesPlayersModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
       users.add(new Users.fromJson(v));
      });
    }
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }
  String getRoomName(String roundId){
    Utils().customPrint("roundId=> ${roundId}");
    String room_name="";
    Utils().customPrint("users_lenght==>${users.length}");
    if(users!=null && users.length>0){
      for (int j=0;j<users.length;j++){
      Utils().customPrint("room_check_length==>${users[j].rounds.length}");
        for(int i=0;i< users[j].rounds.length;i++){
        Utils().customPrint("room_check==>${users[j].rounds[i].roundId}");
          if(roundId==users[j].rounds[i].roundId&& users[j].rounds[i].lobbyId!=null){
          Utils().customPrint("room_nameloop==>${users[j].rounds[i].lobbyId.roomId}");
            room_name= getValidString(users[j].rounds[i].lobbyId.roomId);
            break;
          }
        }
      }
    }


    if(teams!=null && teams.length>0){
    Utils().customPrint("Type==>teams");
      for (int j=0;j<teams.length;j++){
        if(teams[j].members!=null && teams[j].members.length>0){
          for(int i=0; i<teams[j].members.length;i++){
            if(teams[j].members[i].eventRegistration!=null && teams[j].members[i].eventRegistration.rounds!=null&&
                teams[j].members[i].eventRegistration.rounds.length>0){
              for (int k=0;k<teams[j].members[i].eventRegistration.rounds.length;k++){
                if(teams[j].members[i].eventRegistration.rounds[k].roundId==roundId&& teams[j].members[i].eventRegistration.rounds[k].lobbyId!=null){
                  //Utils().customPrint("room_nameloop==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  room_name= getValidString(teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomId);
                  // print("room_check_length==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  break;
                }
              }

            }

          }

        }
      }
    }

  Utils().customPrint("room_name=> ${room_name}");
  return getValidString(room_name);
  }

  String getRoompassword(String roundId){
    // print("roundId=> ${roundId}");
    String room_name="";
  //Utils().customPrint("users_lenght==>${users.length}");
    if(users!=null && users.length>0){
    Utils().customPrint("Type==>USER");
      for (int j=0;j<users.length;j++){
        //Utils().customPrint("room_check_length==>${users[j].rounds.length}");
        if(users[j].rounds!=null&& users[j].rounds.length>0){
          for(int i=0;i< users[j].rounds.length;i++){
          Utils().customPrint("room_check==>${users[j].rounds[i].roundId}");

            if(roundId==users[j].rounds[i].roundId){
              if(users[j].rounds[i].lobbyId!=null){
              Utils().customPrint("room_password_solo==>${users[j].rounds[i].lobbyId.roundId}");
                room_name= getValidString(users[j].rounds[i].lobbyId.getRoomPassword());
                break;
              }
            }
          }
        }
      }
    }

    if(teams!=null && teams.length>0){
    Utils().customPrint("Type==>teams");
      for (int j=0;j<teams.length;j++){
        if(teams[j].members!=null && teams[j].members.length>0){
          for(int i=0; i<teams[j].members.length;i++){
              if(teams[j].members[i].eventRegistration!=null && teams[j].members[i].eventRegistration.rounds!=null&&
                  teams[j].members[i].eventRegistration.rounds.length>0){
                for (int k=0;k<teams[j].members[i].eventRegistration.rounds.length;k++){
                   if(teams[j].members[i].eventRegistration.rounds[k].roundId==roundId&& teams[j].members[i].eventRegistration.rounds[k].lobbyId!=null){
                   //Utils().customPrint("room_nameloop==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                     room_name= getValidString(teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword);
                    // print("room_check_length==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                     break;
                   }
                }

              }

          }

        }
      }
    }
  Utils().customPrint("password=> ${room_name}");
    return getValidString(room_name);
  }

  String getRoompasswordNew(String roundId){
  Utils().customPrint("roundId=> ${roundId}");
    String room_name="";
  Utils().customPrint("users_lenght==>${users.length}");
    for (int j=0;j<users.length;j++){
    Utils().customPrint("room_check_length==>${users[j].rounds.length}");
      for(int i=0;i< users[j].rounds.length;i++){
      Utils().customPrint("room_check==>${users[j].rounds[i].roundId}");

        if(roundId==users[j].rounds[i].roundId&&users[j].rounds[i].lobbyId!=null){
        Utils().customPrint("room_nameloop==>${users[j].rounds[i].lobbyId.roomPassword}");
          room_name= users[j].rounds[i].lobbyId.roomPassword;
          break;
        }
      }

    }
  Utils().customPrint("room_name=> ${room_name}");
    return getValidString(room_name);
  }
  String getRoomNameTeam(String roundId){
  Utils().customPrint("roundId=> ${roundId}");
    String room_name="";
    //print("users_lenght==>${users.length}");
    if(teams!=null && teams.length>0){
      for (int j=0;j<teams.length;j++){
        if(teams[j].members!=null && teams[j].members.length>0){
          for(int i=0; i<teams[j].members.length;i++){
            if(teams[j].members[i].eventRegistration!=null && teams[j].members[i].eventRegistration.rounds!=null&&
                teams[j].members[i].eventRegistration.rounds.length>0){
              for (int k=0;k<teams[j].members[i].eventRegistration.rounds.length;k++){
                if(teams[j].members[i].eventRegistration.rounds[k].roundId==roundId){
                Utils().customPrint("room_nameloop==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomId}");
                  room_name= getValidString(teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomId);
                  // print("room_check_length==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  break;
                }
              }

            }

          }

        }
      }
    }
  Utils().customPrint("room_name=> ${room_name}");
    return getValidString(room_name);
  }

  String getRoomNameChampainShip(String roundId,String lobbyid){
  Utils().customPrint("roundId=> ${roundId}");
  Utils().customPrint("lobbyid=> ${lobbyid}");
    String room_name="";
   // print("users_lenght==>${users.length}");
    if(users!=null && users.length>0){
      for (int j=0;j<users.length;j++){
        //print("room_check_length==>${users[j].rounds.length}");
        for(int i=0;i< users[j].rounds.length;i++){
        //Utils().customPrint("room_check==>${users[j].rounds[i].roundId}");
          if(roundId==users[j].rounds[i].roundId&& users[j].rounds[i].lobbyId!=null&&lobbyid==users[j].rounds[i].lobbyId.id){
          Utils().customPrint("room_nameloop==>${users[j].rounds[i].lobbyId.roomId}");
            room_name= getValidString(users[j].rounds[i].lobbyId.roomId);
            break;
          }
        }
      }
    }


    if(teams!=null && teams.length>0){
    Utils().customPrint("Type==>teams");
      for (int j=0;j<teams.length;j++){
        if(teams[j].members!=null && teams[j].members.length>0){
          for(int i=0; i<teams[j].members.length;i++){
            if(teams[j].members[i].eventRegistration!=null && teams[j].members[i].eventRegistration.rounds!=null&&
                teams[j].members[i].eventRegistration.rounds.length>0){
              for (int k=0;k<teams[j].members[i].eventRegistration.rounds.length;k++){
                if(teams[j].members[i].eventRegistration.rounds[k].roundId==roundId
                    && teams[j].members[i].eventRegistration.rounds[k].lobbyId!=null&&teams[j].members[i].eventRegistration.rounds[k].lobbyId.id==lobbyid){
                  //Utils().customPrint("room_nameloop==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  room_name= getValidString(teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomId);
                  // print("room_check_length==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  break;
                }
              }

            }

          }

        }
      }
    }

  Utils().customPrint("room_name=> ${room_name}");
    return getValidString(room_name);
  }

  String getRoompasswordChampainShip(String roundId,String lobbyid){
    // print("roundId=> ${roundId}");
    String room_name="";
    //Utils().customPrint("users_lenght==>${users.length}");
    if(users!=null && users.length>0){
    Utils().customPrint("Type==>USER");
      for (int j=0;j<users.length;j++){
        //Utils().customPrint("room_check_length==>${users[j].rounds.length}");
        if(users[j].rounds!=null&& users[j].rounds.length>0){
          for(int i=0;i< users[j].rounds.length;i++){
           // print("room_check==>${users[j].rounds[i].roundId}");

            if(roundId==users[j].rounds[i].roundId &&users[j].rounds[i].lobbyId!=null&&users[j].rounds[i].lobbyId.id==lobbyid){
              Utils().customPrint("room_password_solo==>${users[j].rounds[i].lobbyId.roundId}");
                room_name= getValidString(users[j].rounds[i].lobbyId.getRoomPassword());
                break;
            }
          }
        }
      }
    }

    if(teams!=null && teams.length>0){
    Utils().customPrint("Type==>teams");
      for (int j=0;j<teams.length;j++){
        if(teams[j].members!=null && teams[j].members.length>0){
          for(int i=0; i<teams[j].members.length;i++){
            if(teams[j].members[i].eventRegistration!=null && teams[j].members[i].eventRegistration.rounds!=null&&
                teams[j].members[i].eventRegistration.rounds.length>0){
              for (int k=0;k<teams[j].members[i].eventRegistration.rounds.length;k++){
                if(teams[j].members[i].eventRegistration.rounds[k].roundId==roundId&&
                    teams[j].members[i].eventRegistration.rounds[k].lobbyId!=null&&teams[j].members[i].eventRegistration.rounds[k].lobbyId.id==lobbyid){
                  //Utils().customPrint("room_nameloop==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  room_name= getValidString(teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword);
                  // print("room_check_length==>${teams[j].members[i].eventRegistration.rounds[k].lobbyId.roomPassword}");
                  break;
                }
              }

            }

          }

        }
      }
    }
  Utils().customPrint("password=> ${room_name}");
    return getValidString(room_name);
  }


  LobbyId getLobbyInfo(String roundId,String lobbyid){
    LobbyId lobbyinfo=null;
    if(users!=null && users.length>0){
    Utils().customPrint("Type==>USER");
      for (int j=0;j<users.length;j++){
        //Utils().customPrint("room_check_length==>${users[j].rounds.length}");
        if(users[j].rounds!=null&& users[j].rounds.length>0){
          for(int i=0;i< users[j].rounds.length;i++){
            if(roundId==users[j].rounds[i].roundId &&users[j].rounds[i].lobbyId!=null&&users[j].rounds[i].lobbyId.id==lobbyid){
              lobbyinfo=users[j].rounds[i].lobbyId;
              break;
            }
          }
        }
      }
    }

    if(teams!=null && teams.length>0){
    Utils().customPrint("Type==>teams");
      for (int j=0;j<teams.length;j++){
        if(teams[j].members!=null && teams[j].members.length>0){
          for(int i=0; i<teams[j].members.length;i++){
            if(teams[j].members[i].eventRegistration!=null && teams[j].members[i].eventRegistration.rounds!=null&&
                teams[j].members[i].eventRegistration.rounds.length>0){
              for (int k=0;k<teams[j].members[i].eventRegistration.rounds.length;k++){
                if(teams[j].members[i].eventRegistration.rounds[k].roundId==roundId&&
                    teams[j].members[i].eventRegistration.rounds[k].lobbyId!=null&&teams[j].members[i].eventRegistration.rounds[k].lobbyId.id==lobbyid){
                  lobbyinfo=teams[j].members[i].eventRegistration.rounds[k].lobbyId;
                  break;
                }
              }
            }
          }
        }
      }
    }
    return lobbyinfo;
  }




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}
class Users {
  String id;
  String eventId;
  bool isWinner;
  bool winningCredited;
  UserId userId;
  List<Rounds> rounds;
  PrizeAmount prizeAmount;

  Users({this.id, this.eventId, this.isWinner, this.winningCredited, this.rounds,this.userId,this.prizeAmount});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    prizeAmount = json['prizeAmount'] != null ? new PrizeAmount.fromJson(json['prizeAmount']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    return data;
  }
}
class Teams {
  List<Members> members;
  TeamId teamId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String status;

  Teams(
      {
        this.members,
        this.teamId,
        this.isWinner,
        this.winningCredited,
        this.rounds,
        this.status});

  Teams.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    teamId =
    json['teamId'] != null ? new TeamId.fromJson(json['teamId']) : null;
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.teamId != null) {
      data['teamId'] = this.teamId.toJson();
    }
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}
class Members {
  EventRegistration eventRegistration;
  UserId userId;

  Members({this.eventRegistration, this.userId});

  Members.fromJson(Map<String, dynamic> json) {
    eventRegistration = json['eventRegistration'] != null
        ? new EventRegistration.fromJson(json['eventRegistration'])
        : null;
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventRegistration != null) {
      data['eventRegistration'] = this.eventRegistration.toJson();
    }
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    return data;
  }
}
class EventRegistration {
  String id;
  String userId;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String teamId;
  String status;
  String createdAt;
  String updatedAt;
  PrizeAmount prizeAmount;

  EventRegistration(
      {this.id,
        this.userId,
        this.eventId,
        this.isWinner,
        this.winningCredited,
        this.rounds,
        this.prizeAmount,
        this.teamId,
        this.status,
        this.createdAt,
        this.updatedAt});

  EventRegistration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    prizeAmount = json['prizeAmount'] != null ? new PrizeAmount.fromJson(json['prizeAmount']) : null;
    teamId = json['teamId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
class Name {
  String first;
  String last;

  Name({this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}

class TeamId {
  String id;
  String name;

  TeamId({this.id, this.name});

  TeamId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Rounds {
  String roundId;
  LobbyId lobbyId;
  bool isWinner;
  int rank;
  int teamRank;
  Result result;
  String sId;


  Rounds(
      {this.roundId,
        this.lobbyId,
        this.isWinner,
        this.rank,
        this.teamRank,
        this.sId});

  Rounds.fromJson(Map<String, dynamic> json) {
    roundId = json['roundId'];
    lobbyId =
    json['lobbyId'] != null ? new LobbyId.fromJson(json['lobbyId']) : null;
    isWinner = json['isWinner'];
    rank = json['rank'];
    teamRank = json['teamRank'];
    result=json['result'] != null ? new Result.fromJson(json['result']) : null;
    sId = json['_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roundId'] = this.roundId;
    if (this.lobbyId != null) {
      data['lobbyId'] = this.lobbyId.toJson();
    }
    data['isWinner'] = this.isWinner;
    data['rank'] = this.rank;
    data['teamRank'] = this.teamRank;
    data['_id'] = this.sId;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}
class Result{
  int score;
  int rank;
  int kill;
  int getRank(){
    if(this.rank==null){
      return 0;
    }
    return this.rank;

  }
  Result.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    rank = json['rank'] ;
    kill = json['kill'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['rank'] = this.rank;
    data['kill'] = this.kill;

    return data;
  }

}
class Pagination {
  int offset;
  int total;
  int count;
  int limit;

  Pagination({this.offset, this.total, this.count, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    total = json['total'];
    count = json['count'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['count'] = this.count;
    data['limit'] = this.limit;
    return data;
  }
}
