import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    final res = await _supabase
        .from('users')
        .select('nickname, profile_image')
        .eq('user_id', userId)
        .maybeSingle();
    return res;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}