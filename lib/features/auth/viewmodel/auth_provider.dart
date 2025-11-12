import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../feed/ui/feed_screen.dart';

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '761202198915-g83qhnmifbo8s2h22mqmduafsfr90s8g.apps.googleusercontent.com',
  );

  firebase_auth.User? get user => _auth.currentUser;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebase_auth.User user = userCredential.user!;
      await _ensureUserInSupabase(user);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FeedScreen()),
        );
      }
    } catch (e) {
      debugPrint(" 로그인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 실패: $e")),
      );
    }
  }

  Future<void> _ensureUserInSupabase(firebase_auth.User user) async {
    final existingUser = await _supabase
        .from('users')
        .select()
        .eq('user_id', user.uid)
        .maybeSingle();

    if (existingUser == null) {
      await _supabase.from('users').insert({
        'user_id': user.uid,
        'provider': 'google',
        'nickname': user.displayName ?? '이름없음',
        'profile_image': user.photoURL,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
