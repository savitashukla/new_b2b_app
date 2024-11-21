import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/ui/main/cash_free/CashFreeController.dart';
import 'package:gmng/utills/Utils.dart';

import '../../../res/AppColor.dart';
import '../../controller/WalletPageController.dart';

class ViewAllPromoCodes extends StatefulWidget {
  const ViewAllPromoCodes({Key key}) : super(key: key);

  @override
  State<ViewAllPromoCodes> createState() => _ViewAllPromoCodesState();
}

class _ViewAllPromoCodesState extends State<ViewAllPromoCodes> {
  WalletPageController walletPageController = Get.put(WalletPageController());
  CashFreeController cashFreeController = Get.put(CashFreeController());
  bool isSwitch = false;
  bool moreBool = false;
  var buttonText = '+MORE';
  bool click = true;
  int indexClick;
  String buttonApplyText = 'Apply'.tr;

  @override
  void initState() {
    /*if (walletPageController.promocode.value != '') {
      buttonApplyText = 'Remove';
    } else {
      buttonApplyText = 'Apply';
    }*/

    print('buttonApplyText : ${buttonApplyText}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Text("Offers".tr), //and Promotions
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                      child: Text(
                        "Offers".tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: CupertinoSwitch(
                        value: isSwitch,
                        activeColor: AppColor().colorPrimary,
                        onChanged: (value) {
                          setState(() {
                            isSwitch = value;
                            Utils().customPrint(isSwitch);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                      child: Text(
                        "Promotions",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 5, left: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent),
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,

                        //keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        //controller: walletPageController.amountTextController.value,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: AppColor().whiteColor),
                            hintText: walletPageController.promocode.value != ''
                                ? walletPageController.promocode.value
                                    .toUpperCase()
                                : "Enter Code".tr),
                        onChanged: (text) {
                          walletPageController.promocode.value = text;
                        },
                        //autofocus: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        //test
                        if (buttonApplyText == 'Remove') {
                          click = false;
                          walletPageController.amtAfterPromoApplied.value = 0;
                          walletPageController.gameListSelectedColor.value =
                              1000;
                          walletPageController.youWillGet.value = '';
                          walletPageController.promocode.value = '';
                          walletPageController.walletTypePromocode = '';
                          walletPageController.percentagePromocode = '';

                          buttonApplyText = 'Apply'.tr;
                          Fluttertoast.showToast(msg: "Offer Removed!");
                          setState(() {});
                          return;
                        }
                        if (walletPageController
                                    .amountTextController.value.text ==
                                "" ||
                            walletPageController
                                    .amountTextController.value.text ==
                                "0") {
                          Fluttertoast.showToast(msg: "Please enter amount!");
                          return;
                        }
                        if (walletPageController
                                .amountTextController.value.text.length >
                            7) {
                          Fluttertoast.showToast(
                              msg: "Deposit limit exceeded!");
                          return;
                        }

                        if (walletPageController.promocode.value == '') {
                          Fluttertoast.showToast(msg: "Please enter code!");
                        } else {
                          //code checking for offline codes
                          bool temp = false;
                          for (int i = 0;
                              i <
                                  walletPageController
                                      .walletModelPromoFull.data.length;
                              i++) {
                            Utils().customPrint(
                                "PROMOCODE Loop code ${walletPageController.walletModelPromoFull.data[i].code}");

                            if (walletPageController.promocode.value
                                    .toLowerCase() ==
                                walletPageController
                                    .walletModelPromoFull.data[i].code
                                    .toLowerCase()) {
                              //validation
                              double enterAmtInt = double.parse(
                                  walletPageController
                                      .amountTextController.value.text);
                              double fromValue = double.parse(
                                  walletPageController
                                      .walletModelPromoFull.data[i].fromValue);
                              double toValue = double.parse(walletPageController
                                  .walletModelPromoFull.data[i].toValue);
                              Utils().customPrint('Offer Valid F ${fromValue}');
                              Utils().customPrint('Offer Valid T ${toValue}');

                              if (enterAmtInt < fromValue) {
                                Fluttertoast.showToast(
                                    textColor: Colors.red,
                                    msg:
                                        'Offer Valid On Deposit for ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
                                return;
                              } else if (enterAmtInt > toValue) {
                                Fluttertoast.showToast(
                                    textColor: Colors.red,
                                    msg:
                                        'Offer Valid On Deposit for ${walletPageController.walletModelPromoFull.data[i].fromValue} - ${walletPageController.walletModelPromoFull.data[i].toValue} Rs!');
                                return;
                              }

                              //promo code
                              promo_code_not_visible(
                                  walletPageController
                                      .amountTextController.value.text,
                                  i);
                              Utils().customPrint(
                                  "PROMOCODE Applied: ${walletPageController.promocode.value}");

                              temp = true;
                              break;
                            } else {
                              Utils().customPrint(
                                  "PROMOCODE Invalid: ${walletPageController.promocode.value}");
                              temp = false;
                            }
                          }
                          //check
                          if (temp == true) {
                            Fluttertoast.showToast(msg: "Offer Applied!");
                            Navigator.pop(context);
                          } else if (temp == false) {
                            Fluttertoast.showToast(msg: "Offer Invalid!");
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    "assets/images/rectangle_orange_gradient_box.png")),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(buttonApplyText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10),
              child: ListView.builder(
                  itemCount: walletPageController.walletModelPromo.data.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, int index) {
                    return promo_code_design(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //new code for design
  Widget promo_code_design(int index) {
    return GestureDetector(
      onTap: () {
        if (walletPageController.amountTextController.value.text == "" ||
            walletPageController.amountTextController.value.text == "0") {
          Fluttertoast.showToast(msg: "Please enter amount!");
          return;
        }
        if (walletPageController.amountTextController.value.text.length > 7) {
          Fluttertoast.showToast(msg: "Deposit limit exceeded!");
          return;
        }
        //start click work
        if (buttonApplyText == 'Remove' &&
            walletPageController.gameListSelectedColor.value == index) {
          click = false;
          walletPageController.amtAfterPromoApplied.value = 0;
          walletPageController.gameListSelectedColor.value = 1000;
          walletPageController.youWillGet.value = '';
          walletPageController.promocode.value = '';
          walletPageController.walletTypePromocode = '';
          walletPageController.percentagePromocode = '';

          buttonApplyText = 'Apply'.tr;
          walletPageController.click = false;
          Fluttertoast.showToast(msg: "Offer Removed!");
          setState(() {});
          return;
        }

        //end click work
        //validation
        double enterAmtInt =
            double.parse(walletPageController.amountTextController.value.text);
        double fromValue = double.parse(
            walletPageController.walletModelPromo.data[index].fromValue);
        double toValue = double.parse(
            walletPageController.walletModelPromo.data[index].toValue);
        Utils().customPrint('Offer Valid F ${fromValue}');
        Utils().customPrint('Offer Valid T ${toValue}');

        if (enterAmtInt < fromValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index].fromValue} - ${walletPageController.walletModelPromo.data[index].toValue} Rs!');

          return;
        } else if (enterAmtInt > toValue) {
          Fluttertoast.showToast(
              textColor: Colors.red,
              msg:
                  'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index].fromValue} - ${walletPageController.walletModelPromo.data[index].toValue} Rs!');

          return;
        }

        walletPageController.promocode.value =
            walletPageController.walletModelPromo.data[index].code;
        walletPageController.gameListSelectedColor.value = index;
        Utils()
            .customPrint("PROMOCODE: ${walletPageController.promocode.value}");

        //Fluttertoast.showToast(msg: "Offer Applied!");
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Offer Applied!");
        walletPageController.click = true;
        promo_code(walletPageController.amountTextController.value.text, index);
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 15, top: 0, left: 5),
          child: Container(
            margin: EdgeInsets.only(right: 15),
            //height: 150 ,
            //width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor().whiteColor, width: 1.5),
              // color: AppColor().whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            // : BoxDecoration(
            //     border: Border.all(color: AppColor().whiteColor, width: 2),
            //     borderRadius: BorderRadius.circular(10),
            //     color: AppColor().whiteColor),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => ViewAllPromoCodes());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          "assets/images/info.webp",
                          width: 10,
                          height: 0,
                          color: Colors.white,
                        ),
                      ),
                      /*Container(
                            padding: EdgeInsets.all(5),
                            child: Image.asset("assets/images/info.webp",
                            width: 15, height: 15),
                          ),*/
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 3),
                      child: DottedBorder(
                        color: Colors.white,
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(5),
                        child: Container(
                          //height: 35,
                          //width: 150,
                          padding: EdgeInsets.all(5),
                          /*  decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white, width: .5)),*/
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  walletPageController
                                      .walletModelPromo.data[index].code
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                        height: 35,
                        width: 100,
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 5, bottom: 5),
                        child: Center(
                          child: Text(
                              walletPageController
                                          .gameListSelectedColor.value ==
                                      index
                                  ? "Apply".tr
                                  : "Apply".tr,
                              style: TextStyle(
                                color: walletPageController
                                            .gameListSelectedColor.value ==
                                        index
                                    ? AppColor().colorPrimary
                                    : AppColor().colorPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 27.0, right: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        walletPageController.walletModelPromo.data[index]
                                    .benefit[0].wallet[0].percentage !=
                                'null'
                            ? '${walletPageController.walletModelPromo.data[index].benefit[0].wallet[0].percentage}% '
                                'Cashback in ${walletPageController.walletModelPromo.data[index].benefit[0].wallet[0].type.capitalize}'
                            : '0% ' +
                                'Cashback in ${walletPageController.walletModelPromo.data[index].benefit[0].wallet[0].type.capitalize}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 10),
                  child: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      indexClick = index;
                      if (click) {
                        click = false;
                        moreBool = true;
                      } else {
                        click = true;
                        moreBool = false;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                              height: 7,
                              width: 7,
                              color: Colors.white,
                              fit: BoxFit.fill,
                              image:
                                  AssetImage("assets/images/next_arrow.png")),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  walletPageController.walletModelPromo
                                      .data[index].name.capitalize,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      indexClick = index;
                      if (click) {
                        click = false;
                        moreBool = true;
                      } else {
                        click = true;
                        moreBool = false;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 17.0, right: 5, top: 5, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: double.infinity,
                        child: Text(
                            index == indexClick && moreBool
                                ? buttonText = '- LESS'
                                : buttonText = '+ MORE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: index == indexClick && moreBool,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 5,
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                height: 7,
                                width: 7,
                                color: Colors.white,
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/next_arrow.png")),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        Utils()
                                            .removeAllHtmlTags(
                                                walletPageController
                                                    .walletModelPromo
                                                    .data[index]
                                                    .description)
                                            .capitalize,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        )) /*Html(
                                    data:
                                    walletPageController.walletModelPromo.data[index].description.capitalize,
                                    style: {
                                     */ /* "body": Style(
                                          fontSize: FontSize(11.0),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),*/ /*
                                      "p": Style(
                                        fontSize: FontSize(12.0),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    },
                                  ),*/
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                height: 7,
                                width: 7,
                                color: Colors.white,
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/next_arrow.png")),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Max Cashback ${walletPageController.walletModelPromo.data[index].benefit[0].wallet[0].percentage}%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 5,
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                height: 7,
                                width: 7,
                                color: Colors.white,
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/next_arrow.png")),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Offer Valid On Deposit for ${walletPageController.walletModelPromo.data[index].fromValue} - ${walletPageController.walletModelPromo.data[index].toValue} Rs',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 5,
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                height: 7,
                                width: 7,
                                color: Colors.white,
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/next_arrow.png")),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'COUPON can be applied Only ${walletPageController.walletModelPromo.data[index].perUser} times',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5, bottom: 5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                height: 7,
                                width: 7,
                                color: Colors.white,
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/next_arrow.png")),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Offer valid upto ${getStartTimeHHMMSS(walletPageController.walletModelPromo.data[index].dateTo)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getStartTimeHHMMSS(String date_c) {
    Utils().customPrint('newStr $date_c');
    //var str = date_c;
    if (date_c != null) {
      String newStr = date_c.substring(0, 10) + ' ' + date_c.substring(12, 19);
      Utils().customPrint('newStr $newStr'); // 2019-04-05 14:00:51.000
      // 2022-11-07T11:59:36.134Z
      return newStr;
    }
  }

  //ListView Promo-codes design // REMOVED
  Widget promo_code_design1(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
      child: Container(
        //color: Colors.white,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor().whiteColor, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: AppColor().whiteColor),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor().whiteColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor().colorPrimary),
                //color: AppColor().colorPrimary,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Center(
                    child: Text(
                      "Limited time",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                height: 150,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      /*   decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: .5)),*/
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                                walletPageController
                                    .walletModelPromo.data[index].code
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (walletPageController
                                          .amountTextController.value.text ==
                                      "" ||
                                  walletPageController
                                          .amountTextController.value.text ==
                                      "0") {
                                Fluttertoast.showToast(
                                    msg: "Please enter amount!");
                                return;
                              }
                              if (walletPageController
                                      .amountTextController.value.text.length >
                                  7) {
                                Fluttertoast.showToast(
                                    msg: "Deposit limit exceeded!");
                                return;
                              }
                              walletPageController.promocode.value =
                                  walletPageController
                                      .walletModelPromo.data[index].code;
                              walletPageController.gameListSelectedColor.value =
                                  index;
                              Utils().customPrint(
                                  "PROMOCODE: ${walletPageController.promocode.value}");

                              Fluttertoast.showToast(msg: "Offer Applied!");
                              Navigator.pop(context);

                              try {
                                if (walletPageController
                                            .walletModelPromo
                                            .data[index]
                                            .benefit[0]
                                            .wallet[0]
                                            .percentage !=
                                        '' &&
                                    walletPageController
                                            .walletModelPromo
                                            .data[index]
                                            .benefit[0]
                                            .wallet[0]
                                            .maximumAmount !=
                                        '') {
                                  double maxAmtFixed = double.parse(
                                      walletPageController
                                          .walletModelPromo
                                          .data[index]
                                          .benefit[0]
                                          .wallet[0]
                                          .maximumAmount);

                                  double percentage = double.parse(
                                      walletPageController
                                          .walletModelPromo
                                          .data[index]
                                          .benefit[0]
                                          .wallet[0]
                                          .percentage);
                                  double enterAmtInt = double.parse(
                                      walletPageController
                                          .amountTextController.value.text);
                                  double calcValuePerc =
                                      ((percentage / 100) * enterAmtInt);
                                  if (calcValuePerc >= maxAmtFixed) {
                                    //+max
                                    walletPageController.amtAfterPromoApplied
                                        .value = enterAmtInt + maxAmtFixed;
                                  } else {
                                    //+calc
                                    walletPageController.amtAfterPromoApplied
                                        .value = enterAmtInt + calcValuePerc;
                                  }
                                  Utils().customPrint(
                                      'applied amount percentage: ${walletPageController.amtAfterPromoApplied.value}');
                                }
                              } catch (e) {
                                Utils().customPrint('applied amount: $e');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5, bottom: 5),
                                /* decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/rectangle_orange_gradient_box.png")),
                                  borderRadius: BorderRadius.circular(5),
                                ),*/
                                child: Text("Apply".toUpperCase(),
                                    style: TextStyle(
                                      color: AppColor().colorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 10),
                        child: Text(
                            walletPageController
                                .walletModelPromo.data[index].name,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0, left: 10, right: 20),
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 8),
                      child: /*Text(walletPageController.walletModelPromo.data[index].description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ))*/
                          Html(
                        data: walletPageController
                            .walletModelPromo.data[index].description,
                        /* onLinkTap: (url, _, __, ___) {
                           Utils().customPrint("Opening $url");
                          makeLaunch(url!);
                        },*/

                        style: {
                          "body": Style(
                            fontSize: FontSize(10.0),
                            fontWeight: FontWeight.normal,
                          ),
                          'h1': Style(
                            color: Colors.red,
                            textAlign: TextAlign.left,
                          ),
                          'p': Style(
                              textAlign: TextAlign.left,
                              color: Colors.black87,
                              alignment: Alignment.topLeft,
                              fontSize: FontSize.small),
                          'ul': Style(
                            textAlign: TextAlign
                                .left, /*margin:  EdgeInsets.only(left: 10)*/
                          )
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void promo_code(var entered_amount, int index_promo) {
    if (index_promo != null) {
      try {
        if (walletPageController.walletModelPromo.data[index_promo].benefit[0]
                    .wallet[0].percentage !=
                '' &&
            walletPageController.walletModelPromo.data[index_promo].benefit[0]
                    .wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletPageController
              .walletModelPromo
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);

          double percentage = double.parse(walletPageController.walletModelPromo
              .data[index_promo].benefit[0].wallet[0].percentage);

          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (walletPageController.walletModelPromo.data[index_promo].benefit[0]
                  .wallet[0].type ==
              'bonus') {
            //bonus
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Bonus';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Bonus';
            }
          } else if (walletPageController.walletModelPromo.data[index_promo]
                  .benefit[0].wallet[0].type ==
              'coin') {
            //coin

            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Coin';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Coin';
            }
          } else {
            //deposit
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
            }
          }

          //for cleverTap use
          walletPageController.percentagePromocode = percentage.toString();
          walletPageController.walletTypePromocode = walletPageController
              .walletModelPromo.data[index_promo].benefit[0].wallet[0].type;

          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value}');

          //saving values for UI
          //layout hide work & show deposit get UI

          walletPageController.applyPress.value = true;
          walletPageController.boolEnterCode.value = false;
          cashFreeController.click_remove_code = true;
          if (int.parse(walletPageController
                  .walletModelPromo.data[index_promo].fromValue) >
              int.parse(walletPageController.selectAmount.value)) {
            walletPageController.selectAmount.value = int.parse(
                    walletPageController
                        .walletModelPromo.data[index_promo].fromValue)
                .toStringAsFixed(0);
          } else {
            walletPageController.selectAmount.value =
                enterAmtInt.toStringAsFixed(0);
          }
          /////////

          walletPageController.promo_type.value = walletPageController
              .walletModelPromo.data[index_promo].benefit[0].wallet[0].type;

          walletPageController.promo_minus_amt.value = int.parse(
                  walletPageController
                      .walletModelPromo.data[index_promo].fromValue) -
              int.parse(entered_amount);
          ;
          int max_per = int.parse(walletPageController.walletModelPromo
              .data[index_promo].benefit[0].wallet[0].percentage);
          walletPageController.promo_amt.value =
              (enterAmtInt * (max_per / 100));

          walletPageController.typeTextCheck.value = 2; //eqauls
          /*   walletPageController.profitAmt.value =
                                              enteredValue +
                                                  walletPageController
                                                      .promo_amt.value;*/
          //promocodeHelper.value = walletPageController.walletModelPromo.data[index_promo].code;

          walletPageController.promo_maximumAmt.value = int.parse(
              walletPageController.walletModelPromo.data[index_promo].benefit[0]
                  .wallet[0].maximumAmount);
          if (walletPageController.promo_amt.value >
              walletPageController.promo_maximumAmt.value) {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                double.parse(
                    walletPageController.promo_maximumAmt.value.toString());
          } else {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                walletPageController.promo_amt.value;
          }

          Utils().customPrint(
              'PROMOCODES View All 2 apply click *******************  '
              'CODE: ${walletPageController.walletModelPromo.data[index_promo].code} |'
              'TYPE: ${walletPageController.walletModelPromo.data[index_promo].benefit[0].wallet[0].type} |'
              '%: ${walletPageController.walletModelPromo.data[index_promo].benefit[0].wallet[0].percentage}% |'
              ' calc%: ${walletPageController.promo_amt.value} |'
              'FROM: ${walletPageController.walletModelPromo.data[index_promo].fromValue}|'
              'TO: ${walletPageController.walletModelPromo.data[index_promo].toValue}|'
              'GET AMT: ${walletPageController.profitAmt.value}|'
              'MAX: ${walletPageController.promo_maximumAmt.value}');
        }
      } catch (e) {
        Utils().customPrint('applied amount: $e');
      }
    } else {
      //for dynamic showing value in 'You'll get' place.
      walletPageController.amtAfterPromoApplied.value =
          double.parse(entered_amount);
      walletPageController.youWillGet.value =
          '${entered_amount.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
    }
  }

  void promo_code_not_visible(var entered_amount, int index_promo) {
    if (index_promo != null) {
      try {
        if (walletPageController.walletModelPromoFull.data[index_promo]
                    .benefit[0].wallet[0].percentage !=
                '' &&
            walletPageController.walletModelPromoFull.data[index_promo]
                    .benefit[0].wallet[0].maximumAmount !=
                '') {
          double maxAmtFixed = double.parse(walletPageController
              .walletModelPromoFull
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .maximumAmount);

          double percentage = double.parse(walletPageController
              .walletModelPromoFull
              .data[index_promo]
              .benefit[0]
              .wallet[0]
              .percentage);
          Utils().customPrint('Offer enterAmtInt F ');
          Utils().customPrint('Offer calcValuePerc T ');
          double enterAmtInt = double.parse(entered_amount);
          double calcValuePerc = ((percentage / 100) * enterAmtInt);

          //conditions
          if (walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].type ==
              'bonus') {
            //bonus
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Bonus';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Bonus';
            }
          } else if (walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].type ==
              'coin') {
            //coin

            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${enterAmtInt} Deposit & ${maxAmtFixed} Coin';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${enterAmtInt.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit & ${calcValuePerc.floor()} Coin';
            }
          } else {
            //deposit
            if (calcValuePerc >= maxAmtFixed) {
              //+max
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + maxAmtFixed;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
            } else {
              //+calc
              walletPageController.amtAfterPromoApplied.value =
                  enterAmtInt + calcValuePerc;
              walletPageController.youWillGet.value =
                  '${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
            }
          }

          //for cleverTap use
          walletPageController.percentagePromocode = percentage.toString();
          walletPageController.walletTypePromocode = walletPageController
              .walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type;

          Utils().customPrint(
              'applied promo code: ${walletPageController.amtAfterPromoApplied.value.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}');

          //saving values for UI
          //layout hide work & show deposit get UI

          walletPageController.applyPress.value = true;
          walletPageController.boolEnterCode.value = false;
          cashFreeController.click_remove_code = true;
          if (int.parse(walletPageController
                  .walletModelPromoFull.data[index_promo].fromValue) >
              int.parse(walletPageController.selectAmount.value)) {
            walletPageController.selectAmount.value = int.parse(
                    walletPageController
                        .walletModelPromoFull.data[index_promo].fromValue)
                .toStringAsFixed(0);
          } else {
            walletPageController.selectAmount.value =
                enterAmtInt.toStringAsFixed(0);
          }
          /////////

          walletPageController.promo_type.value = walletPageController
              .walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type;

          walletPageController.promo_minus_amt.value = int.parse(
                  walletPageController
                      .walletModelPromoFull.data[index_promo].fromValue) -
              int.parse(entered_amount);
          ;
          int max_per = int.parse(walletPageController.walletModelPromoFull
              .data[index_promo].benefit[0].wallet[0].percentage);
          walletPageController.promo_amt.value =
              (enterAmtInt * (max_per / 100));

          walletPageController.typeTextCheck.value = 2; //eqauls
          /*   walletPageController.profitAmt.value =
                                              enteredValue +
                                                  walletPageController
                                                      .promo_amt.value;*/
          //promocodeHelper.value = walletPageController.walletModelPromoFull.data[index_promo].code;

          walletPageController.promo_maximumAmt.value = int.parse(
              walletPageController.walletModelPromoFull.data[index_promo]
                  .benefit[0].wallet[0].maximumAmount);
          if (walletPageController.promo_amt.value >
              walletPageController.promo_maximumAmt.value) {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                double.parse(
                    walletPageController.promo_maximumAmt.value.toString());
          } else {
            walletPageController.profitAmt.value = int.parse(entered_amount) +
                walletPageController.promo_amt.value;
          }

          Utils().customPrint('PROMOCODES View All 2 *******************  '
              'CODE: ${walletPageController.walletModelPromoFull.data[index_promo].code} |'
              'TYPE: ${walletPageController.walletModelPromoFull.data[index_promo].benefit[0].wallet[0].type} |'
              '%: ${walletPageController.walletModelPromoFull.data[index_promo].benefit[0].wallet[0].percentage}% |'
              ' calc%: ${walletPageController.promo_amt.value} |'
              'FROM: ${walletPageController.walletModelPromoFull.data[index_promo].fromValue}|'
              'TO: ${walletPageController.walletModelPromoFull.data[index_promo].toValue}|'
              'GET AMT: ${walletPageController.profitAmt.value}|'
              'MAX: ${walletPageController.promo_maximumAmt.value}');
        }
      } catch (e) {
        //print('applied amount: $e');
        Utils().customPrint('Offer calcValuePerc T $e');
      }
    } else {
      //for dynamic showing value in 'You'll get' place.
      walletPageController.amtAfterPromoApplied.value =
          double.parse(entered_amount);
      walletPageController.youWillGet.value =
          '${entered_amount.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} Deposit';
    }
  }
}
