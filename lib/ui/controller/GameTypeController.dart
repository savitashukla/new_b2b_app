import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/HomeModel/ESportModel.dart';
import '../../webservices/WebServicesHelper.dart';

class GameTypeController extends GetxController {
  String user_id;
  var selectedValueGame = "FREEFIRE".obs;

  var teamTypeId = ''.obs;

  String token;
  var esports_model_v = EsportModelR().obs;
  List<Data> esportList = new List<Data>().obs;
  SharedPreferences prefs;
  var only_esport_game_e = EsportModelR().obs;

  var gameListSelectedColor = 0.obs;
  var gameListSelectedColor1 = 0.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    user_id = prefs.getString("user_id");
    getGameType();
    getGameEsportOnly();
  }

  Future<void> getGameType() async {
    //showLoader();
    Map<String, dynamic> response =
        await WebServicesHelper().getGameType(token);
    if (response != null) {
      //  hideLoader();
      esportList.clear();
      esports_model_v.value = EsportModelR.fromJson(response);
      Utils().customPrint("game name id ${esports_model_v.value.data[0].id}");
      selectedValueGame.value = esports_model_v.value.data[0].name;
      for (int i = 0; i < esports_model_v.value.data.length; i++) {
        if (esports_model_v.value.data[i].thirdParty == null &&
            esports_model_v.value.data[i].id != 0) {
          esportList.add(esports_model_v.value.data[i]);
        }
      }
    } else {
      //  hideLoader();
      // Fluttertoast.showToast(msg: "Some Error");
    }
  }

  Future<void> getGameEsportOnly() async {
    only_esport_game_e.value = null;
    Map<String, dynamic> responsestr =
        await WebServicesHelper().only_esport_game(token);
    if (responsestr != null) {
      only_esport_game_e.value = EsportModelR.fromJson(responsestr);
    } else {
      //  Fluttertoast.showToast(msg: "Some Error");
    }
  }
}
