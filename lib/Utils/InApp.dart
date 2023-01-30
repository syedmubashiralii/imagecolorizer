import 'dart:async';
import 'dart:developer';
import 'package:dioldifi/Controllers/CoinsController.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Controllers/LoginSignUpController.dart';

class inApp extends StatefulWidget {
  @override
  inAppState createState() => inAppState();
}

class inAppState extends State<inApp> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String _productID = '10_token_colormagic';
  final String _productID1 = '25_token_colormagic';

  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      setState(() {
        _purchases.addAll(purchaseDetailsList);
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      _subscription!.cancel();
    });

    _initialize();

    super.initState();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _inAppPurchase.isAvailable();
//test id
//"android.test.purchased"
    List<ProductDetails> products = await _getProducts(
      productIds: <String>{_productID, _productID1},
    );

    setState(() {
      _products = products;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      log("sdhudhshdhsdsud${purchaseDetails.purchaseID}");
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          //  _showPendingUI();
          break;
        case PurchaseStatus.purchased:
          EasyLoading.showToast("Updating Coins");
          if (purchaseDetails.productID == "10_token_colormagic") {
            print(Provider.of<coinsController>(context, listen: false)
                .totalcoins);
            Provider.of<coinsController>(context, listen: false).totalcoins +=
                10;
            print(Provider.of<coinsController>(context, listen: false)
                .totalcoins);
            await LoginSignup()
                .UpdateCoinsandads(
                    Provider.of<coinsController>(context, listen: false)
                        .totalcoins,
                    context,
                    user!.email!)
                .then((value) =>
                    Provider.of<coinsController>(context, listen: false)
                        .updatecoins());
          } else if (purchaseDetails.productID == "25_token_colormagic") {
            print(Provider.of<coinsController>(context, listen: false)
                .totalcoins);
            Provider.of<coinsController>(context, listen: false).totalcoins +=
                10;
            print(Provider.of<coinsController>(context, listen: false)
                .totalcoins);
            await LoginSignup()
                .UpdateCoinsandads(
                    Provider.of<coinsController>(context, listen: false)
                        .totalcoins,
                    context,
                    user!.email!)
                .then((value) =>
                    Provider.of<coinsController>(context, listen: false)
                        .updatecoins());
          }
          break;
        case PurchaseStatus.restored:
          // helper.purchased.value = true;
          // helper.afterPurchase(context);
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (!valid) {
          //   _handleInvalidPurchase(purchaseDetails);
          // }

          break;
        case PurchaseStatus.error:
          // EasyLoading.showToast("Updating Coins");
          // print(
          //     Provider.of<coinsController>(context, listen: false).totalcoins);
          // Provider.of<coinsController>(context, listen: false).totalcoins += 10;
          // print(
          //     Provider.of<coinsController>(context, listen: false).totalcoins);
          // await LoginSignup()
          //     .UpdateCoinsandads(
          //         Provider.of<coinsController>(context, listen: false)
          //             .totalcoins,
          //         context,
          //         user!.email!)
          //     .then((value) =>
          //         Provider.of<coinsController>(context, listen: false)
          //             .updatecoins());

          print('asdasdasdasd:${purchaseDetails.error!.message}');
          if (purchaseDetails.error!.message ==
              'BillingResponse.itemAlreadyOwned') {
            // helper.purchased.value = true;
            // helper.afterPurchase(context);
          }
          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  ListTile _buildProduct({required ProductDetails product}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return ListTile(
      leading: const Icon(
        Icons.credit_card,
        color: Colors.white,
      ),
      title: Text(
        '${product.title} -\n${product.price}',
        style: const TextStyle(color: Colors.white),
      ),
      //subtitle: Text(product.description),
      trailing: InkWell(
        onTap: () async {
          _subscribe(product: product);

          setState(() {});
        },
        child: Container(
          height: h * .05,
          width: w * .25,
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: Text(
              'Subscribe',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  ListTile _buildPurchase({required PurchaseDetails purchase}) {
    print(purchase.status);
    var a;
    if (purchase.error != null) {
      // helper.purchased.value = false;
    } else {
      // helper.purchased.value = true;
      // helper.afterPurchase(context);
    }
    log(a.toString());

    String? transactionDate;
    if (purchase.status == PurchaseStatus.purchased) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchase.transactionDate!),
      );
      transactionDate = ' @ ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }
    return const ListTile(
      title: Text(''),
      subtitle: Text(''),
    );
  }

  void _subscribe({required ProductDetails product}) {
    log(product.id);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('In App Purchase 1.0.8'),
      // ),
      body: _available
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [appbarcolor, primarycolor],
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: h * .03,
                  ),
                  const Text(
                    'Subscriptions',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: h * .05,
                  ),
                  Builder(builder: (context) {
                    while (_products.isEmpty) {
                      return SizedBox(
                          height: h * .05,
                          width: w * .1,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ));
                    }
                    if (_products.isEmpty) {
                      return const Text(
                        "An error occured, Please check your gmail account. This happens when you are either no or more than one gmail accounts logged in.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProduct(
                            product: _products[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.white,
                          );
                        },
                      );
                    }
                  }),
                  Expanded(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _purchases.length,
                            itemBuilder: (context, index) {
                              return _buildPurchase(
                                purchase: _purchases[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('The Store Is Not Available'),
            ),
    );
  }
}
