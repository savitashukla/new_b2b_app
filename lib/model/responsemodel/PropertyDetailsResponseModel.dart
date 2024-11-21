class PropertyDetailsResponseModel {
  int code;
  bool error;
  Data data;
  String message;

  PropertyDetailsResponseModel(
      {this.code, this.error, this.data, this.message});

  PropertyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  int agentId;
  String title;
  String description;
  String type;
  var propertyType;
  String location;
  String bedrooms;
  String bathrooms;
  String floors;
  String garages;
  String area;
  String rentPrice;
  int currencycode;
  String beforePriceLabe;
  String afterPriceLabel;
  String prpertyId;
  String videoUrl;
  int adminStatus;
  User user;
  PropertyFeature propertyFeature;
  PropertyLocation propertyLocation;
  List<PropertyGallery> propertyGallery;

  Data(
      {this.id,
        this.agentId,
        this.title,
        this.description,
        this.type,
        this.propertyType,
        this.location,
        this.bedrooms,
        this.bathrooms,
        this.floors,
        this.garages,
        this.area,
        this.rentPrice,
        this.currencycode,
        this.beforePriceLabe,
        this.afterPriceLabel,
        this.prpertyId,
        this.videoUrl,
        this.adminStatus,
        this.user,
        this.propertyFeature,
        this.propertyLocation,
        this.propertyGallery});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    propertyType = json['property_type'];
    location = json['location'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    floors = json['floors'];
    garages = json['garages'];
    area = json['area'];
    rentPrice = json['rent_price'];
    currencycode = json['currencycode'];
    beforePriceLabe = json['before_price_labe'];
    afterPriceLabel = json['after_price_label'];
    prpertyId = json['prperty_id'];
    videoUrl = json['video_url'];
    adminStatus = json['admin_status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    propertyFeature = json['property_feature'] != null
        ? new PropertyFeature.fromJson(json['property_feature'])
        : null;
    propertyLocation = json['property_location'] != null
        ? new PropertyLocation.fromJson(json['property_location'])
        : null;
    if (json['property_gallery'] != null) {
      propertyGallery = new List<PropertyGallery>();
      json['property_gallery'].forEach((v) {
        propertyGallery.add(new PropertyGallery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agent_id'] = this.agentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['type'] = this.type;
    data['property_type'] = this.propertyType;
    data['location'] = this.location;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['floors'] = this.floors;
    data['garages'] = this.garages;
    data['area'] = this.area;
    data['rent_price'] = this.rentPrice;
    data['currencycode'] = this.currencycode;
    data['before_price_labe'] = this.beforePriceLabe;
    data['after_price_label'] = this.afterPriceLabel;
    data['prperty_id'] = this.prpertyId;
    data['video_url'] = this.videoUrl;
    data['admin_status'] = this.adminStatus;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.propertyFeature != null) {
      data['property_feature'] = this.propertyFeature.toJson();
    }
    if (this.propertyLocation != null) {
      data['property_location'] = this.propertyLocation.toJson();
    }
    if (this.propertyGallery != null) {
      data['property_gallery'] =
          this.propertyGallery.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int id;

  String name;
  String lname;
  String phoneCode;
  String phoneNumber;
  String email;
  String language;
  String dob;
  Null otp;
  Null gender;
  String image;
  Null aboutMe;
  Null address;
  Null lat;
  Null lng;
  Null currentLat;
  Null currentLng;
  Null deviceId;
  Null deviceToken;
  Null deviceType;
  String role;
  int accessUserId;
  String userType;
  String status;
  int isverified;
  Null deletedAt;
  String createdAt;
  String updatedAt;
  Null membership;
  Null membershipTo;
  String walletAmount;
  Null referral;
  Null referredBy;
  Null referralCode;
  int planId;
  String playInfo;
  String fullName;
  String phone;

  User(
      {this.id,

        this.name,
        this.lname,
        this.phoneCode,
        this.phoneNumber,
        this.email,
        this.language,
        this.dob,
        this.otp,
        this.gender,
        this.image,
        this.aboutMe,
        this.address,
        this.lat,
        this.lng,
        this.currentLat,
        this.currentLng,
        this.deviceId,
        this.deviceToken,
        this.deviceType,
        this.role,
        this.accessUserId,
        this.userType,
        this.status,
        this.isverified,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.membership,
        this.membershipTo,
        this.walletAmount,
        this.referral,
        this.referredBy,
        this.referralCode,
        this.planId,
        this.playInfo,
        this.fullName,
        this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lname = json['lname'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    language = json['language'];
    dob = json['dob'];
    otp = json['otp'];
    gender = json['gender'];
    image = json['image'];
    aboutMe = json['about_me'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    currentLat = json['current_lat'];
    currentLng = json['current_lng'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    role = json['role'];
    accessUserId = json['access_user_id'];
    userType = json['user_type'];
    status = json['status'];
    isverified = json['isverified'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    membership = json['membership'];
    membershipTo = json['membership_to'];
    walletAmount = json['wallet_amount'];
    referral = json['referral'];
    referredBy = json['referred_by'];
    referralCode = json['referral_code'];
    planId = json['planId'];
    playInfo = json['playInfo'];
    fullName = json['full_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['name'] = this.name;
    data['lname'] = this.lname;
    data['phone_code'] = this.phoneCode;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['language'] = this.language;
    data['dob'] = this.dob;
    data['otp'] = this.otp;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['about_me'] = this.aboutMe;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['current_lat'] = this.currentLat;
    data['current_lng'] = this.currentLng;
    data['device_id'] = this.deviceId;
    data['device_token'] = this.deviceToken;
    data['device_type'] = this.deviceType;
    data['role'] = this.role;
    data['access_user_id'] = this.accessUserId;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['isverified'] = this.isverified;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['membership'] = this.membership;
    data['membership_to'] = this.membershipTo;
    data['wallet_amount'] = this.walletAmount;
    data['referral'] = this.referral;
    data['referred_by'] = this.referredBy;
    data['referral_code'] = this.referralCode;
    data['planId'] = this.planId;
    data['playInfo'] = this.playInfo;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    return data;
  }
}

class PropertyFeature {
  int id;
  int propertyId;
  int centerCooling;
  int balcony;
  int dryer;
  int fireAlarm;
  int modernKitchen;
  int sauna;
  int heating;
  int pool;
  int dishWasher;
  int gym;
  int elevator;
  int petFrindly;

  PropertyFeature(
      {this.id,
        this.propertyId,
        this.centerCooling,
        this.balcony,
        this.dryer,
        this.fireAlarm,
        this.modernKitchen,
        this.sauna,
        this.heating,
        this.pool,
        this.dishWasher,
        this.gym,
        this.elevator,
        this.petFrindly});

  PropertyFeature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    centerCooling = json['center_cooling'];
    balcony = json['balcony'];
    dryer = json['dryer'];
    fireAlarm = json['fire_alarm'];
    modernKitchen = json['modern_kitchen'];
    sauna = json['sauna'];
    heating = json['heating'];
    pool = json['pool'];
    dishWasher = json['dish_washer'];
    gym = json['gym'];
    elevator = json['elevator'];
    petFrindly = json['pet_frindly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['center_cooling'] = this.centerCooling;
    data['balcony'] = this.balcony;
    data['dryer'] = this.dryer;
    data['fire_alarm'] = this.fireAlarm;
    data['modern_kitchen'] = this.modernKitchen;
    data['sauna'] = this.sauna;
    data['heating'] = this.heating;
    data['pool'] = this.pool;
    data['dish_washer'] = this.dishWasher;
    data['gym'] = this.gym;
    data['elevator'] = this.elevator;
    data['pet_frindly'] = this.petFrindly;
    return data;
  }
}

class PropertyLocation {
  int id;
  int propertyId;
  String address;
  String country;
  String city;
  String state;
  String zip;
  String neighborhood;
  String latitude;
  String longitude;
  String placeId;
  int adminStatus;

  PropertyLocation(
      {this.id,
        this.propertyId,
        this.address,
        this.country,
        this.city,
        this.state,
        this.zip,
        this.neighborhood,
        this.latitude,
        this.longitude,
        this.placeId,
        this.adminStatus});

  PropertyLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    neighborhood = json['neighborhood'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    placeId = json['place_id'];
    adminStatus = json['admin_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['neighborhood'] = this.neighborhood;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['place_id'] = this.placeId;
    data['admin_status'] = this.adminStatus;
    return data;
  }
}

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
