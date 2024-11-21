import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:gmng/model/unity_history/OnlyUnityHistoryModel.dart';
import 'package:intl/intl.dart';

import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import 'Freakx_Details_Controller.dart';

class FreakxDetails extends StatelessWidget {
  String _url;
  EventId eventdata = null;
  List history_list = new List<HistoryData>();

  int pos;

  List<OpponentsAll> opponents;

  FreakxDetails(this._url, this.history_list, this.pos);

  Freakx_Details_Controller base_controller =
      Get.put(Freakx_Details_Controller());

  @override
  Widget build(BuildContext context) {
    if (history_list != null) {
      // history_list.addAll(data);
      if (history_list[pos].eventId != null) {
        eventdata = history_list[pos].eventId;
      }

      if (history_list[pos].opponents != null) {
        opponents = history_list[pos].opponents;
      }

      //Utils().customPrint("_userRegistrations => ${_userRegistrations.opponents[0].transactionIds}");

    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: _url != null && _url.isNotEmpty
                      ? Image(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          image: NetworkImage(_url)

                          // AssetImage('assets/images/images.png'),
                          )
                      : AssetImage('assets/images/images.png'),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Detail"),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                child: Image.asset(
                  ImageRes().iv_info,
                  width: 18,
                  height: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/store_back.png"))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                decoration: BoxDecoration(
                    color: AppColor().whiteColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${eventdata != null ? eventdata.name : ''}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        opponents != null &&
                                opponents.length > 0 &&
                                opponents[0].createdAt != null
                            ? getStartTimeHHMMSS(opponents[0].createdAt)
                            : "",
                        style: TextStyle(
                            color: AppColor().wallet_medium_grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Entry Fee",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                          Text(
                            "\u{20B9} ${eventdata != null && eventdata.entry != null && eventdata.entry.fee != null ? eventdata.entry.fee.value ~/ 100 : "Free"}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Rank",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                          Text(
                            "${history_list != null && history_list.length > 0 && history_list[pos].rounds[0].result != null ? history_list[pos].rounds[0].result.rank : "--"}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Score",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                          Text(
                            "${history_list != null && history_list.length > 0 && history_list[pos].rounds[0].result != null ? history_list[pos].rounds[0].result.score : "--"}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        height: 13,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Winning",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                          Text(
                            "${history_list != null && history_list.length > 0 && history_list[pos].prizeAmount != null ? (history_list[pos].prizeAmount.value) / 100 : "--"}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        height: 13,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transaction id ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Inter",
                                color: Colors.black),
                          ),
                          Row(
                            children: [
                              Text(
                                "${history_list.length > 0 ? history_list[pos].transactionIds != null ? history_list[pos].transactionIds.depositTransactionId ?? history_list[pos].transactionIds.bonusTransactionId ?? history_list[pos].transactionIds.bonusTransactionId ?? '--' : "--" : "--"}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Inter",
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Image(
                                  height: 15,
                                  width: 15,
                                  color: Colors.black,
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/ic_copy.webp',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              var eventName = "event_track_report";
                              var eventProperties = {
                                "Order Id":
                                    '${history_list.length > 0 ? history_list[pos].transactionIds != null ? history_list[pos].transactionIds.depositTransactionId ?? history_list[pos].transactionIds.bonusTransactionId ?? history_list[pos].transactionIds.bonusTransactionId ?? '--' : "--" : "--"}',
                                "type": "unity game"
                              };
                              Freshchat.trackEvent(eventName,
                                  properties: eventProperties);
                              Freshchat.showConversations(
                                  filteredViewTitle: "Order Queries",
                                  tags: ["Order Queries"]);
                            },
                            child: Container(
                              height: 22,
                              width: 64,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().button_bg_light,
                                    AppColor().button_bg_dark,
                                  ],
                                ),
                                border: Border.all(
                                    color: AppColor().whiteColor, width: 1.5),
                                borderRadius: BorderRadius.circular(30),

                                // color: AppColor().whiteColor
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "REPORT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Inter",
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            "assets/images/rectangle_orange_gradient_box.png")),
                    //color: AppColor().colorPrimary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RANK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          color: Colors.white),
                    ),
                    Text(
                      "Winning".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  alignment: Alignment.center,
                  child: opponents != null && opponents.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: opponents.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return getUserListWidget(context, index);
                          })
                      : Container(
                          height: 0,
                        )),
            ],
          ),
        ),
      ),
    );
  }

  //listView
  Widget getUserListWidget(BuildContext context, int index) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/gradient_rectangular.png")),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      //   borderRadius: BorderRadius.circular(0),
      //border: Border.all(width: 1, color: Colors.white),
      //color: AppColor().optional_payment),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  "${opponents[index] != null && opponents[index].rounds != null && opponents[index].rounds.length > 0 && opponents[index].rounds[0].result != null && opponents[index].rounds[0].result.rank != null ? opponents[index].rounds[0].result.rank : "--"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, fontFamily: "Inter", color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/images.png'),
                    ),
                  ),
                ),
                /*   CircleAvatar(
                  radius: 12,
                  child: Image.asset("assets/images/ic_link.webp"),
                  backgroundColor: Colors.transparent,
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "${opponents[index].housePlayerName ?? opponents[index].userId.username}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Inter", color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              "\u{20B9} ${opponents != null && opponents.length > 0 ? opponents[index].prizeAmount != null ? opponents[index].prizeAmount.value ~/ 100 : ' 0' : "0"}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, fontFamily: "Roboto", color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String getStartTimeHHMMSS(String date_c) {
    return DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date_c, true).toLocal());
  }
}
