import 'package:flutter/material.dart';
import 'login_screen.dart';

// 온보딩 화면: 앱을 처음 열었을 때 나오는 시작화면
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mood, color: Colors.blue, size: 120),
            const SizedBox(height: 20),
            const Text(
              'MoodLog',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '감정을 기록하고 공유하는 SNS 😊',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            // 버튼 누르면 로그인 화면으로 이동
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}

