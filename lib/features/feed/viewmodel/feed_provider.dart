import 'package:flutter/material.dart';

class FeedProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _feeds = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get feeds => _feeds;

  /// 피드 불러오기
  Future<void> loadFeeds() async {
    _isLoading = true;
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }
}
