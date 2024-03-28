import 'package:flutter/material.dart';

class UrlProvider extends ChangeNotifier {
  String _selectedUrl = '';

  String get selectedUrl => _selectedUrl;

  void setSelectedUrl(String url) {
    _selectedUrl = url;
    notifyListeners();
  }
}
