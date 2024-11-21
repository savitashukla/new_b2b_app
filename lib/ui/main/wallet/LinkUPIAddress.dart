import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/res/FontSizeC.dart';
import 'package:gmng/ui/controller/WithdrawalController.dart';
import 'package:gmng/utills/Utils.dart';

import '../../../res/AppColor.dart';
import '../../../webservices/ApiUrl.dart';

class LinkUPIAddress extends StatelessWidget {
  bool  updateApi;
  String withdrawMethodId;
  LinkUPIAddress( bool updateApi, String withdrawMethodId){
    this.updateApi=updateApi;
    this.withdrawMethodId=withdrawMethodId;
  }
  WithdrawalController controller = Get.put(WithdrawalController());

  @override
  Widget build(BuildContext context) {
    if (ApiUrl().isbb) {

    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        title: Container(
            margin: EdgeInsets.only(right: 50),
            child: Center(child: Text("LINK UPI ADDRESS"))),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/store_back.png"))),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Image(image: AssetImage("assets/images/iv_upi.webp"))),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor().optional_payment),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor().whiteColor),
                    hintText: "Enter your UPI ID "),
                onChanged: (text) {
                  controller.UPI_link.value = text;
                  Utils().customPrint("First text field: $text");
                },
                autofocus: false,
              ),
            ),

          /*  Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor().optional_payment),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor().whiteColor),
                    hintText: "Enter your UPI ID "),
                onChanged: (text) {
                  controller.UPI_link.value = text;
                   Utils().customPrint("First text field: $text");
                },
                autofocus: false,
              ),
            ),*/



            SizedBox(
              height: 30,
            ),


            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                //   Fluttertoast.showToast(msg: controller.UPI_link.value);




                if(updateApi)
                {
                  controller.getWithdrawalUPIUpdate(context,withdrawMethodId);

                  //    controller.getWithdrawalBankUpDate(context,withdrawMethodId);
                //  controller.getWithdrawalBank(context);


                }
                else
                {
                  controller.getWithdrawalUPI(context);
                }



              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor().colorPrimary,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "SUBMIT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Please Note:",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Notes : Make sure that you have entered correct details for UPI /Bank Account. We are unable to cross-verify the details.Your money will be transferred to the added UPI ID / Bank Account if the bank accepts. You can't change the details once you have entered them.\n \n You can view and report your transactions history in the transactions tab in the Wallet Menu. In case of any errors, we will refund your money back into your GMNG account within 7 working days. \n \n Please contact our support in case of any issues. We will help in resolving your concerns.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: FontSizeC().front_small,
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
