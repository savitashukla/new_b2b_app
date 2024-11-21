class PropertyGallery {
    int id;
    int propertyId;
    String image;
    int adminStatus;

    PropertyGallery({this.id, this.propertyId, this.image, this.adminStatus});

    PropertyGallery.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        propertyId = json['property_id'];
        image = json['image'];
        adminStatus = json['admin_status'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['property_id'] = this.propertyId;
        data['image'] = this.image;
        data['admin_status'] = this.adminStatus;
        return data;
    }

}