import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RecordProvider extends ChangeNotifier {
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

      print("기록 저장 성공");
      notifyListeners();
    } catch (e) {
      print("기록 저장 실패: $e");
      rethrow;
    }
  }
}

