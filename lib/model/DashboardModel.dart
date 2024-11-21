import 'package:gmng/model/BannerModel.dart';
import 'package:gmng/model/GameModel.dart';

class DashboardModel {
    List<BannerModel> banner;
    List<GameModel> livegamelist;
    List<GameModel> casualgamelist;
    List<GameModel> upcominggamelist;

     DashboardModel fromMap(Map<String, dynamic> map) {
        if (map == null) return null;
        DashboardModel dataBean = DashboardModel();
        dataBean.banner = List()..addAll(
            (map['banner'] as List ?? []).map((o) => BannerModel.fromMap(o))
        );
        dataBean.livegamelist = List()..addAll(
            (map['livegamelist'] as List ?? []).map((o) => GameModel.fromJson(o))
        );
        dataBean.casualgamelist =List()..addAll(
            (map['casualgamelist'] as List ?? []).map((o) => GameModel.fromJson(o))
        );
        dataBean.upcominggamelist =List()..addAll(
            (map['upcominggamelist'] as List ?? []).map((o) => GameModel.fromJson(o))
        );

        return dataBean;
    }

    Map toJson() => {
        "banner": banner,
       "livegamelist": livegamelist,
       "casualgamelist": casualgamelist,
       "upcominggamelist": upcominggamelist,
    };

    @override
    String toString() {
        // TODO: implement toString
        return banner.length.toString()+"";
    }

}