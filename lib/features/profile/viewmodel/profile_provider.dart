import 'package:flutter/material.dart';
import '../data/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  Map<String, dynamic>? profile;
  List<Map<String, dynamic>> followingUsers = [];

  bool isLoading = false;

  Future<void> loadProfile(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      profile = await _repo.getProfile(userId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> loadFollowing(String userId) async {
    followingUsers = await _repo.getFollowingUsers(userId);
    notifyListeners();
  }
}

