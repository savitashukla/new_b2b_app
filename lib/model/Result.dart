import 'package:gmng/model/basemodel/AppBaseModel.dart';

class Result  extends AppBaseModel{
  int score;
  int rank;
  int kill;

  Result({this.score, this.rank, this.kill});

  Result.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    rank = json['rank'];
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