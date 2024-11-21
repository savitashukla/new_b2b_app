import 'package:flutter/material.dart';
import 'package:gmng/utills/Platfrom.dart';
import 'package:gmng/utills/Utils.dart';

String _dialogMessage = "Loading...";
enum ProgressDialogType { Normal, Download }

ProgressDialogType _progressDialogType = ProgressDialogType.Normal;
double _progress = 0.0;

bool _isShowing = false;

class ProgessDialog {
  _MyDialog _dialog;
  BuildContext _buildContext, _context;

  ProgessDialog(BuildContext buildContext) {
    _buildContext = buildContext;
  }

  void setMessage(String mess) {
    _dialogMessage = mess;
    debugPrint("ProgressDialog message changed: $mess");
  }

  void update({double progress, String message}) {
    debugPrint("ProgressDialog message changed: ");
    if (_progressDialogType == ProgressDialogType.Download) {
      debugPrint("Old Progress: $_progress, New Progress: $progress");
      _progress = progress;
    }
    debugPrint("Old message: $_dialogMessage, New Message: $message");
    _dialogMessage = message;
    _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void hide() {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(_context).pop();
      Utils().customPrint('ProgressDialog dismissed');
    }
  }

  void show() {
    if (!_isShowing) {
      _dialog = new _MyDialog();
      _isShowing = true;
      Utils().customPrint('ProgressDialog shown');
      showDialog<dynamic>(
        context: _buildContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return Dialog(
              insetAnimationCurve: Curves.easeInOut,
              insetAnimationDuration: Duration(milliseconds: 100),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: _dialog);
        },
      );
    }
  }
}

// ignore: must_be_immutable
class _MyDialog extends StatefulWidget {
  var _dialog = new _MyDialogState();

  update() {
    _dialog.changeState();
  }

  @override
  // ignore: must_be_immutable
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _MyDialogState extends State<_MyDialog> {
  changeState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _isShowing = false;
    Utils().customPrint('ProgressDialog dismissed by back button');
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: Platfrom().isWeb()?MediaQuery.of(context).size.width * 0.12:MediaQuery.of(context).size.width*80,
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: Platfrom().isWeb()?MediaQuery.of(context).size.width * 0.12:MediaQuery.of(context).size.width*80,
            child: Row(children: <Widget>[
              const SizedBox(width: 15.0),
              SizedBox(
                width: 60.0,
                child: Image.asset(
                  'assets/double_ring_loading_io.gif',
                  package: 'progress_dialog',
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: _progressDialogType == ProgressDialogType.Normal
                    ? Text(_dialogMessage,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700))
                    : Stack(
                        children: <Widget>[
                          Positioned(
                            child: Text(_dialogMessage,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700)),
                            top: 35.0,
                          ),
                          Positioned(
                            child: Text("$_progress~/100",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400)),
                            bottom: 15.0,
                            right: 15.0,
                          ),
                        ],
                      ),
              )
            ])));
  }
}


