import 'package:supabase_flutter/supabase_flutter.dart';

class RecordRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addRecord({
    required String userId,
    required String emotion,
    required String content,
  }) async {
    try {
      await _supabase.from('records').insert({
        'user_id': userId,
        'emotion': emotion,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print(' 기록 저장 오류: $e');
      rethrow;
    }
  }
}


