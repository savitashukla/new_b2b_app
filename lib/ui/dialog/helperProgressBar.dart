import 'package:flutter/material.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

var progressDialog;
showProgress(BuildContext context, String message, bool isDismissible) async {
  Utils().customPrint('ProgressBarClick: showProgress');
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: isDismissible,
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
        ),
      );
    },
  );
}

showProgressUnity(
    BuildContext context, String message, bool isDismissible) async {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: false,
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

hideProgress(BuildContext context) async {
  Utils().customPrint('ProgressBarClick: hideProgress');
  Navigator.pop(context);
}

showProgressD(BuildContext context, String message, bool isDismissible) async {
  progressDialog = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  await progressDialog.show();
}

//new progress bar not dissmissible
showProgressDismissible(
    BuildContext context, String message, bool isDismissible) async {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: isDismissible,
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
