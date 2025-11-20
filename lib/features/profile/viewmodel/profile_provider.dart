import 'package:flutter/material.dart';
import '../data/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  Map<String, dynamic>? profile;
  List<Map<String, dynamic>> myRecords = [];   // ✨ 내가 쓴 글들

  bool isLoading = false;

  Future<void> loadProfile(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      // 프로필 + 내 기록 둘 다 불러오기
      profile = await _repo.getProfile(userId);
      myRecords = await _repo.getMyRecords(userId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


