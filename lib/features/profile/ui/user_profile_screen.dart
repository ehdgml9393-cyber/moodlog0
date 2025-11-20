import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date.dart';
import '../viewmodel/user_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileProvider()..init(userId),
      child: Consumer<UserProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.user == null) {
            return const Scaffold(
              body: Center(child: Text("사용자 정보를 불러올 수 없습니다.")),
            );
          }

          final user = provider.user!;
          final records = provider.records;

          final currentUser = FirebaseAuth.instance.currentUser;
          final isMe = currentUser != null && currentUser.uid == userId;

          return Scaffold(
            appBar: AppBar(
              title: Text("${user["nickname"]} 님"),
            ),
            body: Column(
              children: [
                const SizedBox(height: 16),

                // 프로필 이미지
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user["profile_image"] != null
                      ? NetworkImage(user["profile_image"])
                      : null,
                  child: user["profile_image"] == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),

                const SizedBox(height: 8),
                Text(
                  user["nickname"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),


                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.followLoading
                            ? null
                            : () {
                          provider.toggleFollow();
                        },
                        child: provider.followLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(provider.isFollowing ? "팔로우 취소" : "팔로우"),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
                const Divider(),

                // 기록 리스트
                Expanded(
                  child: records.isEmpty
                      ? const Center(child: Text("아직 기록이 없어요 😶"))
                      : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, i) {
                      final r = records[i];
                      return ListTile(
                        leading: Text(
                          r["emotion"] ?? "🙂",
                          style: const TextStyle(fontSize: 26),
                        ),
                        title: Text(r["content"] ?? ""),
                        subtitle: Text(
                          formatDate(r["created_at"]),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

