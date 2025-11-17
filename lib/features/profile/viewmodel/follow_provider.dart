import 'package:flutter/material.dart';
import '../data/follow_repository.dart';

class FollowProvider extends ChangeNotifier {
  final FollowRepository _repo = FollowRepository();

  bool isFollowing = false;
  bool isLoading = false;

  Future<void> checkFollow(String myId, String targetId) async {
    isLoading = true;
    notifyListeners();
    isFollowing = await _repo.isFollowing(myId, targetId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFollow(String myId, String targetId) async {
    isLoading = true;
    notifyListeners();

    if (isFollowing) {
      await _repo.unFollow(myId, targetId);
    } else {
      await _repo.follow(myId, targetId);
    }

    isFollowing = !isFollowing;
    isLoading = false;
    notifyListeners();
  }
}
