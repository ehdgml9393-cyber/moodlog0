import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepository {
  final _supabase = Supabase.instance.client;

  // 댓글 불러오기
  Future<List<Map<String, dynamic>>> getComments(String recordId) async {
    final res = await _supabase
        .from("comments")
        .select("*, users(nickname, profile_image)")
        .eq("record_id", recordId)
        .order("created_at", ascending: true);

    return List<Map<String, dynamic>>.from(res);
  }

  // 댓글 추가
  Future<void> addComment(String userId, String recordId, String content) async {
    await _supabase.from("comments").insert({
      "user_id": userId,
      "record_id": recordId,
      "content": content,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  // 댓글 삭제
  Future<void> deleteComment(String commentId) async {
    await _supabase
        .from("comments")
        .delete()
        .eq("comment_id", commentId);
  }
}
