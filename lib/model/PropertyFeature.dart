class PropertyFeature {
    var balcony;
    var center_cooling;
    var dish_washer;
    var dryer;
    var elevator;
    var fire_alarm;
    var gym;
    var heating;
    var id;
    var modern_kitchen;
    var pet_frindly;
    var pool;
    var property_id;
    var sauna;

    PropertyFeature({this.balcony, this.center_cooling, this.dish_washer, this.dryer, this.elevator, this.fire_alarm, this.gym, this.heating, this.id, this.modern_kitchen, this.pet_frindly, this.pool, this.property_id, this.sauna});

    factory PropertyFeature.fromJson(Map<String, dynamic> json) {
        return PropertyFeature(
            balcony: json['balcony'], 
            center_cooling: json['center_cooling'], 
            dish_washer: json['dish_washer'], 
            dryer: json['dryer'], 
            elevator: json['elevator'], 
            fire_alarm: json['fire_alarm'], 
            gym: json['gym'], 
            heating: json['heating'], 
            id: json['id'], 
            modern_kitchen: json['modern_kitchen'], 
            pet_frindly: json['pet_frindly'], 
            pool: json['pool'], 
            property_id: json['property_id'], 
            sauna: json['sauna'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['balcony'] = this.balcony;
        data['center_cooling'] = this.center_cooling;
        data['dish_washer'] = this.dish_washer;
        data['dryer'] = this.dryer;
        data['elevator'] = this.elevator;
        data['fire_alarm'] = this.fire_alarm;
        data['gym'] = this.gym;
        data['heating'] = this.heating;
        data['id'] = this.id;
        data['modern_kitchen'] = this.modern_kitchen;
        data['pet_frindly'] = this.pet_frindly;
        data['pool'] = this.pool;
        data['property_id'] = this.property_id;
        data['sauna'] = this.sauna;
        return data;
    }
}