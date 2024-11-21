import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/login/Login.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/basemodel/AppBaseErrorResponse.dart';
import '../ui/controller/EditProfileController.dart';
import '../ui/controller/ProfileController.dart';
import '../ui/main/team_management/TeamManagementNew.dart';
import '../utills/event_tracker/CleverTapController.dart';
import '../utills/event_tracker/EventConstant.dart';
import 'ApiUrl.dart';

class WebServicesHelper {
  EditProfileController editProfilecontroller =
      Get.put(EditProfileController());

  Future<Map<String, dynamic>> getUserLogin(Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    Utils().customPrint("param login$param");
    Utils().customPrint("login  url => ${ApiUrl.API_URL_LOGIN}");

    try {
      final response = await http.post(Uri.parse('${ApiUrl.API_URL_LOGIN}'),
          body: json.encode(param),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
          });
      Utils().customPrint("response login====" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Utils().customPrint('Login test 46');
        //Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
        return null;
      } else if (response.statusCode == 400) {
        final res = json.decode(response.body.toString());
        Utils().customPrint('Login test 51');
        Fluttertoast.showToast(msg: "${res["error"]}");
        return null;
      } else {
        final res = json.decode(response.body.toString());
        Fluttertoast.showToast(msg: "${res["error"]}");
        //Fluttertoast.showToast(msg: "Some Error");
        return null;
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getInGamePost(Map<String, dynamic> param,
      String token, String user_id, String game_id) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    // param['isPlayStore']=ApiUrl().isPlayStore;
    Utils().customPrint("aa gaya$param");

    final response = await http.post(
        Uri.parse(
            '${ApiUrl().API_URL_IN_GAME_CHECK}${'$user_id'}/game/${game_id}/ingame/'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "InGame Data already added");
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> getFacebookEvent(
      Map<String, dynamic> param, String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    // param['isPlayStore']=ApiUrl().isPlayStore;
    Utils().customPrint("aa gaya facebook event ${[param]}");

    try {
      if (token != null) {
        final response = await http.post(
            Uri.parse('${ApiUrl().API_URL_FACEBOOK_EVENT}'),
            body: json.encode([param]),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "BasicAuth": AppString().header_Token,
              'Authorization': 'Bearer $token',
            });
        Utils().customPrint("response facebook ====" + '${response.body}');
        Utils().customPrint(
            "response Code facebook ====" + '${response.statusCode}');
        //   Fluttertoast.showToast(msg: "response ${response.statusCode}");

        if (response != null) {
          if (response.statusCode == 200) {
            return null;
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> updateIngameId(Map<String, dynamic> param,
      String token, String user_id, String game_id, String inGameId) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    // param['isPlayStore']=ApiUrl().isPlayStore;
    Utils().customPrint("aa gaya$param");
    Utils().customPrint(
        "update in game id => ${ApiUrl().API_URL_IN_GAME_CHECK}${'$user_id'}/game/${game_id}/ingame/$inGameId");
    final response = await http.patch(
        Uri.parse(
            '${ApiUrl().API_URL_IN_GAME_CHECK}${'$user_id'}/game/${game_id}/ingame/$inGameId'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getInGameCheck(
      String token, String user_id, String game_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("game in id ${token}${user_id} game id ${game_id}");
    Utils().customPrint(
        "url => ${ApiUrl().API_URL_IN_GAME_CHECK}${'$user_id'}/game/${game_id}/ingame/");

    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse(
              '${ApiUrl().API_URL_IN_GAME_CHECK}${'$user_id'}/game/${game_id}/ingame/'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );

        Utils().customPrint("response in game${response.body}");

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            LogOut(true, response);
            return null;
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getUserBanner(
      String token, String bannerType) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint("banner reword");

    String url = "";

    if (ApiUrl().isPlayStore) {
      url =
          '${ApiUrl.API_URL_BANNER}?category=$bannerType&status=active&isPlayStore=${ApiUrl().isPlayStore}';
    } else {
      url = '${ApiUrl.API_URL_BANNER}?category=$bannerType&status=active';
    }
    Utils().customPrint('banner reword ${url}');
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${url}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("banner reword response $response");

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            LogOut(true, response);
            return null;
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getHomePage(String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String url = "";
    if (ApiUrl().isPlayStore) {
      url = ApiUrl().API_URL_HOME_PAGE +
          '?isPlayStore=${ApiUrl().isPlayStore}&appTypes=website';
    } else {
      url = ApiUrl().API_URL_HOME_PAGE + '?appTypes=website';
    }
    Utils().customPrint('home url -> ${url}');

    try {
      final response = await http.get(
        Uri.parse('${url}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("response home page====" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getCreateKYC(
      var payload, var path_call, String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("Url=> ${ApiUrl.API_URL}${'user/$user_id/kyc'}");

    try {
      var postUri = Uri.parse('${ApiUrl.API_URL}${'user/$user_id/kyc'}');
      var request = new http.MultipartRequest("POST", postUri);
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      };
      request.headers.addAll(headers);
      request.fields['type'] = payload['type'];
      request.fields['subType'] = payload['subType'];
      request.files.add(await http.MultipartFile.fromPath(
        "image",
        path_call,
        contentType: new MediaType('image', 'png'),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();

        return json.decode(respStr);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        final respStr = await response.stream.bytesToString();

        try {
          final resD = json.decode(respStr);
          if (resD["error"] != null) {
            Fluttertoast.showToast(msg: "${resD["error"]}");
            Utils()
                .customPrint("ERROR ::::::::::::::::::::::  ${resD["error"]}");
            return null;
          } else {
            Fluttertoast.showToast(msg: "Response $respStr");
            return json.decode(respStr);
          }
        } catch (E) {}
        return null;
      }
    } catch (e) {}
  }

  Future<http.Response> checkInvoidAadharcard(var payload) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint("url => ${ApiUrl().API_URL_INVOID_AADAHAR}");
    Utils().customPrint("payload => ${payload}");
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_INVOID_AADAHAR}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": 'application/json',
        "authkey": ApiUrl().INVOID_AUTH_KEY,
        // "BasicAuth": AppString().header_Token,
        'Authorization': Utils()
            .getBasicAuth(ApiUrl().INVOID_USERNAME, ApiUrl().INVOID_PASSWORD),
      },
    );
    Utils().customPrint("checkInvoidAadharcard====" + '${response.body}');
    Utils()
        .customPrint("checkInvoidAadharcard ====" + '${response.statusCode}');

    return response;
  }

  Future<Map<String, dynamic>> updateUserProfile(
      var payload, var path_call, String token, String user_id) async {
    var postUri = Uri.parse('${ApiUrl().API_URL_USER}$user_id');
    Utils().customPrint("Token ====> Bearer Edit $token");
    var request = new http.MultipartRequest("PATCH", postUri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      "BasicAuth": AppString().header_Token,
      'Authorization': 'Bearer $token',
    };
    Utils().customPrint("fname==>" + payload["name[first]"]);
    Utils().customPrint("last==>" + payload["name[last]"]);
    Utils().customPrint("about==>" + payload["about"]);
    Utils().customPrint("email[address]==>" + payload["email[address]"]);
    Utils().customPrint("discordId==>" + payload["discordId"]);
    request.headers.addAll(headers);
    request.fields['name[first]'] = payload["name[first]"];
    request.fields['name[last]'] = payload["name[last]"];
    request.fields['about'] = payload["about"];
    request.fields['email[address]'] = payload["email[address]"];
    request.fields['discordId'] = payload["discordId"];
    request.fields['fcmId'] = "ghjhiuh";
    if (path_call != null) {
      request.files.add(await http.MultipartFile.fromPath(
        "file",
        path_call,
        contentType: new MediaType('file', 'png'),
      ));
    }

    Utils().customPrint("Request data==>" + request.toString());
    Utils().customPrint("Request url==>" + postUri.toString());

    await request.send().then((response) async {
      Utils().customPrint("response ===>${response}");
      Utils().customPrint("response.statusCode ===>${response.statusCode}");
      if (response.statusCode == 200) {
        editProfilecontroller.btnControllerProfile.value.success();
        editProfilecontroller.btnControllerProfile.value.reset();
        response.stream.transform(utf8.decoder).listen((value) {
          Utils().customPrint("update profile200---" + value);
          return json.decode(value.toString());
        });
        Utils.showCustomTosstError("success");
        return json.decode(response.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /*SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        Utils.showCustomTosstError("Some Error");
        editProfilecontroller.btnControllerProfile.value.reset();
        response.stream.transform(utf8.decoder).listen((value) {
          Utils().customPrint("update profile error ---" + value);
          return null;
        });
        return null;
      }
    }).catchError((e) {
      editProfilecontroller.btnControllerProfile.value.reset();
      Utils().customPrint(e);

      return null;
    });
  }

  Future<Map<String, dynamic>> getVersion_Update(
      String token, String type, String platform) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String url = ApiUrl().Version_Update_Api + "app-version?isCurrent=true";
    if (!type.isEmpty) {
      url = url + "&type=${type}";
    }
    if (!platform.isEmpty) {
      url = url + "&platform=${platform}";
    }
    Utils().customPrint("URL IS=> ${url}");

    try {
      if (token != null && type != null && platform != null) {
        final response = await http.get(
          Uri.parse('${url}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );

        Utils().customPrint('version update r ${response.body}');
        if (response.statusCode == 200) {
          return json.decode(response.body.toString());
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getGameType(String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      return null;
    }
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${ApiUrl().API_URL_GAME}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint(" game type url  ${ApiUrl().API_URL_GAME}}");

        Utils().customPrint(" game type ${response.body}");
        if (response.statusCode == 200) {
          return json.decode(response.body.toString());
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> only_esport_game(String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${ApiUrl().API_URL_GAME_ESport}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint(" game type url  ${ApiUrl().API_URL_GAME}}");

        Utils().customPrint(" game type ${response.body}");
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getTeams(
      String token,
      String User_id,
      String invite,
      String game_id_c,
      String team_id,
      String isCaptain,
      String newTeam) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    String url =
        "${ApiUrl.API_URL}${'user/$User_id'}/team?expand=gameId,members.userId,teamTypeId";
    if (!invite.isEmpty) {
      url = url + "&${invite}";
    }
    if (!game_id_c.isEmpty) {
      url = url + "&${game_id_c}";
    }
    if (!team_id.isEmpty) {
      url = url + "&${team_id}";
    }
    if (!isCaptain.isEmpty) {
      url = url + "&${isCaptain}";
    }
    if (!newTeam.isEmpty) {
      url = url + "&${newTeam}";
    }

    Utils().customPrint(' invite api ${url}');

    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${url}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint('get teams url ${url}');
        Utils().customPrint("invite team management====" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getTeamsDetails(
    String token,
    String User_id,
    String teamList_id,
  ) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    final response = await http.get(
      Uri.parse(
          '${ApiUrl.API_URL}${'user/$User_id'}/team/$teamList_id?expand=gameId,members.userId,teamTypeId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("token key $token");
    Utils().customPrint(
        'get teams url ${ApiUrl.API_URL}${'user/$User_id'}/team/$teamList_id?expand=gameId,members.userId,teamTypeId');
    Utils().customPrint("response team details====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getRegistrationMemberJoinedCheck(
    String token,
    String User_id,
    String eventId,
  ) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    final response = await http.get(
      Uri.parse(
          '${ApiUrl.API_URL}/user/$User_id/event/$eventId/registration?expand=teamId,userId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("token key $token");
    Utils().customPrint(
        '${ApiUrl.API_URL}/user/$User_id/event/$eventId/registration?expand=teamId,userId');
    Utils().customPrint("response team details====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getRegistrationMemberList(
    String token,
    String User_id,
    String eventId,
  ) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/

    Utils().customPrint(
        "url affiliated ${"${ApiUrl.API_URL}user/$User_id/event/$eventId/registration?expand=teamId,userId,rounds.lobbyId"}");

    final response = await http.get(
      Uri.parse(
          '${ApiUrl.API_URL}user/$User_id/event/$eventId/registration?expand=teamId,userId,rounds.lobbyId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    )

        /*await http.get(
      Uri.parse(
          '${ApiUrl.API_URL}event/$eventId/registrations?expand=teamId,userId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    )*/
        ;
    Utils().customPrint("token key $token");

    Utils().customPrint("response team details====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getAddTeamMember(
      var payload, String token, String user_id, String team_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("Add team memeber ${payload} $user_id");
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/team/$team_id/member'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("Add team   ====" + '${response.body}');
    Utils().customPrint("Add team Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        Utils().showErrorMessage("", "Successful Added New Member");
        ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        Map<String, dynamic> data = json.decode(response.body.toString());
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(data);
        Utils().showErrorMessage("", appBaseErrorModel.error);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getDeleteTeamMember(
      String token, String user_id, String team_id, String member_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("DELETE USER  $user_id $member_id $team_id");
    final response = await http.delete(
      Uri.parse(
          '${ApiUrl().API_URL_USER}${'$user_id/team/$team_id/member/$member_id'}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("DELETE USER   ====" + '${response.body}');
    Utils().customPrint("DELETE USER Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        Utils().showErrorMessage("", "Team Member is Deleted");
        ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();
        var map = {"Success": 1};
        // return response.statusCode;
        return map;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /*SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        Map<String, dynamic> data = json.decode(response.body.toString());
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(data);
        Utils().showErrorMessage("", appBaseErrorModel.error);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getAcceptTeamMember(var payload, String token,
      String user_id, String team_id, String member_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("Accepted USER  $user_id $member_id $team_id");
    final response = await http.patch(
      Uri.parse(
          '${ApiUrl().API_URL_USER}${'$user_id/team/$team_id/member/$member_id'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("Accepted USER   ====" + '${response.body}');
    Utils().customPrint("Accepted USER Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        Utils().showErrorMessage("", "you are accepted the game");
        ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();
        //return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);

        /*SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        Map<String, dynamic> data = json.decode(response.body.toString());
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(data);
        Utils().showErrorMessage("", appBaseErrorModel.error);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getTeamDelete(
      String token, String user_id, String team_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("delete team  $user_id  $team_id");
    final response = await http.delete(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/team/$team_id'}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("delete team   ====" + '${response.body}');
    Utils().customPrint("delete team Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();
        Get.to(() => TeamManagementNew());
        Utils().showErrorMessage("", "Team is Deleted");
        //return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        Map<String, dynamic> data = json.decode(response.body.toString());
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(data);
        Utils().showErrorMessage("", appBaseErrorModel.error);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getRejectedTeamMember(var payload, String token,
      String user_id, String team_id, String member_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("Rejected  $user_id member $member_id $team_id");
    final response = await http.patch(
      Uri.parse(
          '${ApiUrl().API_URL_USER}${'$user_id/team/$team_id/member/$member_id'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("Rejected USER   ====" + '${response.body}');
    Utils().customPrint("Rejected USER Code ====" + '${response.statusCode}');

    if (response != null) {
      if (response.statusCode == 200) {
        ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();
        Utils().showErrorMessage("", "you are rejected the game");

        //return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        Map<String, dynamic> data = json.decode(response.body.toString());
        AppBaseResponseModel appBaseErrorModel =
            AppBaseResponseModel.fromMap(data);
        Utils().showErrorMessage("", appBaseErrorModel.error);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getStoreApi(String token, String game_id) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils()
        .customPrint('Url===>${ApiUrl().API_URL_STORE}$game_id&expand=gameId');
    final response = await http.get(
      Uri.parse('${ApiUrl().API_URL_STORE}$game_id&expand=gameId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );

    Utils().customPrint("response team management====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      Map<String, dynamic> data = json.decode(response.body.toString());
      AppBaseResponseModel appBaseErrorModel =
          AppBaseResponseModel.fromMap(data);
      Utils().showErrorMessage("", appBaseErrorModel.error);
      return null;
    }
  }

  Future<http.Response> getCheckEventVerify(
      var payload, String token, String event_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("pre join event  id  ${payload}   $event_id");
    Utils().customPrint(
        "url => ${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/verify-password'}");
    final response = await http.post(
      Uri.parse(
          '${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/verify-password'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("Check verification====" + '${response.body}');
    Utils().customPrint("Check verification ====" + '${response.statusCode}');

    return response;
    /*if (response != null) {
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else {
        return json.decode(response.body.toString());
      }
    } else {
      return null;
    }*/
  }

  Future<Map<String, dynamic>> getPreEventJoin(
      var payload, String token, String event_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("pre join event  id  ${payload}   $event_id");
    Utils().customPrint(
        "url pre-join-validate  => ${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/pre-join-validate'}");

    try {
      if (token != null && token != '' && event_id != null) {
        final response = await http.post(
          Uri.parse(
              '${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/pre-join-validate'}'),
          body: json.encode(payload),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("response pre join  ====" + '${response.body}');
        Utils().customPrint(
            "response pre join Code ====" + '${response.statusCode}');

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            LogOut(true, response);
            return null;
          } else if (response.statusCode == 504) {
            Utils().customPrint('504 Gateway Time-out 3');
            Fluttertoast.showToast(msg: 'Gateway Time-out, Please try again!');
            return null;
          } else {
            return json.decode(response.body.toString());
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getPreEventJoinGameJob(
      var payload, String token, String event_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("pre join event  id  ${payload}   $event_id");
    Utils().customPrint(
        "url pre-join-validate  => ${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/pre-join-validate'}");
    final response = await http.post(
      Uri.parse(
          '${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/pre-join-validate'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils()
        .customPrint("response pre join Code ====" + '${response.statusCode}');
    Utils().customPrint("response pre join  ====" + '${response.body}');

    if (response != null) {
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /*SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else if (response.statusCode == 504) {
        Utils().customPrint('504 Gateway Time-out 3');
        Fluttertoast.showToast(msg: 'Gateway Time-out, Please try again!');
        return null;
      } else {
        return json.decode(response.body.toString());
      }
    } else {
      return null;
    }
  }

  Future<http.Response> getEventJoin(
      var payload, String token, String event_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(" join event  ${payload}  $event_id");
    Utils().customPrint("token=>   ${token}");
    Utils().customPrint(
        '${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/join-user'}');
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_PRE_JOIN_EVENT}${'$event_id/join-user'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response getEventJoin ====" + '${response.body}');
    Utils().customPrint(
        "response  getEventJoin Code ====" + '${response.statusCode}');
    return response;
  }

  Future<http.Response> AppsflyerData(var payload, String token) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint(" join event  ${payload}  ");
    Utils().customPrint("token=>   ${token}");
    Utils().customPrint('${ApiUrl().API_URL_USER}${'/join-user'}');
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_USER}${'/join-user'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response getEventJoin ====" + '${response.body}');
    Utils().customPrint(
        "response  getEventJoin Code ====" + '${response.statusCode}');
    return response;
  }

  Future<Map<String, dynamic>> getBankDetails(
      var payload, String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(" join event  ${payload}  $user_id");
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/withdrawMethod'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else if (response.statusCode == 404) {
      return json.decode(response.body.toString());
    } else {
      return json.decode(response.body.toString());
    }
    /* } else if (response.statusCode == 401 || response.statusCode == 403) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }*/
  }

  Future<Map<String, dynamic>> getWithdrawal(
      var payload, String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(" getWithdrawal $payload $user_id token $token");
    Utils().customPrint("${ApiUrl().API_URL_USER}${'$user_id/withdrawMethod'}");
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/withdrawMethod'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint(
        " withdrawMethod upi response ${response.body.toString()}");

    final res = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Added Sucessfully");

      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/

      LogOut(true, response);
    }
    /*else if (res["error"] == "ERR1620") {

      UserController userController = Get.find();

      Utils().showPopMiniMumDeposit(userController.appSettingReponse.value.deposit.minAmount);

     // Fluttertoast.showToast(msg: "Please make a ${userController.appSettingReponse.value.deposit.minAmount} deposit to withdraw money from your account");
    }*/
    else if (response.statusCode == 404) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return json.decode(response.body.toString());
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    }
  }

  Future<Map<String, dynamic>> getWithdrawalUpdate(var payload, String token,
      String user_id, String withdrawMethodId) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(" getWithdrawal update $payload $user_id token $token");
    Utils().customPrint(
        "${ApiUrl().API_URL_USER}${'$user_id/withdrawMethod/'}$withdrawMethodId");
    final response = await http.patch(
      Uri.parse(
          '${ApiUrl().API_URL_USER}${'$user_id/withdrawMethod/'}$withdrawMethodId'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint(
        " withdrawMethod upi response ${response.body.toString()}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Added Sucessfully");

      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/

      LogOut(true, response);
    } else if (response.statusCode == 404) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return json.decode(response.body.toString());
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    }
  }

  Future<Map<String, dynamic>> getBuyStore(var payload, String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(" join event  ${payload}");
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_BUY_STORE}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response BUY STORE  ====" + '${response.body}');
    Utils().customPrint("response BUY STORE ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/

      LogOut(true, response);
    } else {
      return json.decode(response.body.toString());
    }
  }

  Future<Map<String, dynamic>> getStoreHistory(
      String token, String userid) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(
        "store history data ${'${ApiUrl().API_URL_BUY_STORE}?expand=storeItemId&userId=${userid}'}");
    final response = await http.get(
      Uri.parse(
          '${ApiUrl().API_URL_BUY_STORE}?expand=storeItemId&userId=${userid}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response BUY STORE  ====" + '${response.body}');
    Utils().customPrint("response BUY STORE ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/

      LogOut(true, response);
    } else {
      return json.decode(response.body.toString());
    }
  }

  Future<Map<String, dynamic>> getUnityHistory(String token, String user_id,
      String game_id, int total_limit, var pagesCount) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(
        "unity history api ${ApiUrl().API_URL_UNITY_HIS}$game_id&userId=$user_id&expand=eventId&limit=$total_limit&offset=$pagesCount");

    try {
      if (token != null && user_id != null && token != '' && user_id != '') {
        final response = await http.get(
          Uri.parse(
              '${ApiUrl().API_URL_UNITY_HIS}$game_id&userId=$user_id&expand=eventId&limit=$total_limit&offset=$pagesCount'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("response BUY STORE  ====" + '${response.body}');
        Utils()
            .customPrint("response BUY STORE ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return json.decode(response.body.toString());
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getUnityHistoryDetails(
      String token, String user_id, String game_id) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint(
        "history details /event/62c6a5943756841130581b0e/registrations?expand=rounds.lobbyId&userId=62cea01f8c0974c06829946e&opponents=true");
    final response = await http.get(
      Uri.parse(
          '${ApiUrl.API_URL}event?isRMG=true&includeUserEvents=62cea01f8c0974c06829946e&opponents=true'),
      /*Uri.parse(
          '${ApiUrl.API_URL}event/62c6a5943756841130581b0e/registrations?expand=rounds.lobbyId&userId=62cea01f8c0974c06829946e&opponents=true'),*/
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    //Fluttertoast.showToast(msg: "${response.body}");
    Utils().customPrint("response history details ====" + '${response.body}');
    Utils().customPrint("code history details====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);

      LogOut(true, response);

      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return json.decode(response.body.toString());
    }
  }

  Future<Map<String, dynamic>> getTeamsCreate(var payload, var path_call,
      String token, String user_id, BuildContext context) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    var postUri = Uri.parse(
        '${ApiUrl.API_URL}${'user/$user_id'}/team/') /*Uri.parse('${ApiUrl().API_URL_USER}$user_id')*/;
    Utils().customPrint("Token ====> Bearer $token");
    var request = new http.MultipartRequest("POST", postUri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      "BasicAuth": AppString().header_Token,
      'Authorization': 'Bearer $token',
    };
    Utils().customPrint("name==>" + payload["name"]);
    Utils().customPrint("gameId==>" + payload["gameId"]);
    Utils().customPrint("teamTypeId==>" + payload["teamTypeId"]);
    request.headers.addAll(headers);
    request.fields['name'] = payload["name"];
    request.fields['gameId'] = payload["gameId"];
    request.fields['teamTypeId'] = payload["teamTypeId"];
    if (path_call != null) {
      request.files.add(await http.MultipartFile.fromPath(
        "image",
        path_call,
        contentType: new MediaType('image', 'png'),
      ));
    }

    Utils().customPrint("Request data==>" + request.toString());
    await request.send().then((response) async {
      Utils().customPrint("response.statusCode ===>${response.statusCode}");
      if (response.statusCode == 200) {
        Navigator.pop(context);

        ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();
        Utils.showCustomTosstError("success");
        final respStr = await response.stream.bytesToString();
        Utils().customPrint("create team success");
        Utils().customPrint(json.decode(respStr));

        return json.decode(respStr);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);

        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else if (response.statusCode == 400) {
        /*  ProfileController controller = Get.put(ProfileController());
        controller.onStartMethod();*/
        try {
          final respStr = await response.stream.bytesToString();
          final resD = json.decode(respStr);
          Utils().customPrint("error create${resD}");
          Fluttertoast.showToast(msg: "${resD["error"]}");
        } catch (E) {}
        /*       Utils.showCustomTosstError(
            "Team name is already taken.Please try another name");*/
        return null;
      } else {
        Utils.showCustomTosstError("error");
        return null;
      }
    }).catchError((e) {
      /* ProfileController controller = Get.put(ProfileController());
      controller.onStartMethod();*/
      Utils.showCustomTosstError(e.toString());
      //  editProfilecontroller.btnControllerProfile.value.reset();
      Utils().customPrint(e);
      return null;
    });
  }

  Future<Map<String, dynamic>> getEditProfile(
      var payload, String token, String User_id) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint("edit profile  ${jsonEncode(payload)}");
    final response = await http.patch(
      Uri.parse('${ApiUrl().API_URL_USER}$User_id'),
      body: jsonEncode(payload),
      headers: {
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response edit profile ====" + '${response.body}');
    Utils()
        .customPrint("response edit profile ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        Utils().showErrorMessage("", "Successful");
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      // Utils().showErrorMessage("", "Some Error");
      return null;
    }
  }

  Future<Map<String, dynamic>> getProfileData(
      String token, String User_id) async {
    if (!await InternetConnectionChecker().hasConnection) {
      //  Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    if (User_id != null && User_id != '' && token != null && token != '') {
      try {
        final response = await http.get(
          Uri.parse('${ApiUrl().API_URL_USER}$User_id'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint(
            "profile api " + '${'${ApiUrl().API_URL_USER}$User_id'}');

        Utils().customPrint(
            "response User Profile Body ====" + '${response.body}');
        Utils().customPrint(
            "response User Profile Code====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      } catch (e) {}
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getESportEventList(
      String token,
      String gameid,
      String clanId,
      String displayDateFrom,
      String joiningEndDateFrom,
      String includeUserEvents,
      String gameMapId,
      String minPrize,
      String status) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String Url =
        '${ApiUrl.API_URL}event?expand=gameId,gameModeId,gamePerspectiveId,teamTypeId,gameMapId';
    if (!gameid.isEmpty) {
      Url = Url + "&gameId=$gameid";
    }
    if (!clanId.isEmpty) {
      Url = Url + "&clanId=$clanId";
    }
    if (!displayDateFrom.isEmpty) {
      Url = Url + "&displayDateTo=$displayDateFrom";
    }
    if (!joiningEndDateFrom.isEmpty) {
      Url = Url + "&joiningEndDateFrom=$joiningEndDateFrom";
    }

    if (!includeUserEvents.isEmpty) {
      Url = Url + "&excludeUserEvents=$includeUserEvents";
    }
    if (!gameMapId.isEmpty) {
      Url = Url + "&gameMapId=$gameMapId";
    }
    /*  if (!minPrize.isEmpty) {
      Url = Url + "&minPrize=$minPrize";
    }*/
    /* if (!maxPrize.isEmpty) {
      Url = Url + "&maxPrize=$maxPrize";
    }*/
    if (!status.isEmpty) {
      Url = Url + "&status=$status";
    }
    if (ApiUrl().isPlayStore) {
      Url = Url + "&isPlayStore=${ApiUrl().isPlayStore}";
    }

    Utils().customPrint("Url=== getESportEventList  " + '${Url}');
    Utils().customPrint("Header Token" + AppString().header_Token);
    Utils().customPrint("Bearer" + token);

    try {
      final response = await http.get(
        Uri.parse('${Url}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("response==== event list" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getUnitEventList(
      String token,
      String gameid,
      String clanId,
      String displayDateFrom,
      String includeUserEvents,
      String status) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("------ LUDO ------");
    String Url =
        '${ApiUrl.API_URL}event?expand=gameId,gameModeId,gamePerspectiveId,teamTypeId,gameMapId&isRMG=true';
    if (!gameid.isEmpty) {
      Url = Url + "&gameId=$gameid";
    }
    if (!status.isEmpty) {
      Url = Url + "&status=$status";
    }
    if (!includeUserEvents.isEmpty) {
      Url = Url + "&excludeUserEvents=$includeUserEvents";
    }

    if (ApiUrl().isPlayStore) {
      Url = Url + "&isPlayStore=${ApiUrl().isPlayStore}";
    }

    Utils().customPrint("Url===  " + '${Url}');
    Utils().customPrint("Bearer" + token);
    try {
      final response = await http.get(
        Uri.parse('${Url}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("response====" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getJoinedContestList(
      String token,
      String gameid,
      String clanId,
      String includeUserEvents,
      String includeTeamEvents,
      String status) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    String Url =
        '${ApiUrl.API_URL}event?expand=gameId,gameModeId,gamePerspectiveId,teamTypeId,gameMapId';
    if (!gameid.isEmpty) {
      Url = Url + "&gameId=$gameid";
    }
    if (!clanId.isEmpty) {
      Url = Url + "&clanId=$clanId";
    }
    if (!includeTeamEvents.isEmpty) {
      Url = Url + "&includeTeamEvents=$includeTeamEvents";
    }
    if (!includeUserEvents.isEmpty) {
      Url = Url + "&includeUserEvents=$includeUserEvents";
    }

    if (!status.isEmpty) {
      Url = Url + "&status=$status";
    }
    if (ApiUrl().isPlayStore) {
      Url = Url + "&isPlayStore=${ApiUrl().isPlayStore}";
    }

    try {
      Url = Url + "&sortBy=createdAt:DESC";

      Utils().customPrint("Url=== " + '${Url}');
      Utils().customPrint("Header Token" + AppString().header_Token);
      Utils().customPrint("Bearer" + token);
      final response = await http.get(
        Uri.parse('${Url}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("response====" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getWithdrawalData(
      String token, String user_id) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    final response = await http.get(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/withdrawMethod'}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("withdraw body====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      //Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
      Map<String, dynamic> map = {
        "user_id": user_id,
        "error": response.body.toString()
      };
      CleverTapController cleverTapController = Get.put(CleverTapController());
      cleverTapController.logEventCT(EventConstant.EVENGT_REPLAY, map);
      return null;
    }
  }

  Future<Map<String, dynamic>> getWalletData(String token, String id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      if (token != null && id != null) {
        var URL = '${ApiUrl().API_URL_USER_WALLATE}'.replaceAll('%s', id);
        final response = await http.get(
          Uri.parse('${URL}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint('url ${URL}');
        Utils().customPrint("getWalletData====" + '${response.body}');
        Utils()
            .customPrint("getWalletData Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          //Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);

          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getMap(
      String token, String id, String statusType) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    final response = await http.get(
      Uri.parse('${ApiUrl.API_URL}/game/map?status=active'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====for get maps" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    Utils().customPrint(
        "map api url ${ApiUrl.API_URL}${'/game/map?status=active'}");
    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      return null;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getJoinedBattlesDetails(
      String token, String event_id) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint('token $token');
    Utils().customPrint(
        'getJoinedBattlesDetails===url>${ApiUrl().API_URL_PRE_JOIN_EVENT}$event_id?expand=gameId,teamTypeId,gameMapId,gamePerspectiveId,gameModeId');
    final response = await http.get(
      Uri.parse(
          '${ApiUrl().API_URL_PRE_JOIN_EVENT}$event_id?expand=gameId,teamTypeId,gameMapId,gamePerspectiveId,gameModeId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    // Fluttertoast.showToast(msg: response.toString());

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getDetailsPlayers(
      String token, String event_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(
        "getDetailsPlayers==>url ${ApiUrl().API_URL_PRE_JOIN_EVENT}$event_id/registrations?expand=userId,teamId,rounds.lobbyId");
    final response = await http.get(
      Uri.parse(
          '${ApiUrl().API_URL_PRE_JOIN_EVENT}$event_id/registrations?expand=userId,teamId,rounds.lobbyId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("getDetailsPlayers====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    // Fluttertoast.showToast(msg: response.toString());

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getDetailsUserInfo(
      String user_id, String token, String event_id) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint(
        "url---------- ${ApiUrl().API_URL_JOINED_DETAILS}$user_id/event/$event_id/registration?expand=teamId,userId&status=active");
    final response = await http.get(
      Uri.parse(
          '${ApiUrl().API_URL_JOINED_DETAILS}$user_id/event/$event_id/registration?expand=teamId,userId&status=active'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    // Fluttertoast.showToast(msg: response.toString());

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      return null;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getTeamType(String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //  Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${ApiUrl.API_URL}${'/team/type'}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("team type ====" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getPerspective(
      String token, String id, statusType) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    final response = await http.get(
      Uri.parse(
          '${ApiUrl.API_URL}${'/game/perspective?gameId=$id'}${'&status=$statusType'}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> requestForVerifyOTP(
      Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aag otp req");
    Utils().customPrint(json.encode(param));
    Utils().customPrint("aa otp url  ${ApiUrl.API_URL_OTP_VERIFY}");
    final response = await http.post(Uri.parse('${ApiUrl.API_URL_OTP_VERIFY}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response != null) {
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Utils.showCustomTosst("Some Error ..1");
        return null;
      } else if (response.statusCode == 404) {
        Utils.showCustomTosst("Invalid otp requestId for provided userId");
        return null;
      } else if (response.statusCode == 400) {
        Utils.showCustomTosst("Invalid OTP value");
        return null;
      } else {
        Utils.showCustomTosst("Some Error..0");
        return null;
      }
    } else {
      Utils.showCustomTosst("Some Error ..-1");
      return null;
    }
  }

  Future<Map<String, dynamic>> requestForResendOTP(
      Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint(json.encode(param));

    final response = await http.post(
        Uri.parse('${ApiUrl.API_URL}user/resendOTP'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*  SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> requestForResendOTPLogin(
      Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint(json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //  LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> requestForGetDashboard(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    /* if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint("aa gaya");
    Utils().customPrint(json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint(
        "requestForGetDashboard response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
//      LogOut(true, response);

      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  /*get user profile */
  static Future<Map<String, dynamic>> requestForGetProfile(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint(json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint(
        "requestForGetProfile response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
//      LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  /*update user profile image*/
  static Future<Map<String, dynamic>> requestForUpdateImage(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // LogOut(true, response);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  /*request for add admount */
  static Future<Map<String, dynamic>> requestForAddMoney(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint(
        "requestForAddMoney response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //  LogOut(true, response);
      /*     SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  //reuest for transtion history get
  static Future<Map<String, dynamic>> requestForTrasnactionHistory(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("requestForTrasnactionHistory response Code ====" +
        '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //  LogOut(true, response);

      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  /*request for upload kyc */

  static Future<Map<String, dynamic>> requestForUploadKyc(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response != null) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
  }

  /*fetch contact list All battels*/
  static Future<Map<String, dynamic>> fetchalleventwithdetails(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint(
        "fetchalleventwithdetails ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);

      // LogOut(true, response);

      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  /*fetch all joined event by user */
  static Future<Map<String, dynamic>> fetchallJoindEventByUser(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response != null) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
  }

  /*Request for join event  */
  static Future<Map<String, dynamic>> requestForJoin(
      Map<String, dynamic> param, String basicAuth) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("aa gaya");
    Utils().customPrint("request--" + json.encode(param));

    final response = await http.post(Uri.parse('${ApiUrl.API_URL}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "BasicAuth": AppString().header_Token,
          "Authorization": basicAuth,
        });
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response != null) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> getCmsAges(String url) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint('${url}');
    final response = await http
        .get(Uri.parse('${url}'), headers: {"Accept": "application/json"});
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response != null) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
  }

  /*ballbai controller */

  Future<Map<String, dynamic>> BallbaziLogin(String token, String id) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    var URL = '${ApiUrl().API_URL_BALLBAZI_LOGIN}'.replaceAll('%s', id);

    Utils().customPrint("URL====" + '${URL}');
    Utils().customPrint("token====" + '${token}');
    final response = await http.post(
      Uri.parse('${URL}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  /*ballbai controller */

  Future<Map<String, dynamic>> loginPocket52(
      String token, String id, Map<String, String> payload) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    var URL = '${ApiUrl().API_URL_POCKET_LOGIN}'.replaceAll('%s', id);

    Utils().customPrint("URL Pocker====body" + '${payload.toString()}');
    Utils().customPrint("URL Pocker====" + '${URL}');
    Utils().customPrint("token====" + '${token}');
    final response = await http.post(
      Uri.parse('${URL}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      // if (response != null) {
      return json.decode(response.body.toString());
      /* } else {
        return null;
      }*/
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getOnlyLeaderBoarData(
      String token, String userid, String gameId, String type) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint('${ApiUrl().API_LEADERBOARD_LIST}$type&gameId=$gameId');
    String Url = '${ApiUrl().API_LEADERBOARD_LIST}$type&gameId=$gameId';
    final response = await http.get(
      Uri.parse('${Url}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response getLeaderBoarData ====" + '${response.body}');
    Utils().customPrint(
        "response  getLeaderBoarData Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      }
    } else if (response.statusCode == 404) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
      LogOut(true, response);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserProfileSummary(
      String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //  Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    try {
      if (token != null && user_id != null) {
        final response = await http.get(
          Uri.parse('${ApiUrl().API_URL_USER}$user_id/event/summary'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("profile  summary values print  ${response.body}");
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getLeaderBoarData(String token, String userid,
      String clanid, String gameId, String type) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String Url = '${ApiUrl().API_LEADERBOARD_LIST}$type&clanId=$clanid';
    Utils().customPrint('clan leaderboard ===>${Url}');
    Utils().customPrint("token====" + '${token}');
    Utils().customPrint("userid====" + '${userid}');
    Utils().customPrint("clanid====" + '${clanid}');
    final response = await http.get(
      Uri.parse('${Url}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response getLeaderBoarData ====" + '${response.body}');
    Utils().customPrint(
        "response  getLeaderBoarData Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      }
    } else if (response.statusCode == 404) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
      /* SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/

      LogOut(true, response);
    }

    /*else if (response.statusCode == 401 || response.statusCode == 403) {
      return json.decode(response.body.toString());

    }*/
    else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getReferalList(
      String token, String userid, String type) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //  Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("Url===> ${ApiUrl().API_REWARDS}$type");
    Utils().customPrint("Url===> Bearer $token");
    try {
      final response = await http.get(
        Uri.parse('${ApiUrl().API_REWARDS}$type'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("response getReferalList ====" + '${response.body}');
      Utils().customPrint(
          "response  getReferalList Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  /*clan model */

  Future<Map<String, dynamic>> getClanList(String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //  Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(
        "clan list Url=== " + '${ApiUrl().API_CLAN_LIST + "?status=active"}');
    Utils().customPrint("Header " + AppString().header_Token);
    Utils().customPrint("Bearer " + token);
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('${ApiUrl().API_CLAN_LIST + "?status=active"}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("response==== clan" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      } catch (e) {}
    }
  }

  Future<Map<String, dynamic>> getJoinedClanList(
      String token, String userid) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("Header " + AppString().header_Token);
    Utils().customPrint("Bearer " + token);
    String Url =
        '${ApiUrl().API_JOINED_CLAN_LIST}' + userid + "/clan?status=active";
    Utils().customPrint("Joined Clan list Url=== " + '${Url}');
    try {
      final response = await http.get(
        Uri.parse('${Url}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("Joined clan list response====" + '${response.body}');
      Utils()
          .customPrint("Joined response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
      } else {
        return null;
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> UserJoinedClan(
      String token, String userid, String clanid) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String Url = '${ApiUrl.API_URL}clan/' + clanid + "/member/" + userid;

    Utils().customPrint("Url=== " + '${Url}');
    Utils().customPrint("Header Token" + AppString().header_Token);
    Utils().customPrint("Bearer" + token);
    try {
      final response = await http.post(
        Uri.parse('${Url}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("response====" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return json.decode(response.body.toString());
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);

        LogOut(true, response);

        return null;
      } else {
        return json.decode(response.body.toString());
      }
    } catch (e) {}
  }

  Future<http.Response> userRemoveClan(
      String token, String userid, String clanid) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String Url = '${ApiUrl.API_URL}clan/' + clanid + "/member/" + userid;

    Utils().customPrint("Url=== " + '${Url}');
    Utils().customPrint("Header Token" + AppString().header_Token);
    Utils().customPrint("Bearer" + token);
    final response = await http.delete(
      Uri.parse('${Url}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserTeamForJoinContest(
      String token,
      String User_id,
      String teamTypeId,
      String gameId,
      bool isCaptain,
      String status) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    String Api_Url =
        '${ApiUrl.API_URL}${'user/$User_id'}/team?expand=gameId,members.userId,teamTypeId&';
    if (gameId != "") {
      Api_Url = Api_Url + "gameId=${gameId}";
    }
    if (teamTypeId != "") {
      Api_Url = Api_Url + "&teamTypeId=${teamTypeId}";
    }
    if (isCaptain) {
      Api_Url = Api_Url + "&isCaptain=${isCaptain}";
    }
    if (!status.isEmpty) {
      Api_Url = Api_Url + "&status=${status}";
    }

    final response = await http.get(
      Uri.parse('${Api_Url}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint('get teams Joined ${Api_Url}');
    Utils().customPrint("response team management====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      //  Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);

      LogOut(true, response);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> RazorepayCreateOrder(
      String token, String user_id, var payload) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint('payload RazorepayCreateOrder=> ${payload}');
    Utils().customPrint('${ApiUrl().API_RAZOREPAY_CREATE_ORDER}');

    try {
      if (token != null && user_id != null) {
        final response = await http.post(
          Uri.parse('${ApiUrl().API_RAZOREPAY_CREATE_ORDER}'),
          body: json.encode(payload),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        final res = json.decode(response.body.toString());
        Utils().customPrint("Response create Order ${res.toString()}");

        if (response.statusCode == 200) {
          if (response != null) {
            Utils().customPrint(response.body.toString());
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 403 || response.statusCode == 401) {
          LogOut(true, response);
          return null;
        } else {
          final res = json.decode(response.body.toString());
          if (res != null) {
            Utils().customPrint("razorpay call create order ${res.toString()}");
            Fluttertoast.showToast(msg: "${res["error"]}");
          }

          return null;
        }
      }
    } catch (e) {}
  }

  Future<http.Response> RozerpayOrderUpadte(
      String token, String user_id, var payload) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint('payload => ${payload}');
    Utils().customPrint('${ApiUrl().API_RAZOREPAY_PAYMENT_SUCCESS}');
    final response = await http.post(
      Uri.parse('${ApiUrl().API_RAZOREPAY_PAYMENT_SUCCESS}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("Response create Order" + response.body.toString());

    return response;
  }

  void showProgressbar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.transparent,
            child: Image(
                height: 100,
                width: 100,
                //color: Colors.transparent,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/progresbar_images.gif")),

            //image:AssetImage("assets/images/progresbar_images.gif")),
          ),
        );
      },
    );
  }

  //FTD NOT USED
  Future<Map<String, dynamic>> getFirstTimeDepositStatus(
      String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    var URL =
        '${ApiUrl().API_URL_FTD}user/$user_id/transaction?walletId=${AppString.depositWalletId}&limit=1&operationType=deposit';
    final response = await http.get(
      Uri.parse('${URL}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint('url ${URL}');
    Utils().customPrint(
        "getFirstTimeDepositStatus Data ====" + '${response.body}');
    Utils().customPrint(
        "getFirstTimeDepositStatus Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/

      LogOut(true, response);
    } else {
      return null;
    }
  }

  //banned state api
  Future<List<dynamic>> getCountryRestrictions() async {
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiUrl().API_URL_CountryRestrictions}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
        },
      );
      Utils().customPrint(
          "getCountryRestrictions values in URL ${ApiUrl().API_URL_CountryRestrictions}");
      Utils().customPrint(
          "getCountryRestrictions values in BODY ${response.body}");
      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          Utils().customPrint('getCountryRestrictions: ERROR');
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        Utils().customPrint('getCountryRestrictions: ERROR LAST');
      }
    } catch (e) {}
  }

  //hash generation API
  Future<Map<String, dynamic>> getHashForRummy(
      String token, Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    Utils().customPrint("getHashForRummy data $param");
    Utils().customPrint("getHashForRummy  url ${ApiUrl.API_URL_HASH_RUMMY}");

    try {
      if (token != null) {
        final response = await http.post(
            Uri.parse('${ApiUrl.API_URL_HASH_RUMMY}'),
            body: json.encode(param),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "BasicAuth": AppString().header_Token,
              'Authorization': 'Bearer $token',
            });
        Utils().customPrint(
            "getHashForRummy response Code ====" + '${response.statusCode}');
        if (response.statusCode == 200) {
          return json.decode(response.body.toString());
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);

          return null;
        } else if (response.statusCode == 400) {
          final res = json.decode(response.body.toString());
          Fluttertoast.showToast(msg: "${res["error"]}");
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  //gupshup opt-in API
  Future<Map<String, dynamic>> getGupShupOptInApi(
      String token, Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      if (token != null) {
        Utils().customPrint("getGupShupOptInApi data $param");
        Utils().customPrint(
            "getGupShupOptInApi  url ${ApiUrl.API_URL_GUPSHUP_OPT_IN}");
        final response = await http.post(
            Uri.parse('${ApiUrl.API_URL_GUPSHUP_OPT_IN}'),
            body: json.encode(param),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "BasicAuth": AppString().header_Token,
              'Authorization': 'Bearer $token',
            });
        //Utils().customPrint("getHashForRummy response ====" + '${response.body}');
        Utils().customPrint(
            "getGupShupOptInApi response Code ====" + '${response.statusCode}');
        Utils().customPrint(
            "getGupShupOptInApi response Body ====" + '${response.body}');
        if (response.statusCode == 200) {
          if (response.body != null && response.body.toString() != '') {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
          return null;
        } else if (response.statusCode == 400) {
          final res = json.decode(response.body.toString());
          Fluttertoast.showToast(msg: "${res["error"]}");
          return null;
        } else {
          //final res = json.decode(response.body.toString());
          //  Fluttertoast.showToast(msg: "Some Error");
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getTransaction(String token, String user_id,
      String wallet_id, int pagesCount, int total_limit) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("getTransaction====" +
        'wallet id ${wallet_id}  user_id$user_id token$token');
    Utils().customPrint(
        '${ApiUrl.API_URL}${'user/$user_id/transaction?walletId=$wallet_id&sortBy=date:DESC'}&limit=$total_limit&offset=$pagesCount');
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse(
              '${ApiUrl.API_URL}${'user/$user_id/transaction?walletId=$wallet_id&sortBy=date:DESC'}&limit=$total_limit&offset=$pagesCount'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("heder====" + 'Bearer ${token}');
        Utils().customPrint("getTransaction====" + '${response.body}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          Utils().customPrint('getWithdrawRequest DATA:: -1');
          LogOut(true, response);
          return null;
        } else {
          return json.decode(response.body.toString());
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getWithdrawRequest(
      String token, String user_id) async {
    Utils()
        .customPrint("getWithdrawRequest ====" + 'user_id$user_id token$token');
    Utils().customPrint(
        'getWithdrawRequest URL==== ${ApiUrl.API_URL}${'user/$user_id/withdrawRequest'}');

    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiUrl.API_URL}${'user/$user_id/withdrawRequest'}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );

      Utils().customPrint("heder====" + '${AppString().header_Token}');
      Utils().customPrint("heder====" + 'Bearer ${token}');
      Utils().customPrint("getWithdrawRequest====" + '${response.body}');
      Utils().customPrint(
          "getWithdrawRequest Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return json.decode(response.body.toString());
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getWithdrawRequestAccordingTran(
      String token, String user_id, String tranId) async {
    Utils()
        .customPrint("getWithdrawRequest ====" + 'user_id$user_id token$token');
    Utils().customPrint(
        'getWithdrawRequest URL==== ${ApiUrl.API_URL}${'user/$user_id/withdrawRequest'}');

    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(
            '${ApiUrl.API_URL}${'user/$user_id/withdrawRequest?transactionId=$tranId'}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );

      Utils().customPrint("heder====" + '${AppString().header_Token}');
      Utils().customPrint("heder====" + 'Bearer ${token}');
      Utils().customPrint("getWithdrawRequest====" + '${response.body}');
      Utils().customPrint(
          "getWithdrawRequest Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return json.decode(response.body.toString());
      }
    } catch (e) {}
  }

  //cancel WithdrawRequest API
  Future<Map<String, dynamic>> cancelWithdrawRequest(
      String token,
      String user_id,
      String wallet_request_id,
      Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("cancelWithdrawRequest data $param");
    Utils().customPrint("cancelWithdrawRequest ====" +
        'user_id: $user_id token: $token wallet_request_id: $wallet_request_id');
    Utils().customPrint(
        'cancelWithdrawRequest URL==== ${ApiUrl.API_URL}${'user/$user_id/withdrawRequest/$wallet_request_id'}');
    final response = await http.patch(
        Uri.parse(
            '${ApiUrl.API_URL}${'user/$user_id/withdrawRequest/$wallet_request_id'}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
    //Utils().customPrint("getHashForRummy response ====" + '${response.body}');
    Utils().customPrint(
        "cancelWithdrawRequest response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      //final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "Something went wrong!");
      return null;
    }
  }

  Future<Map<String, dynamic>> getAppSetting(
      String token, String user_id) async {
    Utils().customPrint('Url====> ${ApiUrl().API_URL_APP_SETTING}');

    if (!await InternetConnectionChecker().hasConnection) {
      //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiUrl().API_URL_APP_SETTING}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("appsetting  ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  // setting public
  Future<Map<String, dynamic>> getSettingPublic() async {
    if (!await InternetConnectionChecker().hasConnection) {
      //Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiUrl().setting_public}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
        },
      );
      Utils().customPrint(
          "dynamic whatsapp values in URL ${ApiUrl().setting_public}");
      Utils().customPrint("dynamic whatsapp values in BODY ${response.body}");
      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          Utils().customPrint('dynamic whatsapp: ERROR');
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
        Utils().customPrint('dynamic whatsapp: ERROR LAST');
      }
    } catch (e) {}
  }

  //Offerwall get data
  Future<Map<String, dynamic>> getAdvertisersDeals(
      String token,
      String keyword,
      String activeFromDate,
      String activeToDate,
      String status,
      String sortBy,
      String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    var URL =
        '${ApiUrl.API_URL}advertiser/deal?keyword=$keyword&activeFromDate=$activeFromDate&activeToDate=$activeToDate&status=$status&sortBy=$sortBy&usesLimitFilter=true&includeUserDeals=$user_id&date=${AppString.serverTime}';
    try {
      if (user_id != null && token != null) {
        final response = await http.get(
          Uri.parse('${URL}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint('url ${URL}');
        Utils().customPrint(
            "getAdvertisersDeals Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 403 || response.statusCode == 401) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  //createUserDeal
  Future<Map<String, dynamic>> createUserDeal(
      String token, String user_id, Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("createUserDeal data $param");
    Utils()
        .customPrint("createUserDeal ====" + 'user_id: $user_id token: $token');
    Utils().customPrint(
        'createUserDeal URL==== ${ApiUrl.API_URL}${'user/${user_id}/deal'}');
    final response = await http.post(
        Uri.parse('${ApiUrl.API_URL}${'user/${user_id}/deal'}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
    //Utils().customPrint("getHashForRummy response ====" + '${response.body}');
    Utils().customPrint(
        "createUserDeal response Code ====" + '${response.statusCode}');
    Utils().customPrint(
        "createUserDeal response Code ====" + '${response.body.toString()}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());

      if (res["errorCode"] != null &&
          res["errorCode"].toString() == "ERR2302") {
        return res;
      } else {
        Fluttertoast.showToast(msg: "${res["error"]}");
        return null;
      }
    } else {
      //final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "Something went wrong!");
      return null;
    }
  }

  //Offerwall get data
  Future<Map<String, dynamic>> getUserDeals(
    String token,
    String user_id,
  ) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    var URL =
        '${ApiUrl.API_URL}user/deal?userId=$user_id&expand=advertiserDealId';

    try {
      final response = await http.get(
        Uri.parse('${URL}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint('url ${URL}');
      Utils().customPrint("getUserDeals Data ====" + '${response.body}');
      Utils().customPrint("getUserDeals Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getWithdrawalSummary(
      String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiUrl().API_URL_USER}${'$user_id/withdrawRequest/summary'}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint("withdraw body====" + '${response.body}');
      Utils().customPrint("response Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  //getPaymentGatewayData
  Future<Map<String, dynamic>> getPaymentGatewayData(String token) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      if (token != null) {
        var URL = '${ApiUrl.API_URL}payment-gateway/method';
        final response = await http.get(
          Uri.parse('${URL}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint('url ${URL}');
        Utils().customPrint(
            "getPaymentGatewayData Data ====" + '${response.body}');
        Utils().customPrint(
            "getPaymentGatewayData Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 403 || response.statusCode == 401) {
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> paymentGatewayNew(
      String token, String user_id, Map<String, dynamic> param, source) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("paymentGatewayNew data $param");
    Utils().customPrint(
        'paymentGatewayNew URL==== ${ApiUrl.API_URL}$source/payment');

    try {
      if (token != null && user_id != null) {
        final response = await http.post(
            Uri.parse('${ApiUrl.API_URL}$source/payment'),
            body: json.encode(param),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "BasicAuth": AppString().header_Token,
              'Authorization': 'Bearer $token',
            });
        //Utils().customPrint("getHashForRummy response ====" + '${response.body}');
        Utils().customPrint(
            "paymentGatewayNew response Code ====" + '${response.body}');
        if (response.statusCode == 200) {
          return json.decode(response.body.toString());
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
          return null;
        } else if (response.statusCode == 400) {
          final res = json.decode(response.body.toString());
          if (res["error"] != null) {
            if (res["error"].toString() == 'Refund failed') {
              Fluttertoast.showToast(msg: "UPI Payment Failed, try again!");
            } else {
              Fluttertoast.showToast(msg: "${res["error"]}");
            }
          } else {
            Fluttertoast.showToast(msg: "Something went wrong, try again!");
          }

          return null;
        } else {
          //final res = json.decode(response.body.toString());
          Fluttertoast.showToast(msg: "Something went wrong!");
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> paymentGatewayStatusNew(
      String token, String user_id, Map<String, dynamic> param, source) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("paymentGatewayStatusNew data $param");
    Utils().customPrint(
        'paymentGatewayStatusNew URL==== ${ApiUrl.API_URL}$source/payment/status');
    final response = await http.post(
        Uri.parse('${ApiUrl.API_URL}$source/payment/status'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
    //Utils().customPrint("getHashForRummy response ====" + '${response.body}');
    Utils().customPrint("paymentGatewayStatusNew response Code ====" +
        '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Fluttertoast.showToast(msg: "Account logged in somewhere else".capitalize);
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      //final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "Something went wrong!");
      return null;
    }
  }

  Future<Map<String, dynamic>> generateCashFreeToken(
      var payload, String token) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/
    Utils().customPrint("url => ${ApiUrl.API_URL_CHASHFREE}");
    Utils().customPrint("payload => ${payload}");
    final response = await http.post(
      Uri.parse('${ApiUrl.API_URL_CHASHFREE}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": 'application/json',
        "x-client-id": "${ApiUrl.client_ID}",
        "x-client-secret": "${ApiUrl.CASHFREE_SECRET}",

        //   "authkey": ApiUrl().INVOID_AUTH_KEY,
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );

    Utils().customPrint("response cashfree => ${response}");

    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
    Utils().customPrint("checkInvoidAadharcard====" + '${response.body}');
    Utils()
        .customPrint("checkInvoidAadharcard ====" + '${response.statusCode}');
  }

  //bannerViaGameId
  Future<Map<String, dynamic>> getBannerViaGameId(
      String token, String gameId) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("banner reword");

    try {
      String url = "";

      url = '${ApiUrl.API_URL_BANNER}?gameId=$gameId&status=active';
      Utils().customPrint('getBannerViaGameId: $url');
      if (token != null && gameId != null) {
        final response = await http.get(
          Uri.parse('${url}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("banner reword response $response");

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            LogOut(true, response);
            return null;
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  //Vip redeem
  Future<Map<String, dynamic>> claimInstantCash(
      String token, String user_id, Map<String, dynamic> param) async {
    //net connectivity check

    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("claimInstantCash data $param");
    Utils().customPrint(
        "claimInstantCash ====" + 'user_id: $user_id token: $token');
    Utils().customPrint(
        'claimInstantCash URL==== ${ApiUrl.API_URL}${'user/${user_id}/claim-instant-cash'}');

    try {
      if (token != null) {
        final response = await http.post(
            Uri.parse(
                '${ApiUrl.API_URL}${'user/${user_id}/claim-instant-cash'}'),
            body: json.encode(param),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "BasicAuth": AppString().header_Token,
              'Authorization': 'Bearer $token',
            });

        Utils().customPrint(
            "claimInstantCash response Code ====" + '${response.statusCode}');
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Payment successfully transferred!");

          Map<String, dynamic> map = {"status": "success"};

          return map;
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else if (response.statusCode == 400) {
          return null;
        } else {
          //final res = json.decode(response.body.toString());
          Fluttertoast.showToast(msg: "Something went wrong!");
          return null;
        }
      }
    } catch (e) {}
  }

  //PromoCodes
  Future<Map<String, dynamic>> getPromoCodesData(
      String token, String user_id, String time, String isVIP) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    /* var URL =
        '${ApiUrl().API_URL_FTD}promo-code?status=active&sortBy=order:ASC,createdAt:ASC&excludeUserPromoCodes=$user_id&visibleOnApp=true&activationStartDateFrom=$time';
   */
    var URL = '';
    if (isVIP == "VIP") {
      URL =
          '${ApiUrl().API_URL_FTD}promo-code?status=active&sortBy=order:ASC,createdAt:ASC&excludeUserPromoCodes=$user_id&activationStartDateFrom=$time&vip=true';
    } else {
      URL =
          '${ApiUrl().API_URL_FTD}promo-code?status=active&sortBy=order:ASC,createdAt:ASC&excludeUserPromoCodes=$user_id&activationStartDateFrom=$time';
    }

    try {
      if (token != null && user_id != null) {
        final response = await http.get(
          Uri.parse('${URL}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint('url ${URL}');
        Utils().customPrint(
            "getFirstTimeDepositStatus Data ====" + '${response.body}');
        Utils().customPrint(
            "getFirstTimeDepositStatus Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 403 || response.statusCode == 401) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getVIPLevel(
      String token, String viplevelID) async {
    String url = "";

    url = '${ApiUrl.API_URL_VIPlevel}';

    Utils().customPrint('${url}');

    if (!await InternetConnectionChecker().hasConnection) {
      //   Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${url}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("vip reword response ${response.body.toString()}");

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            LogOut(true, response);

            return null;
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<http.Response> getWithdrawalClick(
      var payload, String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint(
        "getWithdrawal ${json.encode(payload)}  $user_id token $token");
    Utils().customPrint(
        "getWithdrawal ${ApiUrl().API_URL_USER}${'$user_id/withdrawRequest'}");
    final response = await http.post(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/withdrawRequest'}'),
      body: json.encode(payload),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("response Withdrawal click ====" + '${response.body}');
    Utils().customPrint(
        "response Withdrawal click  Code ====" + '${response.statusCode}');

    return response;
  }

  Future<Map<String, dynamic>> getWithdrawalTDS(
      String token, String user_id, Map<String, dynamic> param) async {
    //net connectivity check

    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      if (token != null) {
        Utils().customPrint("getWithdrawalTDS data $param");
        Utils().customPrint(
            "getWithdrawalTDS ====" + 'user_id: $user_id token: $token');
        Utils().customPrint(
            'getWithdrawalTDS URL==== ${ApiUrl().API_URL_USER}${'$user_id/withdrawRequest/deductions'}');
        final response = await http.post(
          Uri.parse(
              '${ApiUrl().API_URL_USER}${'$user_id/withdrawRequest/deductions'}'),
          body: json.encode(param),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );

        Utils().customPrint(
            "getWithdrawalTDS response Code ====" + '${response.statusCode}');
        Utils().customPrint(
            "getWithdrawalTDS response Body ====" + '${response.body}');
        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 403 || response.statusCode == 401) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  //PromoCodes
  Future<Map<String, dynamic>> getPromoCodesBannerData(
      String token, String user_id, String time, var userVipLevelList) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    var URL =
        '${ApiUrl().API_URL_FTD}promo-code?status=active&sortBy=order:ASC,createdAt:ASC&excludeUserPromoCodes=$user_id&activationStartDateFrom=$time&vip:true&vipLevelIds=$userVipLevelList'; //with user id
    /* var URL =
        '${ApiUrl().API_URL_FTD}promo-code?status=active&sortBy=order:ASC,createdAt:ASC&activationStartDateFrom=$time&vipLevelIds=$userVipLevelList';*/ //without userid
    try {
      final response = await http.get(
        Uri.parse('${URL}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
      );
      Utils().customPrint('url getPromoCodesBannerData ${URL}');
      Utils().customPrint(
          "getPromoCodesBannerData Data ====" + '${response.body}');
      Utils().customPrint(
          "getPromoCodesBannerData Code ====" + '${response.statusCode}');

      if (response.statusCode == 200) {
        if (response != null) {
          return json.decode(response.body.toString());
        } else {
          return null;
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        LogOut(true, response);
        return null;
      } else {
        return null;
      }
    } catch (e) {}
  }

  //saving device info
  Future<Map<String, dynamic>> saveDeviceInfo(
      String token, String user_id, Map<String, dynamic> param) async {
    //net connectivity check

    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils().customPrint("saveDeviceInfo data $param");
    Utils()
        .customPrint("saveDeviceInfo ====" + 'user_id: $user_id token: $token');
    Utils().customPrint(
        'saveDeviceInfo URL==== ${ApiUrl().API_URL_USER}${'$user_id/current-app-details'}');
    final response = await http.patch(
      Uri.parse('${ApiUrl().API_URL_USER}${'$user_id/current-app-details'}'),
      body: json.encode(param),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );

    Utils().customPrint(
        "saveDeviceInfo response Code ====" + '${response.statusCode}');
    Utils()
        .customPrint("saveDeviceInfo response Body ====" + '${response.body}');
    /*if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());
    } else {
      return null;
    }*/
  }

  //bannerViaGameId
  Future<Map<String, dynamic>> getBannerAsPerPageType(
      String token, String appTypes) async {
    String url = "";
    url =
        '${ApiUrl.API_URL_BANNER}?appTypes=$appTypes&isPopUp=true&status=active';
    Utils().customPrint('getBannerAsPerPageType: $url');

    Utils().customPrint('${url}');
    final response = await http.get(
      Uri.parse('${url}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "BasicAuth": AppString().header_Token,
        'Authorization': 'Bearer $token',
      },
    );
    Utils().customPrint("getBannerAsPerPageType response $response");

    if (response != null) {
      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        LogOut(true, response);
        /* SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        Get.offAll(Login());*/
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getTamashaEventList(String token) async {
    String url = "";
    url = '${ApiUrl.API_URL_TAMASHA_EVENT_LIST}';
    Utils().customPrint('getTamashaEventList: $url');

    Utils().customPrint('${url}');
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('${url}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
        );
        Utils().customPrint("getTamashaEventList response $response");

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            LogOut(true, response);
            return null;
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  // Tamasha WevView Call
  Future<Map<String, dynamic>> getTamashaWebView(
      String token, Map<String, String> param) async {
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }
    Utils()
        .customPrint("TAMASHA Webview call Api  ${ApiUrl.API_URL_WEBTAMASHA}");

    Utils().customPrint("pramas  ${ApiUrl.API_URL_WEBTAMASHA}");

    try {
      if (token != null) {
        final response = await http.post(
            Uri.parse('${ApiUrl.API_URL_WEBTAMASHA}'),
            body: json.encode(param),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "BasicAuth": AppString().header_Token,
              'Authorization': 'Bearer $token',
            });
        Utils().customPrint("response facebook ====" + '${response.body}');
        Utils().customPrint(
            "response Code facebook ====" + '${response.statusCode}');
        //   Fluttertoast.showToast(msg: "response ${response.statusCode}");

        if (response != null) {
          if (response.statusCode == 200) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  // Team11

  Future<Map<String, dynamic>> getTeam11BB(
      String token, String user_id, Map<String, dynamic> params) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/

    print("call game id $user_id");
    var URL = '${ApiUrl().MYTEAM11_BB}'.replaceAll('%s', user_id);

    Utils().customPrint("URL====team 11" + '${URL}');
    Utils().customPrint("token====" + '${token}');

    try {
      if (token != null && token != '' && user_id != '') {
        final response = await http.post(
          Uri.parse('${URL}'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "BasicAuth": AppString().header_Token,
            'Authorization': 'Bearer $token',
          },
          body: json.encode(params),
        );
        Utils().customPrint("response==== team11" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getTragoUrl(
      String token, String user_id, Map<String, dynamic> params) async {
    //net connectivity check
    /*if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }*/

    print("get values$params");
    var URL = '${ApiUrl().TRAGO_BB}'.replaceAll('%s', user_id);

    Utils().customPrint("URL====" + '${URL}');
    Utils().customPrint("token====" + '${token}');
    final response = await http.post(Uri.parse('${URL}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        },
        body: json.encode(params));
    Utils().customPrint("response====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      LogOut(true, response);
      /*SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      await preferences.remove('user_id');
      await preferences.clear();
      Get.offAll(Login());*/
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getFavoriteGame(
      String token, String user_id) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    var URL = '${ApiUrl().FAVORITE_GAME_LIST}'.replaceAll('%s', user_id);
    Utils().customPrint("URL====" + '${URL}');
    Utils().customPrint("token====" + '${token}');
    try {
      if (token != null && user_id != null) {
        final response = await http.get(Uri.parse('${URL}'), headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
        Utils().customPrint("response====" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> sendFavoriteGame(
      String token, String user_id, Map<String, dynamic> params) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    print("get values$params");
    var URL = '${ApiUrl().FAVORITE_GAME}'.replaceAll('%s', user_id);

    Utils().customPrint("URL====" + '${URL}');
    Utils().customPrint("token====" + '${token}');

    try {
      if (token != null) {
        final response = await http
            .post(Uri.parse('${URL}'), body: json.encode(params), headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
        Utils().customPrint("response====" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {}
  }

  Future<void> LogOut(bool checkLogout, var response) async {
    print("checl how time:: TRUE ${AppString.logoutTrue}");
    if (checkLogout) {
      try {
        if (AppString.logoutTrue && response != null) {
          AppString.logoutTrue = false;
          final res = json.decode(response.body.toString());
          if (res != null) {
            if (res["errorCode"] != null && res["errorCode"] == "ERR1105") {
              Fluttertoast.showToast(msg: "${res["error"]}");
            } else {
              Fluttertoast.showToast(
                  msg: "Account logged in somewhere else".capitalize);
            }
            print("checl how time:: FALSE ${AppString.logoutTrue}");

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.remove('token');
            await preferences.remove('user_id');
            await preferences.clear();

            Future.delayed(const Duration(milliseconds: 2000), () {
              Get.offAll(() => Login());
            });
          }
        }
      } catch (e) {}
    }
  }

  //Bureau ID API
  Future<Map<String, dynamic>> bureauApiFetchingDetails(
      String basicAuth, Map<String, dynamic> param) async {
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    Utils().customPrint("bureauApiFetchingDetails data $param");
    Utils()
        .customPrint("bureauApiFetchingDetails  url ${ApiUrl.API_URL_BUREAU}");
    final response = await http.post(Uri.parse('${ApiUrl.API_URL_BUREAU}'),
        body: json.encode(param),
        headers: {
          /*"Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,*/
          'Authorization': '$basicAuth',
        });
    //Utils().customPrint("getHashForRummy response ====" + '${response.body}');
    Utils().customPrint("bureauApiFetchingDetails response Code ====" +
        '${response.statusCode}');
    Utils().customPrint(
        "bureauApiFetchingDetails response Body ====" + '${response.body}');
    if (response.statusCode == 200) {
      if (response.body != null && response.body.toString() != '') {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else if (response.statusCode == 422) {
      final res = json.decode(response.body.toString());
      Fluttertoast.showToast(msg: "${res["error"]["description"]}");
      return null;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUserBureauData(
      String token, String user_id, Map<String, dynamic> params) async {
    print("updateUserBureauData $params");
    var URL = '${ApiUrl.API_URL_BUREAU_UPDATE_USER}'.replaceAll('%s', user_id);

    Utils().customPrint("URL====" + '${URL}');

    final response = await http
        .patch(Uri.parse('${URL}'), body: json.encode(params), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "BasicAuth": AppString().header_Token,
      'Authorization': 'Bearer $token',
    });
    Utils().customPrint("updateUserBureauData====" + '${response.body}');
    Utils().customPrint(
        "updateUserBureauData Code ====" + '${response.statusCode}');

    if (response.statusCode == 200) {
      if (response != null) {
        return json.decode(response.body.toString());
      } else {
        return null;
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
    } else {
      return null;
    }
  }

  //for referral total earned money
  Future<Map<String, dynamic>> totalMoneyEarnedReferral(
      String token, String user_id) async {
    try {
      if (!await InternetConnectionChecker().hasConnection) {
        // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
        return null;
      }

      if (token != null && user_id != null) {
        var URL = '${ApiUrl().REFERRAL}'.replaceAll('%s', user_id);
        Utils().customPrint("URL====" + '${URL}');
        Utils().customPrint("token====" + '${token}');
        final response = await http.get(Uri.parse('${URL}'), headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
          'Authorization': 'Bearer $token',
        });
        Utils().customPrint("response====" + '${response.body}');
        Utils().customPrint("response Code ====" + '${response.statusCode}');

        if (response.statusCode == 200) {
          if (response != null) {
            return json.decode(response.body.toString());
          } else {
            return null;
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          LogOut(true, response);
        } else {
          return null;
        }
      }
    } catch (e) {}
  }
}
