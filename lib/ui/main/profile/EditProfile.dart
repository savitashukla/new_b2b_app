import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmng/res/AppString.dart';
import 'package:gmng/ui/controller/EditProfileController.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';

class EditProfile extends StatelessWidget {
  EditProfileController controller_edit = Get.find();

  @override
  Widget build(BuildContext context) {
    //Utils().customPrint("edut name ${controller_edit.profileDataRes.value!=null && controller_edit.profileDataRes.value.name!=null?controller_edit.profileDataRes.value.name.first:""}");
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/store_top.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Text("Edit Profile".tr),
        )),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/store_back.png"))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 20),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImageRes().leader_board_rank_back)),
                    borderRadius: BorderRadius.circular(15)),
                height: 200,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor().colorPrimary,
                        radius: MediaQuery.of(context).size.height / 15,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: MediaQuery.of(context).size.height / 15.5,
                          child: Obx(() => controller_edit.iamges1.value !=
                                      null &&
                                  controller_edit.pickedFile != null
                              ? CircleAvatar(
                                  radius: MediaQuery.of(context).size.height,
                                  backgroundImage:
                                      FileImage(controller_edit.iamges1.value),
                                )
                              : Obx(
                                  () => controller_edit.profileDataRes.value !=
                                              null &&
                                          controller_edit
                                                  .profileDataRes.value.photo !=
                                              null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(70),
                                          ),
                                          child: CachedNetworkImage(
                                            width: 107,
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                ("${controller_edit.profileDataRes.value.photo.url}"),
                                          ))
                                      : Center(
                                          child: Image(
                                          height: 30,
                                          image:
                                              AssetImage(ImageRes().team_group),
                                        )),
                                )),
                        ),
                      ),
                      Positioned(
                        bottom: 12.5,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            controller_edit.getFromGallery();
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor().colorPrimary,
                            radius: 12.5,
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              cusText("First Name".tr),
              SizedBox(
                height: 3,
              ),
              _editTitleTextField(
                  controller_edit.user_name, "Enter First Name"),
              SizedBox(
                height: 10,
              ),
              cusText("Last Name".tr),
              SizedBox(
                height: 3,
              ),
              _editTitleTextField(controller_edit.full_name, "Enter Last Name"),
              SizedBox(
                height: 10,
              ),
              cusText("Email Id".tr),
              SizedBox(
                height: 3,
              ),
              _editTitleTextField(controller_edit.email_id, "Enter Email Id"),
              SizedBox(
                height: 10,
              ),
              cusText("Discord ID".tr),
              SizedBox(
                height: 3,
              ),
              _editTitleTextField(
                  controller_edit.discord_id, "Enter Discord Id"),
              SizedBox(
                height: 10,
              ),
              cusText("BIO".tr),
              SizedBox(
                height: 3,
              ),
              _editTitleTextField(controller_edit.bio, "Enter BIO"),
              SizedBox(
                height: 30,
              ),
              _Button(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editTitleTextField(TextEditingController controllerV, String text) {
    var textEditingController =
        TextEditingController(text: controller_edit.mapKey[text]);
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return Container(
        padding: EdgeInsets.only(bottom: 0),
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: TextField(
          style: TextStyle(color: AppColor().whiteColor),
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: AppColor().reward_card_bg,
            hintStyle: TextStyle(
              color: AppColor().colorGray,
              fontFamily: 'Montserrat',
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            hintText: text,
          ),
          textInputAction: TextInputAction.next,
          controller: textEditingController,
          onChanged: (val) {
            controller_edit.mapKey[text] = val;
            TextSelection previousSelection = textEditingController.selection;
            textEditingController.selection = previousSelection;
          },
        )

        /*TextField(
        style: TextStyle(color: AppColor().whiteColor),
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: AppColor().reward_card_bg,
            hintStyle: TextStyle(color: AppColor().whiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().whiteColor, width: 1.0),
            ),
         */ /*   hintText: "${text ?? ""}"*/ /*),
        onChanged: (textv) {
          controllerV.text=textv;

          controller_edit.mapKey[text] = textv;
          controllerV.selection = TextSelection.fromPosition(
              TextPosition(offset: controllerV.text.length));
         Utils().customPrint("First text field: $textv");
        },
        autofocus: false,
        controller: controllerV,
      ),*/
        );
  }

  Widget _Button(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: RoundedLoadingButton(
          width: MediaQuery.of(context).size.width,
          height: 50,
          //   borderRadius: 10,

          color: AppString.profileUpdate.value == 'inactive'
              ? AppColor().reward_grey_bg
              : AppColor().colorPrimary,
          onPressed: () {
            if (AppString.profileUpdate.value == 'inactive') {
              Fluttertoast.showToast(msg: 'Update disabled!');
              controller_edit.btnControllerProfile.value.reset();
              return;
            }
            if (controller_edit.mapKey["Enter First Name"].toString() == '') {
              controller_edit.btnControllerProfile.value.reset();
              Fluttertoast.showToast(msg: "Please Enter First Name ");
            } else if (controller_edit.mapKey["Enter Last Name"].toString() ==
                '') {
              controller_edit.btnControllerProfile.value.reset();
              Fluttertoast.showToast(msg: "Please Enter Last Name ");
            } else if (!controller_edit
                .isEmail(controller_edit.mapKey["Enter Email Id"])) {
              controller_edit.btnControllerProfile.value.reset();
              Fluttertoast.showToast(msg: "Please Enter valid Email ");
            } else {
              controller_edit.updateProfileUser();
            }
          },
          controller: controller_edit.btnControllerProfile.value,
          child: Container(
            decoration: AppString.profileUpdate.value == 'inactive'
                ? BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            'assets/images/profile_bottom_new.webp')),
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            ImageRes().rectangle_orange_gradient_box)),
                    borderRadius: BorderRadius.circular(10),
                  ),
            child: Center(
              child: Text(
                "Save".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Montserrat',
                    fontStyle: FontStyle.normal,
                    color: AppColor().whiteColor),
              ),
            ),
          )),
    );
  }

  Widget cusText(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            name,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
        )
      ],
    );
  }
}

const double _kCurveHeight = 35;

class ShapesPainter extends CustomPainter {
  Color color;

  ShapesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
