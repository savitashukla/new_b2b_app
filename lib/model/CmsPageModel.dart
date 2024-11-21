
class CmsPageModel{

  var id,name,description;


  static CmsPageModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CmsPageModel dataBean = CmsPageModel();
    dataBean.id = map['id'];
    dataBean.name = map['name'];
    dataBean.description = map['description'];


    return dataBean;
  }

  Map toJson() => {
      "id": id,
      "name":name,
      "description":description,
  };

}