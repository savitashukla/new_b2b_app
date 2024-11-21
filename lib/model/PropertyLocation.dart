class PropertyLocation {
    var address;
    var admin_status;
    var city;
    var country;
    var id;
    var latitude;
    var longitude;
    var neighborhood;
    var place_id;
    var property_id;
    var state;
    var zip;

    PropertyLocation({this.address, this.admin_status, this.city, this.country, this.id, this.latitude, this.longitude, this.neighborhood, this.place_id, this.property_id, this.state, this.zip});

    factory PropertyLocation.fromJson(Map<String, dynamic> json) {
        return PropertyLocation(
            address: json['address'], 
            admin_status: json['admin_status'], 
            city: json['city'] != null ? json['city'] : "",
            country: json['country'] != null ? json['country'] : "",
            id: json['id'], 
            latitude: json['latitude'], 
            longitude: json['longitude'], 
            neighborhood: json['neighborhood'] != null ? json['neighborhood'] : "",
            place_id: json['place_id'], 
            property_id: json['property_id'], 
            state: json['state'] != null ? json['state']: "",
            zip: json['zip'] != null ? json['zip']: "",
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['admin_status'] = this.admin_status;
        data['id'] = this.id;
        data['latitude'] = this.latitude;
        data['longitude'] = this.longitude;
        data['place_id'] = this.place_id;
        data['property_id'] = this.property_id;
        if (this.city != null) {
            data['city'] = this.city.toJson();
        }
        if (this.country != null) {
            data['country'] = this.country.toJson();
        }
        if (this.neighborhood != null) {
            data['neighborhood'] = this.neighborhood.toJson();
        }
        if (this.state != null) {
            data['state'] = this.state.toJson();
        }
        if (this.zip != null) {
            data['zip'] = this.zip.toJson();
        }
        return data;
    }
}