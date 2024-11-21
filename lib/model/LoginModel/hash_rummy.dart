class RummyModel {
   String user_id ,
   name ,
   state ,
   country ,
   session_key ,
   timestamp ,
   client_id,
   hash ;

   RummyModel({this.user_id, this.name, this.state, this.country,this.session_key,this.timestamp,this.client_id,this.hash});

   RummyModel.fromJson(Map<String, dynamic> json) {
     user_id = json['user_id'];
     name = json['name'];
     state = json['state'];
     country = json['country'];
     session_key = json['session_key'];
     timestamp = json['timestamp'];
     client_id = json['client_id'];
     hash = json['hash'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['name'] = this.name;
    data['state'] = this.state;
    data['country'] = this.country;
    data['session_key'] = this.session_key;
    data['timestamp'] = this.timestamp;
    data['client_id'] = this.client_id;
    data['hash'] = this.hash;
    return data;
  }
}
