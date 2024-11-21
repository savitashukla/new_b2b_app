class SliderModel{

  var id,link,zoneId,linkType,linkUrlType,catId,subCatId,vendorProductId,title,image;

  static SliderModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SliderModel dataBean = SliderModel();
    dataBean.id = map['id'];
    dataBean.link = map['link'];
    dataBean.zoneId = map['zoneId'];
    dataBean.linkType = map['linkType'];
    dataBean.linkUrlType = map['linkUrlType'];
    dataBean.catId = map['catId'];
    dataBean.subCatId = map['subCatId'];
    dataBean.vendorProductId = map['vendorProductId'];
    dataBean.title = map['title'];
    dataBean.image = map['image'];

    return dataBean;
  }
  Map toJson() => {
      "id": id,
      "link":link,
      "zoneId":zoneId,
      "linkType":linkType,
      "linkUrlType":linkUrlType,
      "catId":catId,
      "subCatId":subCatId,
      "vendorProductId":vendorProductId,
      "title":title,
      "image":image,


  };

}