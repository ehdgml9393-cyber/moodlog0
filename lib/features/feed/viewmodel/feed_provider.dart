import 'package:flutter/material.dart';
import '../data/feed_repository.dart';

class FeedProvider extends ChangeNotifier {
  final FeedRepository _repo = FeedRepository();

  List<Map<String, dynamic>> feeds = [];
  bool isLoading = false;

  Future<void> loadFeeds() async {
    try {
      isLoading = true;
      notifyListeners();
      feeds = await _repo.getFeeds();
    } catch (e) {
      print(' 피드 불러오기 오류: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
