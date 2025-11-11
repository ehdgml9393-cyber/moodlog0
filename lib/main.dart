import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

import 'features/auth/viewmodel/auth_provider.dart';
import 'features/feed/viewmodel/feed_provider.dart';
import 'features/records/viewmodel/record_provider.dart';
import 'features/auth/ui/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //  Supabase 초기화
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => RecordProvider()),
      ],
      child: MaterialApp(
        title: 'MoodLog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}



