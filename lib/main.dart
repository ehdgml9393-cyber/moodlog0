import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/viewmodel/auth_provider.dart';
import 'features/feed/viewmodel/feed_provider.dart';
import 'features/auth/ui/onboarding_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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


