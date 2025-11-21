import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/date.dart';
import '../viewmodel/profile_provider.dart';
import '../../auth/viewmodel/auth_provider.dart';
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
    final records = provider.myRecords;

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text("프로필 정보를 불러올 수 없습니다")),
      );
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("내 프로필"),

        // 상단 로그아웃 버튼
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AppAuthProvider>(context, listen: false)
                  .signOut();

              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 영역
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

              // 팔로워 / 팔로잉
              subtitle: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowListScreen(
                            userId: uid,
                            showFollowing: false, // 팔로워
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "팔로워 ${profile['followers']}",
                      style: const TextStyle(
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowListScreen(
                            userId: uid,
                            showFollowing: true, // 팔로잉
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "팔로잉 ${profile['following']}",
                      style: const TextStyle(
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 감정 통계
            const Text(
              "감정 통계",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: profile['emotion_stats'].entries.map<Widget>((e) {
                return Chip(label: Text("${e.key} ${e.value}회"));
              }).toList(),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            /// 🔹 내가 쓴 감정 기록
            const Text(
              "나의 감정 기록",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (records.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text("아직 내가 쓴 기록이 없어요 😶"),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final r = records[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Text(
                        r["emotion"] ?? "🙂",
                        style: const TextStyle(fontSize: 26),
                      ),
                      title: Text(r["content"] ?? ""),
                      subtitle: Text(
                        formatDate(r["created_at"]),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
