import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  Map<String, dynamic>? userProfile;
  bool isLoading = false;

  Future<void> loadProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      userProfile = await _repo.fetchUserProfile(userId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
  }
}