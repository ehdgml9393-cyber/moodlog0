import 'package:supabase_flutter/supabase_flutter.dart';


class RecordRepository {
  final SupabaseClient _supabase = Supabase.instance.client;


  // supabase로 받아오기
  Future<void> addRecord({
    required String userId,
    required String emotion,
    required String content,
  }) async {
    await _supabase.from('records').insert({
      'user_id': userId,
      'emotion': emotion,
      'content': content,
    });
  }
}



