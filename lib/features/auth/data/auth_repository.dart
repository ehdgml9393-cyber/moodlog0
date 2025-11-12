import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '761202198915-g83qhnmifbo8s2h22mqmduafsfr90s8g.apps.googleusercontent.com',
  );
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      final existingUser = await _supabase
          .from('users')
          .select()
          .eq('user_id', user.uid)
          .maybeSingle();

      if (existingUser != null) {
        print(' 기존 유저 로그인: ${existingUser['nickname']}');
        return existingUser;
      } else {
        final newUserData = {
          'user_id': user.uid,
          'provider': 'google',
          'nickname': user.displayName ?? '이름없음',
          'profile_image': user.photoURL,
          'created_at': DateTime.now().toIso8601String(),
        };
        await _supabase.from('users').insert(newUserData);
        return newUserData;
      }
    } catch (e) {
      print(' 로그인 오류: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  firebase_auth.User? get currentUser => _auth.currentUser;
}


