import 'package:supabase_flutter/supabase_flutter.dart';

class FeedRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFeeds() async {
    try {
      final response = await _supabase
          .from('records')
          .select('*')
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print(' 피드 로드 실패: $e');
      return [];
    }
  }
}

