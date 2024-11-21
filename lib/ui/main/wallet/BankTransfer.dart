import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmng/utills/Utils.dart';

import '../../../res/AppColor.dart';
import '../../../res/FontSizeC.dart';
import '../../../webservices/ApiUrl.dart';
import '../../controller/WithdrawalController.dart';

class BankTransfer extends StatelessWidget {

  bool  updateApi;
  String withdrawMethodId;
  BankTransfer( bool updateApi, String withdrawMethodId){
    this.updateApi=updateApi;
    this.withdrawMethodId=withdrawMethodId;
  }
  WithdrawalController controller = Get.put(WithdrawalController());

  @override
  Widget build(BuildContext context) {
    controller
        .getLocationPer()
        .then((value) => controller.getCurrentLocation());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        title: Container(
            margin: EdgeInsets.only(right: 50),
            child: Center(child: Text("BANK TRANSFER"))),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/store_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor().optional_payment),
              child: TextField(
                style: TextStyle(color: AppColor().whiteColor),

                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor().whiteColor),
                    hintText: "Account Number"),
                onChanged: (text) {
                  controller.accountNumber.value = text;

                  Utils().customPrint("First text field: $text");
                },
                autofocus: false,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor().optional_payment),
              child: TextField(
                style: TextStyle(color: AppColor().whiteColor),

                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor().whiteColor),
                    hintText: "Confirm Account Number"),

                onChanged: (text) {
                  controller.accountNumberConfirm.value = text;
                  Utils().customPrint("First text field: $text");
                },
                autofocus: false,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor().optional_payment),
              child: TextField(
                style: TextStyle(color: AppColor().whiteColor),

                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor().whiteColor),
                    hintText: "IFSC Code(11 Characters)"),
                onChanged: (text) {
                  controller.accountIFSCCode.value = text;
                  Utils().customPrint("First text field: $text");
                },
                autofocus: false,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor().optional_payment),
              child: TextField(
                style: TextStyle(color: AppColor().whiteColor),

                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor().whiteColor),
                    hintText: "Account Holder Name"),
                onChanged: (text) {
                  controller.accountholderName.value = text;

                  Utils().customPrint("First text field: $text");
                },
                autofocus: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ApiUrl().isbb
                ? Container(
                    padding: EdgeInsets.only(bottom: 0, left: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor().optional_payment),
                    child: TextField(
                      style: TextStyle(color: AppColor().whiteColor),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Residencial Address",
                          hintStyle: TextStyle(color: AppColor().whiteColor)),
                      textInputAction: TextInputAction.next,
                      controller: controller.fullAddress,
                      onChanged: (val) {
                        controller.fullAddress.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: controller.fullAddress.text.length));
                        TextSelection previousSelection =
                            controller.fullAddress.selection;
                        controller.fullAddress.selection = previousSelection;
                      },
                    ))
                : Container(
                    height: 0,
                  ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {


                if(updateApi)
                  {
                    controller.getWithdrawalBankUpDate(context,withdrawMethodId);
                  }
                else
                  {
                    controller.getWithdrawalBank(context);

                  }

              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor().colorPrimary,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "LINK BANK ACCOUNT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FontSizeC().front_medium,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 15),
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
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: ApiUrl().isbb
                    ? Text(
                  "Notes : Make sure that you have entered correct details for  Bank Account. We are unable to cross-verify the details.Your money will be transferred to the added  Bank Account if the bank accepts. You can't change the details once you have entered them.\n \n You can view and report your transactions history in the transactions tab in the Wallet Menu. In case of any errors, we will refund your money back into your GMNG account within 7 working days. \n \n Please contact our support in case of any issues. We will help in resolving your concerns.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: FontSizeC().front_small,
                            fontStyle: FontStyle.normal,
                            color: Colors.white),
                      )
                    : Text(
                        "Notes : Make sure that you have entered correct details for  UPI /Bank Account. We are unable to cross-verify the details.Your money will be transferred to the added UPI ID / Bank Account if the bank accepts. You can't change the details once you have entered them.\n \n You can view and report your transactions history in the transactions tab in the Wallet Menu. In case of any errors, we will refund your money back into your GMNG account within 7 working days. \n \n Please contact our support in case of any issues. We will help in resolving your concerns.",
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
