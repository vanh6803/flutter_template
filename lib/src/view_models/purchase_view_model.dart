import 'package:flutter/material.dart';

class PurchaseViewModel extends ChangeNotifier {
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  void setPurchased(bool value) {
    _isSubscribed = value;
    notifyListeners();
  }
}