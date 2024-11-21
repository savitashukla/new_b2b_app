class GameModel {
    String banner;
    int clickable;
    String gamesname;
    int gamestypeid;
    String howtoplay;

    GameModel({this.banner, this.clickable, this.gamesname, this.gamestypeid, this.howtoplay});

    factory GameModel.fromJson(Map<String, dynamic> json) {
        return GameModel(
            banner: json['banner'], 
            clickable: json['clickable'], 
            gamesname: json['gamesname'], 
            gamestypeid: json['gamestypeid'], 
            howtoplay: json['howtoplay'], 
          //  map: json['map'] != null ? (json['map'] as List).map((i) => Map.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['banner'] = this.banner;
        data['clickable'] = this.clickable;
        data['gamesname'] = this.gamesname;
        data['gamestypeid'] = this.gamestypeid;
        data['howtoplay'] = this.howtoplay;
        // if (this.map != null) {
        //     data['map'] = this.map.map((v) => v.toJson()).toList();
        // }
        return data;
    }
}