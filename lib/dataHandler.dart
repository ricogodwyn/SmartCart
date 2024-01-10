import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class dataHandler with ChangeNotifier {
  String _uid ='';
  num _checkoutPrice=0;
  
  String get uid => _uid;
  num get checkoutPrice => _checkoutPrice;
  

  void pullUid(String uidString) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _uid = uidString;
      notifyListeners();
    });
  }
  void pullCheckoutPrice(num price) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkoutPrice = price;
      notifyListeners();
    });
  }
}