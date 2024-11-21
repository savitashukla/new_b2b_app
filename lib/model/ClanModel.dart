import 'package:gmng/model/basemodel/AppBaseModel.dart';

class ClanModel extends AppBaseModel {
  String id,
      name,
      description,
      referCode,
      discordUrl,
      youTubeUrl,
      instagramUrl,
      shareUrl;
  bool is_slected=false;
  ClanBanner banner;
  JoinedUser joinSummary;
  String getvalidYouTubeLink(){
    return getValidString(this.youTubeUrl);
  }
  String getvalidInstagramLink(){
    return getValidString(this.instagramUrl);
  }
  String getvalidDisCordUrl(){
    return getValidString(this.discordUrl);
  }
  ClanModel({
    this.id,
    this.name,
    this.description,
    this.referCode,
    this.discordUrl,
    this.youTubeUrl,
    this.instagramUrl,
    this.shareUrl,
    this.banner,
    this.is_slected,
    this.joinSummary,
  });

  ClanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    referCode = json['referCode'];
    discordUrl = json['discordUrl'];
    youTubeUrl = json['youTubeUrl'];
    instagramUrl = json['instagramUrl'];
    shareUrl = json['shareUrl'];
    is_slected = json['is_slected']==null?false:true;
    banner =
        json['banner'] != null ? new ClanBanner.fromJson(json['banner']) : null;
    joinSummary =
    json['joinSummary'] != null ? new JoinedUser.fromJson(json['joinSummary']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['referCode'] = this.referCode;
    data['discordUrl'] = this.discordUrl;
    data['youTubeUrl'] = this.youTubeUrl;
    data['instagramUrl'] = this.instagramUrl;
    data['shareUrl'] = this.shareUrl;
    data['banner'] = this.banner;
    data['is_slected'] = this.is_slected;
    data['joinSummary'] = this.joinSummary;
    return data;
  }
}

class JoinedUser extends AppBaseModel{
  int users;
  JoinedUser({this.users});
  JoinedUser.fromJson(Map<String, dynamic> json) {
    users = json['users'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['users'] = this.users;
    return data;
  }
}

class ClanBanner extends AppBaseModel {
  String id;
  String url;

  ClanBanner({this.id, this.url});

  ClanBanner.fromJson(Map<String, dynamic> json) {
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
