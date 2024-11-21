class TeamTypeModelR {
  List<TeamTypeModel> data;

  TeamTypeModelR({this.data});
  Map<String, dynamic> jso={"id":"0","size":2,"name":"All Team Type"};
  TeamTypeModelR.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TeamTypeModel>();
      data.add(new TeamTypeModel.fromJson(jso));
      json['data'].forEach((v) {
        data.add(new TeamTypeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamTypeModel {
  String id;
  String name;
  int size;
  String status;
  TeamTypeModel(
      {this.id,
        this.name,
        this.size,
        this.status});

  TeamTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    size = json['size'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['size'] = this.size;
    data['status'] = this.status;
    return data;
  }
}
