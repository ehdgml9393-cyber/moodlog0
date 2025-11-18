import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/like_repository.dart';

class LikeProvider extends ChangeNotifier {
  final LikeRepository _repo = LikeRepository();

  bool isLiked = false;
  int likeCount = 0;

  Future<void> load(String recordId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    isLiked = await _repo.isLiked(uid, recordId);
    likeCount = await _repo.getLikeCount(recordId);

    notifyListeners();
  }

  Future<void> toggle(String recordId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (isLiked) {
      await _repo.removeLike(uid, recordId);
      likeCount--;
    } else {
      await _repo.addLike(uid, recordId);
      likeCount++;
    }

    isLiked = !isLiked;
    notifyListeners();
  }
}
