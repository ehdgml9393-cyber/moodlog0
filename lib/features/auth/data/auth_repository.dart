import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
    '761202198915-g83qhnmifbo8s2h22mqmduafsfr90s8g.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final displayName = user.displayName ?? "사용자";

      // Supabase users 동기화
      final existing = await _supabase
          .from("users")
          .select()
          .eq("user_id", user.uid)
          .maybeSingle();

      if (existing == null) {
        await _supabase.from("users").insert({
          'user_id': user.uid,
          'provider': 'google',
          'nickname': displayName,
          'profile_image': user.photoURL,
        });
      } else {
        await _supabase.from("users").update({
          'nickname': displayName,
          'profile_image': user.photoURL,
        }).eq("user_id", user.uid);
      }
    } catch (e) {
      print("Google 로그인 오류: $e");
      rethrow;
    }
  }
}

