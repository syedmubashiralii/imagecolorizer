// // // Natural colorizer: 1coin
// // // Artistic Colorizer: 2 coin
// // // Video Colorizer: 2 coin/6sec

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// // class InAppPurchase extends StatefulWidget {
// //   InAppPurchase({Key? key, required this.title}) : super(key: key);

// //   final String title;

// //   @override
// //   _InAppPurchaseState createState() => _InAppPurchaseState();
// // }

// // class _InAppPurchaseState extends State<InAppPurchase> {
// //   static const String iapId = 'token_colormagic';
// //   List<IAPItem> _items = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     initPlatformState();
// //   }

// //   Future<void> initPlatformState() async {
// //     // prepare
// //     var result = await FlutterInappPurchase.instance.initialize();
// //     debugPrint('result: $result');
// //     if (!mounted) return;

// //     //refresh items for android
// //     //  String msg = await FlutterInappPurchase.instance.consumeAll();
// //     if (kDebugMode) {
// //       // debugPrint('consumeAllItems: $msg');
// //     }
// //     await _getProduct();
// //   }

// //   Future<Null> _getProduct() async {
// //     List<IAPItem> items = await FlutterInappPurchase.instance
// //         .getProducts([iapId, "token_colormagic"]);
// //     log(items.toString());
// //     for (var item in items) {
// //       debugPrint('itemssssss${item.toString()}');
// //       this._items.add(item);
// //     }

// //     setState(() {
// //       this._items = items;
// //     });
// //   }

// //   Future<Null> _buyProduct(IAPItem item) async {
// //     try {
// //       PurchasedItem purchased =
// //           await FlutterInappPurchase.instance.requestPurchase(item.productId!);
// //       debugPrint("dfdfdff$purchased");
// //       if (purchased.isAcknowledgedAndroid!) {}
// //       String msg = await FlutterInappPurchase.instance.consumeAll();
// //       debugPrint('consumeAllItems: $msg');
// //     } catch (error) {
// //       debugPrint('$error');
// //     }
// //   }

// //   List<Widget> _renderButton() {
// //     List<Widget> widgets = this
// //         ._items
// //         .map(
// //           (item) => Container(
// //             height: 250.0,
// //             width: double.infinity,
// //             child: Card(
// //               child: Column(
// //                 children: <Widget>[
// //                   SizedBox(height: 28.0),
// //                   Align(
// //                     alignment: Alignment.center,
// //                     child: Text(
// //                       item.title.toString(),
// //                       style: Theme.of(context).textTheme.headline6,
// //                     ),
// //                   ),
// //                   SizedBox(height: 24.0),
// //                   Align(
// //                     alignment: Alignment.center,
// //                     child: Text(
// //                       item.description.toString(),
// //                       style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
// //                     ),
// //                   ),
// //                   // Align(
// //                   //   alignment: Alignment.center,
// //                   //   child: Text('Which you can buy multiple times',
// //                   //       style:
// //                   //           TextStyle(fontSize: 16.0, color: Colors.grey[700])),
// //                   // ),
// //                   SizedBox(height: 24.0),
// //                   SizedBox(
// //                     width: 340.0,
// //                     height: 50.0,
// //                     child: ElevatedButton(
// //                       onPressed: () => _buyProduct(item),
// //                       child: Text(
// //                         'Buy ${item.price} ${item.currency}',
// //                         style: Theme.of(context).primaryTextTheme.button,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         )
// //         .toList();
// //     return widgets;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: Column(children: this._renderButton()),
// //     );
// //   }
// // }

// class InApp extends StatefulWidget {
//   @override
//   _InAppState createState() => new _InAppState();
// }

// class _InAppState extends State<InApp> {
//   late StreamSubscription _purchaseUpdatedSubscription;
//   late StreamSubscription _purchaseErrorSubscription;
//   late StreamSubscription _conectionSubscription;
//   final List<String> _productLists = Platform.isAndroid
//       ? [
//           'android.test.purchased',
//           'point_1000',
//           '5000_point',
//           'android.test.canceled',
//         ]
//       : ['com.cooni.point1000', 'com.cooni.point5000'];

//   String _platformVersion = 'Unknown';
//   List<IAPItem> _items = [];
//   List<PurchasedItem> _purchases = [];

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   @override
//   void dispose() {
//     if (_conectionSubscription != null) {
//       _conectionSubscription.cancel();
//     }
//     super.dispose();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion = '';
//     // Platform messages may fail, so we use a try/catch PlatformException.

//     // prepare
//     var result = await FlutterInappPurchase.instance.initialize();
//     print('result: $result');

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });

//     // refresh items for android
//     try {
//       // String msg = await FlutterInappPurchase.instance.consumeAll();
//       // print('consumeAllItems: $msg');
//     } catch (err) {
//       print('consumeAllItems error: $err');
//     }

//     _conectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//       print('connected: $connected');
//     });

//     _purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen((productItem) {
//       print('purchase-updated: $productItem');
//     });

//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//       print('purchase-error: $purchaseError');
//     });
//   }

//   void _requestPurchase(IAPItem item) {
//     FlutterInappPurchase.instance.requestPurchase(item.productId!);
//   }

//   Future _getProduct() async {
//     List<IAPItem> items =
//         await FlutterInappPurchase.instance.getProducts(_productLists);
//     for (var item in items) {
//       print('${item.toString()}');
//       this._items.add(item);
//     }

//     setState(() {
//       this._items = items;
//       this._purchases = [];
//     });
//   }

//   Future _getPurchases() async {
//     List<PurchasedItem>? items =
//         await FlutterInappPurchase.instance.getAvailablePurchases();
//     for (var item in items!) {
//       print('${item.toString()}');
//       this._purchases.add(item);
//     }

//     setState(() {
//       this._items = [];
//       this._purchases = items;
//     });
//   }

//   Future _getPurchaseHistory() async {
//     List<PurchasedItem>? items =
//         await FlutterInappPurchase.instance.getPurchaseHistory();
//     for (var item in items!) {
//       print('${item.toString()}');
//       this._purchases.add(item);
//     }

//     setState(() {
//       this._items = [];
//       this._purchases = items;
//     });
//   }

//   List<Widget> _renderInApps() {
//     List<Widget> widgets = this
//         ._items
//         .map((item) => Container(
//               margin: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Container(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 5.0),
//                       child: Text(
//                         item.toString(),
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         print("---------- Buy Item Button Pressed");
//                         this._requestPurchase(item);
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: Container(
//                               height: 48.0,
//                               alignment: const Alignment(-1.0, 0.0),
//                               child: const Text('Buy Item'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ))
//         .toList();
//     return widgets;
//   }

//   List<Widget> _renderPurchases() {
//     List<Widget> widgets = this
//         ._purchases
//         .map((item) => Container(
//               margin: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Container(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 5.0),
//                       child: Text(
//                         item.toString(),
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ))
//         .toList();
//     return widgets;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width - 20;
//     double buttonWidth = (screenWidth / 3) - 20;

//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       child: ListView(
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 child: Text(
//                   'Running on: $_platformVersion\n',
//                   style: const TextStyle(fontSize: 18.0),
//                 ),
//               ),
//               Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Container(
//                         width: buttonWidth,
//                         height: 60.0,
//                         margin: const EdgeInsets.all(7.0),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             print("---------- Connect Billing Button Pressed");
//                             await FlutterInappPurchase.instance.initialize();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             alignment: const Alignment(0.0, 0.0),
//                             child: const Text(
//                               'Connect Billing',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: buttonWidth,
//                         height: 60.0,
//                         margin: const EdgeInsets.all(7.0),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             print("---------- End Connection Button Pressed");
//                             await FlutterInappPurchase.instance.finalize();
//                             if (_purchaseUpdatedSubscription != null) {
//                               _purchaseUpdatedSubscription.cancel();
//                             }
//                             if (_purchaseErrorSubscription != null) {
//                               _purchaseErrorSubscription.cancel();
//                             }
//                             setState(() {
//                               this._items = [];
//                               this._purchases = [];
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             alignment: const Alignment(0.0, 0.0),
//                             child: const Text(
//                               'End Connection',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         Container(
//                             width: buttonWidth,
//                             height: 60.0,
//                             margin: const EdgeInsets.all(7.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 print("---------- Get Items Button Pressed");
//                                 this._getProduct();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                                 alignment: const Alignment(0.0, 0.0),
//                                 child: const Text(
//                                   'Get Items',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                         Container(
//                             width: buttonWidth,
//                             height: 60.0,
//                             margin: const EdgeInsets.all(7.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 print(
//                                     "---------- Get Purchases Button Pressed");
//                                 this._getPurchases();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                                 alignment: const Alignment(0.0, 0.0),
//                                 child: const Text(
//                                   'Get Purchases',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                         Container(
//                             width: buttonWidth,
//                             height: 60.0,
//                             margin: const EdgeInsets.all(7.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 print(
//                                     "---------- Get Purchase History Button Pressed");
//                                 this._getPurchaseHistory();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                                 alignment: const Alignment(0.0, 0.0),
//                                 child: const Text(
//                                   'Get Purchase History',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                       ]),
//                 ],
//               ),
//               Column(
//                 children: this._renderInApps(),
//               ),
//               Column(
//                 children: this._renderPurchases(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
