import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../feed/ui/feed_screen.dart';
import 'login_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 로그인 O → 홈으로 바로 이동
        if (snapshot.hasData) {
          return const FeedScreen();
        }

        // 로그인 X → 로그인 화면
        return const LoginScreen();
      },
    );
  }
}
