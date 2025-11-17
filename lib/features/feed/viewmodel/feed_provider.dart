import 'package:flutter/material.dart';
import '../data/feed_repository.dart';

class FeedProvider extends ChangeNotifier {
  final FeedRepository _repo = FeedRepository();

  List<Map<String, dynamic>> feeds = [];
  bool isLoading = false;

  Future<void> loadFeeds() async {
    isLoading = true;
    notifyListeners();

    try {
      feeds = await _repo.getFeeds();
    } catch (e) {
      print("Feed load error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}

