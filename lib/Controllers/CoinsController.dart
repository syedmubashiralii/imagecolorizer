import 'package:flutter/cupertino.dart';

class coinsController extends ChangeNotifier {
  int totalcoins = 0;

  bool isadfree = false;

  updatecoins() {
    notifyListeners();
  }

  updateadfree() {
    notifyListeners();
  }
}
