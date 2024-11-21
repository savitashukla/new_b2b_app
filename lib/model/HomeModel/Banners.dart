import 'HomePageListModel.dart';

class Banners {
  String id;
  Banner image;
  String category;
  String type;
  String name;
  String externalUrl;
  String gameId;
  String eventId;

  Banners(
      {this.id,
        this.image,
        this.category,
        this.type,
        this.name,
        this.externalUrl,
        this.gameId,
        this.eventId});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? new Banner.fromJson(json['image']) : null;
    category = json['category'];
    type = json['type'];
    name = json['name'];
    externalUrl = json['externalUrl'];
    gameId = json['gameId'];
    eventId = json['eventId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['category'] = this.category;
    data['type'] = this.type;
    data['name'] = this.name;
    data['externalUrl'] = this.externalUrl;
    data['gameId'] = this.gameId;
    data['eventId'] = this.eventId;
    return data;
  }
}