import 'package:flutter/material.dart';
class NotificationShow extends StatelessWidget {
  const NotificationShow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/store_back.png"))),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            flexibleSpace: Image(
              image: AssetImage('assets/images/store_top.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Notifications',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.white),
                ),
                GestureDetector(
                  child: const Text(
                    ' ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Color(0xffE5E5E5),
                    ),
                  ),
                ),
                Container(
                    child: GestureDetector(
                      onTap: () {
                      //  showDialogBox(context);

                        //shareProfile();
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                        ),
              ],
            ),
          ),
          body: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                  5, 30, 5, 20),
              itemCount:
            4,
              itemBuilder: (BuildContext context,
                  int index) {
                if (index >= 0) {
                  return listItem(context, index);
                } else {
                  return Container(
                    alignment: Alignment.center,
                    transformAlignment:
                    Alignment.center,
                    // height: 780,
                    //  width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(
                                30))),
                    child: const Text(
                      'You have not received any notification yet.',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              })),
    );
  }

  Widget listItem(BuildContext context, int index) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            // flex: 7,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 13, bottom: 13, left: 14, right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: Text(
                          "sdvfbn",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: Text(
                          "asdfg",
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Text(
                   "sadfghjdfghjkl;kjhgfdhjkl;kjhgfdhjklkjhgfdghjhgfdfhjkjhgfdfhjkjhghkjhg",
                    textAlign: TextAlign.left,
                    style: const TextStyle(

                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    textDirection: TextDirection.ltr,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
