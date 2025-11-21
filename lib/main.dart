  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  import 'features/auth/viewmodel/auth_provider.dart';
  import 'firebase_options.dart';
  import 'features/feed/viewmodel/feed_provider.dart';
  import 'features/profile/viewmodel/profile_provider.dart';
  import 'features/records/viewmodel/record_provider.dart';

  import 'features/auth/ui/onboarding_screen.dart';
  import 'features/feed/ui/feed_screen.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Supabase.initialize(
      url: 'https://vrhqmdgsbgdowpmqizsr.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyaHFtZGdzYmdkb3dwbXFpenNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3MDA5OTYsImV4cCI6MjA3NzI3Njk5Nn0.lRcqK6UvWPA0m2PSkw2aIUK6lE4EeyMsj-AOvbodD4I',
    );

    runApp(const MoodLogApp());
  }

  class MoodLogApp extends StatelessWidget {
    const MoodLogApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
          ChangeNotifierProvider(create: (_) => FeedProvider()),
          ChangeNotifierProvider(create: (_) => RecordProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
            // 여기서 자동로그인 처리
          home: AuthGate(),
        ),
      );
    }
  }

  class AuthGate extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 이미 로그인되어있으면 ⇒ 홈으로
        return const FeedScreen();
      } else {
        // 로그인 안 되어있으면 ⇒ 온보딩/로그인화면
        return const OnboardingScreen();
      }
    }
  }



