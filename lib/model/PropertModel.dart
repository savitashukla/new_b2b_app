
import 'package:gmng/model/PropertyFeature.dart';
import 'package:gmng/model/PropertyGallery.dart';
import 'package:gmng/model/PropertyLocation.dart';

class PropertModel{

  var id,agentId,title,description,type,propertyType,location,bedrooms,bathrooms,floors,garages,area,
      rentPrice,currencycode,before_price_labe,prpertyId,videoUrl,after_price_label;
  PropertyFeature propertyFeature;
  PropertyLocation propertyLocation;
  List<PropertyGallery> propertyGallery;

  static PropertModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PropertModel dataBean = PropertModel();

    dataBean.id = map['id'];
    dataBean.agentId = map['agentId'];
    dataBean.title = map['title'];
    dataBean.description = map['description'];
    dataBean.type = map['type'];
    dataBean.propertyType = map['propertyType'];
    dataBean.location = map['location'];
    dataBean.bedrooms = map['bedrooms'];
    dataBean.bathrooms = map['bathrooms'];
    dataBean.floors = map['floors'];
    dataBean.garages = map['garages'];
    dataBean.area = map['area'];
    dataBean.rentPrice = map['rentPrice'];
    dataBean.currencycode = map['currencycode'];
    dataBean.before_price_labe = map['before_price_labe'];
    dataBean.after_price_label = map['after_price_label'];
    dataBean.prpertyId = map['prpertyId'];
    dataBean.videoUrl = map['videoUrl'];
    dataBean.propertyFeature = map['property_feature'] != null
        ? new PropertyFeature.fromJson(map['property_feature'])
        : null;
    dataBean.propertyLocation = map['property_location'] != null
        ? new PropertyLocation.fromJson(map['property_location'])
        : null;
    if (map['property_gallery'] != null) {
      dataBean.propertyGallery = new List<PropertyGallery>();
      map['property_gallery'].forEach((v) {
        dataBean.propertyGallery.add(new PropertyGallery.fromJson(v));
      });
    }

    return dataBean;
  }

  Map toJson() => {
      "id": id,
      "agentId":agentId,
      "title":title,
      "description":description,
      "type":type,
      "propertyType":propertyType,
      "location":location,
      "bedrooms":bedrooms,
      "bathrooms":bathrooms,
      "floors":floors,
      "garages":garages,
      "area":area,
      "currencycode":currencycode,
      "before_price_labe":before_price_labe,
      "after_price_label":after_price_label,
      "prpertyId":prpertyId,
      "videoUrl":videoUrl,

  };

  @override
  String toString() {
    // TODO: implement toString
    return title+"";
  }

}