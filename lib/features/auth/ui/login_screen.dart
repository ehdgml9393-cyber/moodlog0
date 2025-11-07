import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_provider.dart';


// 로그인 화면
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_moon, color: Colors.blue, size: 100),
            const SizedBox(height: 20),
            const Text(
              '로그인 방법을 선택하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => authProvider.signInWithGoogle(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Google 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

