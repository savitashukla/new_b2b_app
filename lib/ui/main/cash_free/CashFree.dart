import 'dart:convert';
import 'dart:typed_data';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';

class cashFree extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<cashFree> {
  var _selectedApp = [];

  Map<String, dynamic> getUserSemmar;
  List<dynamic> dynamicqawert;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUPIList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cashfree SDK Sample'),
        ),
        body: Column(
          children: [
            Center(
              child: GestureDetector(
                child: Text('WEB CHECKOUT'),
                /* onTap: () async {
                    await getUPIList();
                  }*/
                onTap: () => makePayment(),
              ),
            ),


            SizedBox(height: 30,),
            Center(
              child: GestureDetector(
                child: Text('SEAMLESS CARD'),
                onTap: () => seamlessCardPayment(),
              ),
            ),
            Center(
              child: GestureDetector(
                child: Text('SEAMLESS NETBANKING'),
                onTap: () => seamlessNetbankingPayment(),
              ),
            ),
            Center(
              child: GestureDetector(
                child: Text('SEAMLESS WALLET'),
                onTap: () => seamlessWalletPayment(),
              ),
            ),
            Center(
              child: GestureDetector(
                child: Text('SEAMLESS UPI COLLECT'),
                onTap: () => seamlessUPIPayment(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 150,
              child: _selectedApp.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedApp.length,
                      itemBuilder: (BuildContext context, index) {
                        return UPIList(context, index);
                      })
                  : Container(
                      child: Text("fghjk"),
                    ),
            ),
            Center(
              child: GestureDetector(
                child: Text('SEAMLESS PAYPAL'),
                onTap: () => seamlessPayPalPayment(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text('UPI INTENT'))),
                onTap: () => makeUpiPayment(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 45,
                color: Colors.blueAccent,
                child: GestureDetector(
                  child: Text('GET INSTALLED UPI APPS'),
                  onTap: () => getUPIApps(),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                child: Text('SEAMLESS UPI INTENT'),
                onTap: () => seamlessUPIIntent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUPIApps() {
    CashfreePGSDK.getUPIApps().then((value) => {
          if (value != null && value.length > 0)
            {
              // _selectedApp = value[2],

              for (int val = 0; val < value.length; val++)
                {
                  setState(() {
                    _selectedApp.add(value[val]);
                  }),
                },

              print("call dattacalll"),
              print(_selectedApp),
              // print(_selectedApp["id"]),
            }
          else
            {
              print("call dattanot rec"),
            }
        });
  }

  // WEB Intent
  makePayment() {
    //Replace with actual values
    String orderId = "Order000103";
    String stage = "TEST";
    String orderAmount = "1";
    String tokenData = "Hl9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.DQ0nI0IDZ0UGZ2QGNjZ2M2IiOiQHbhN3XiwyN3ITM3ADM4YTM6ICc4VmIsIiUOlkI6ISej5WZyJXdDJXZkJ3biwSM6ICduV3btFkclRmcvJCLiMDMxADMwIXZkJ3TiojIklkclRmcvJye.vyVVGr_joE2O0MDM62C10RpPzEuX6B2STWdI5YrEfeoTerCDocHOoKMOuZQSBMB09A";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "2941898caf4124a4904ae9cfe3981492";
    String customerPhone = "6307558161";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://sandbox.cashfree.com";

    Map<String, dynamic> inputParams = {

      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,
      "paymentOption": ""
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));

  }

  // SEAMLESS - CARD
  Future<void> seamlessCardPayment() async {
    String orderId = "Order00011";
    String stage = "TEST";
    String orderAmount = "1";
    String tokenData = "rl9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.PDQfiYWN1IWZhFGMxcjZzYjI6ICdsF2cfJCLyQDM4IzN5cjNxojIwhXZiwiIS5USiojI5NmblJnc1NkclRmcvJCLxojI05Wdv1WQyVGZy9mIsISMxADMwIXZkJ3TiojIklkclRmcvJye.zrvNKOuqwiTZSF3m41ygtjEy0RI8wj6pXq9_v3BUyzflNl4UV4gL9Uob-NqjZXV4ie";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String customerPhone = "6307558161";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "card",
      "card_number": "4706131211212123",
      "card_expiryMonth": "07",
      "card_expiryYear": "2023",
      "card_holder": "Test",
      "card_cvv": "123"
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  // SEAMLESS - NETBANKING
  Future<void> seamlessNetbankingPayment() async {
    String orderId = "Order0003";
    String stage = "TEST";
    String orderAmount = "1";
    String tokenData =
        "5P9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.b39JyYzEDNjRDMhhzMlNjNiojI0xWYz9lIsgDOzgDN0gzN2EjOiAHelJCLiIlTJJiOik3YuVmcyV3QyVGZy9mIsEjOiQnb19WbBJXZkJ3biwiIzADMwIXZkJ3TiojIklkclRmcvJye.RVEayYVEKLGhzqgIzqSz24rxK4Z1COtvSdOYt4TT63Ytj182FPLbp74kvcPIxFvl1K";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String customerPhone = "6307558161";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "nb",
      "paymentOption": "Indian Bank",
      "paymentCode": "3026",
      // Find Code here https://docs.cashfree.com/docs/net-banking
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  // SEAMLESS - WALLET
  Future<void> seamlessWalletPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String customerPhone = "Customer Phone";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "wallet",
      "paymentCode": "ENTER Code",
      // Find Code here https://docs.cashfree.com/docs/wallets
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  // SEAMLESS - UPI
  Future<void> seamlessUPIPayment() async {
    String orderId = "GZ-212";
    String stage = "TEST";
    String orderAmount = "10";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "Order0001";
    String customerPhone = "6307558161";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,
      "paymentOption": "upi",
      "upi_vpa": "shukla.savita208@okhdfcbank"
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  // SEAMLESS - Paypal
  Future<void> seamlessPayPalPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String customerPhone = "Customer Phone";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "paypal"
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  // UPI Intent
  Future<void> makeUpiPayment() async {
    // print(_selectedApp["id"]);
    //Replace with actual values
    String orderId = "Order00013";
    String stage = "TEST";
    String orderAmount = "1";
    String tokenData =
        "jz9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.BPQfiUTYiNzN0UmN2ImZzYjI6ICdsF2cfJCLwYjMyEDMwgjNxojIwhXZiwiIS5USiojI5NmblJnc1NkclRmcvJCLxojI05Wdv1WQyVGZy9mIsIyMxADMwIXZkJ3TiojIklkclRmcvJye.9U4ttxm3vxXmBPMSqeQSzFzk700E_U0RLC0ZeTams5U2NyxinFkfEN7-1XM2jpwfqB";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String customerPhone = "6307558161";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doUPIPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print(">>>>>>>>>>>>>>>>>$key : $value");
              //Do something with the result
            }));
  }

  // SEAMLESS UPI Intent
  Future<void> seamlessUPIIntent() async {
    //Replace with actual values
    String orderId = "Order0007";
    String stage = "TEST";
    String orderAmount = "1";
    String customerPhone = "6307558161";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "31470076b6c755aa35dac07283007413";
    String tokenData =
        "BN9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.rH9JCNyYTZ1cTZ0ATYlNjNiojI0xWYz9lIsMjNwMzN4gzN2EjOiAHelJCLiIlTJJiOik3YuVmcyV3QyVGZy9mIsEjOiQnb19WbBJXZkJ3biwiI3ADMwIXZkJ3TiojIklkclRmcvJye.zPjxkxYl6AjeL1KWdVCMcHVv8XWEyk64xkE6uYJIFvO7WFfKHI01PqhFZsvzlRNeg0";
    String customerName = "Customer Name";
    String customerEmail = "savita@gmng.pro";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,
      "appName": _selectedApp[0]["id"]
    };

    CashfreePGSDK.doUPIPayment(inputParams)
        .then((value) => value.forEach((key, value) {
              print("$key : $value");
              //Do something with the result
            }));
  }

  Future<void> getUPIList() async {
    CashfreePGSDK.getUPIApps().then((value) => {
          if (value != null && value.length > 0)
            {
              for (int val = 0; val < value.length; val++)
                {
                  setState(() {
                    _selectedApp.add(value[val]);
                  }),
                },
              print(_selectedApp),

              // print(_selectedApp["id"]),
            }
          else
            {
              print("call dattanot rec"),
            }
        });
  }

  UPIList(BuildContext context, int index) {
    Uint8List _imageBytesDecoded;
    _imageBytesDecoded = Base64Codec().decode(_selectedApp[index]["icon"]);
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 50,
          width: 50,
          child: Center(
            // child: Text("call ${_selectedApp[index]["displayName"]}"),
            child: _imageBytesDecoded != null
                ? Image.memory(
                    _imageBytesDecoded,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image),
          ),
        ),
      ),
    );
  }
}
