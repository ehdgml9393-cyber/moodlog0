import 'package:flutter/material.dart';
import '../data/follow_repository.dart';

class FollowListScreen extends StatefulWidget {
  final String userId;
  final bool showFollowing; // true = 팔로잉, false = 팔로워

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.showFollowing,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  final FollowRepository _repo = FollowRepository();

  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future<void> loadList() async {
    setState(() => isLoading = true);

    users = widget.showFollowing
        ? await _repo.getFollowingList(widget.userId)
        : await _repo.getFollowerList(widget.userId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.showFollowing ? "팔로잉" : "팔로워";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? Center(
        child: Text(
          widget.showFollowing
              ? "팔로우한 사람이 없습니다."
              : "나를 팔로우한 사람이 없습니다.",
          style: const TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: u["profile_image"] != null
                  ? NetworkImage(u["profile_image"])
                  : null,
              child: u["profile_image"] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(u["nickname"] ?? "이름없음"),
          );
        },
      ),
    );
  }
}
