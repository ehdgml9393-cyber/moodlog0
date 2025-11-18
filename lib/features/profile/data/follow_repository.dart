import 'package:supabase_flutter/supabase_flutter.dart';

class FollowRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> isFollowing(String myId, String targetId) async {
    final res = await _supabase
        .from('follows')
        .select()
        .eq('follower_id', myId)
        .eq('following_id', targetId)
        .maybeSingle();

    return res != null;
  }

  Future<void> follow(String myId, String targetId) async {
    await _supabase.from('follows').insert({
      'follower_id': myId,
      'following_id': targetId,
    });
  }

  Future<void> unFollow(String myId, String targetId) async {
    await _supabase
        .from('follows')
        .delete()
        .eq('follower_id', myId)
        .eq('following_id', targetId);
  }

  //  내가 팔로우한 사용자 목록
  Future<List<Map<String, dynamic>>> getFollowingList(String myId) async {
    final res = await _supabase
        .from('follow_list')
        .select()
        .eq('follower_id', myId);

    return List<Map<String, dynamic>>.from(res);
  }

  //  나를 팔로우한 사용자 목록
  Future<List<Map<String, dynamic>>> getFollowerList(String myId) async {
    final res = await _supabase
        .from('follow_list')
        .select()
        .eq('following_id', myId);

    return List<Map<String, dynamic>>.from(res);
  }
}
