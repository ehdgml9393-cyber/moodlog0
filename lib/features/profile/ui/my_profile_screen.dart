import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'followers_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Provider.of<ProfileProvider>(context, listen: false).loadProfile(uid);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profile = provider.profile;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return const Scaffold(body: Center(child: Text("프로필 정보를 불러올 수 없습니다.")));
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("내 프로필")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: profile['profile_image'] != null
                    ? NetworkImage(profile['profile_image'])
                    : null,
                child: profile['profile_image'] == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(profile['nickname']),
              subtitle: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowListScreen(
                              userId: uid, showFollowing: false),
                        ),
                      );
                    },
                    child: Text("팔로워 ${profile['followers']}  "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowListScreen(
                              userId: uid, showFollowing: true),
                        ),
                      );
                    },
                    child: Text("팔로잉 ${profile['following']}"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "감정 통계",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: profile['emotion_stats'].entries.map<Widget>((e) {
                return Chip(
                  label: Text("${e.key} ${e.value}회"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

