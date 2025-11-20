import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 기본 프로필 + 통계
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final user = await _supabase
          .from('users')
          .select('user_id, nickname, profile_image')
          .eq('user_id', userId)
          .maybeSingle();

      if (user == null) return null;

      final recordRows = await _supabase
          .from('records')
          .select('emotion')
          .eq('user_id', userId);

      final Map<String, int> emotionCount = {};
      for (final r in recordRows) {
        final emo = r['emotion'] ?? "알수없음";
        emotionCount[emo] = (emotionCount[emo] ?? 0) + 1;
      }

      final followers = await _supabase
          .from('follows')
          .select()
          .eq('following_id', userId);

      final following = await _supabase
          .from('follows')
          .select()
          .eq('follower_id', userId);

      return {
        ...user,
        'emotion_stats': emotionCount,
        'followers': followers.length,
        'following': following.length,
      };
    } catch (e) {
      print("프로필 로드 오류: $e");
      rethrow;
    }
  }

  // 내가 쓴 기록들 가져오기
  Future<List<Map<String, dynamic>>> getMyRecords(String userId) async {
    try {
      final res = await _supabase
          .from('records')
          .select('record_id, emotion, content, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      print("내 기록 목록 오류: $e");
      return [];
    }
  }
}
