import 'package:supabase_flutter/supabase_flutter.dart';

class FeedRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFeeds() async {
    final res = await _supabase
        .from('records_with_user')
        .select('*')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }
}


