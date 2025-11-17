import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/follow_repository.dart';

class UserProfileProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FollowRepository _followRepo = FollowRepository();

  Map<String, dynamic>? user;
  List<Map<String, dynamic>> records = [];
  bool isLoading = false;
  bool isFollowing = false;
  bool followLoading = false;

  late String myId;
  late String targetUserId;


  Future<void> init(String targetId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    myId = currentUser.uid;
    targetUserId = targetId;

    await _loadAll();
  }

  Future<void> _loadAll() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1) 유저 정보
      final userRes = await _supabase
          .from('users')
          .select('*')
          .eq('user_id', targetUserId)
          .maybeSingle();

      // 2) 기록
      final recordRes = await _supabase
          .from('records')
          .select('*')
          .eq('user_id', targetUserId)
          .order('created_at', ascending: false);

      // 3) 팔로우 여부
      final following = await _followRepo.isFollowing(myId, targetUserId);

      user = userRes;
      records = List<Map<String, dynamic>>.from(recordRes);
      isFollowing = following;
    } catch (e) {
      print("User profile load error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 팔로우 / 언팔로우 토글
  Future<void> toggleFollow() async {
    // 자기 자신 프로필에서 팔로우 방지
    if (myId == targetUserId) return;

    followLoading = true;
    notifyListeners();

    try {
      if (isFollowing) {
        await _followRepo.unFollow(myId, targetUserId);
      } else {
        await _followRepo.follow(myId, targetUserId);
      }
      isFollowing = !isFollowing;
    } catch (e) {
      print("Follow toggle error: $e");
    } finally {
      followLoading = false;
      notifyListeners();
    }
  }
}
