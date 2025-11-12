import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/profile_provider.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("내 프로필")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: provider.userProfile?['profile_image'] != null
                      ? NetworkImage(provider.userProfile!['profile_image'])
                      : null,
                  child: provider.userProfile == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(provider.userProfile?['nickname'] ?? ""),
                subtitle: const Text("MoodLog 사용자"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await provider.logout();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  }
}
