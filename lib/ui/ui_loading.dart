import 'package:flutter/material.dart';

import '../res/AppColor.dart';

void progressbar(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    // transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 200,
          color: AppColor().whiteColor,
          child: Image(
              height: 200,
              width: 200,
              //color: AppColor().whiteColor,
              fit: BoxFit.fill,
              image:AssetImage("assets/images/progresbar_images.gif")),
        ),
      );
    },
  );
}
void hideProgressBar(BuildContext context)
{
  Navigator.of(context).pop();
}
