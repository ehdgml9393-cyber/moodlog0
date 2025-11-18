import 'package:supabase_flutter/supabase_flutter.dart';

class LikeRepository {
  final _supabase = Supabase.instance.client;

  /// 특정 record에 내가 좋아요 눌렀는지 확인
  Future<bool> isLiked(String userId, String recordId) async {
    final res = await _supabase
        .from("likes")
        .select()
        .eq("user_id", userId)
        .eq("record_id", recordId)
        .maybeSingle();

    return res != null;
  }

  /// 좋아요 수 가져오기
  Future<int> getLikeCount(String recordId) async {
    final res = await _supabase
        .from("likes")
        .select()
        .eq("record_id", recordId);

    return res.length;
  }

  /// 좋아요 추가
  Future<void> addLike(String userId, String recordId) async {
    await _supabase.from("likes").insert({
      "user_id": userId,
      "record_id": recordId,
    });
  }

  /// 좋아요 취소
  Future<void> removeLike(String userId, String recordId) async {
    await _supabase
        .from("likes")
        .delete()
        .eq("user_id", userId)
        .eq("record_id", recordId);
  }
}
