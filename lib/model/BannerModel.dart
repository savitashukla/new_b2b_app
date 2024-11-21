class BannerModel {
    String banner_name,banner_image,linkname,gamesname,EventName;
    var banner_id,type,gametypeid,eventid,entryfee,WinPrize;


    static BannerModel fromMap(Map<String, dynamic> map) {
        if (map == null) return null;
        BannerModel dataBean = BannerModel();

        dataBean.banner_name = map['banner_name'];
        dataBean.banner_image = map['banner_image'];
        dataBean.linkname = map['linkname'];
        dataBean.banner_id = map['banner_id'];
        dataBean.type = map['type'];
        dataBean.gametypeid = map['gametypeid'];
        dataBean.eventid = map['eventid'];
        dataBean.entryfee = map['entryfee'];
        dataBean.WinPrize = map['WinPrize'];
        dataBean.EventName = map['EventName'];
        return dataBean;
    }

    Map toJson() => {
        "banner_name": banner_name,
        "banner_image": banner_image,
        "banner_id":banner_id,
        "linkname":linkname,
        "type":type,
        "gametypeid":gametypeid,
        "eventid":eventid,
        "entryfee":entryfee,
        "WinPrize":WinPrize,
        "EventName":EventName,


    };

    @override
    String toString() {
        // TODO: implement toString
        return EventName+"";
    }

}