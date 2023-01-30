import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Controllers/CoinsController.dart';
import '../Controllers/LoginSignUpController.dart';

getcoins(BuildContext context) async {
  await LoginSignup().getcoins().then((value) {
    Provider.of<coinsController>(context, listen: false).totalcoins =
        int.parse(value);

    if (kDebugMode) {
      log(value.toString());
    }
  });
}

getadsstatuts(BuildContext context) async {
  await LoginSignup().getsads().then((value) {
    Provider.of<coinsController>(context, listen: false).isadfree = value;

    if (kDebugMode) {
      log(value.toString());
    }
  });
}

Future<void> deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();
  bool iscachedir = await cacheDir.exists();
  if (iscachedir) {
    cacheDir.delete();
  }
}
