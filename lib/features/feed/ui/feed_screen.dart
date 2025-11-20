import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date.dart';
import '../../comments/ui/comment_screen.dart';
import '../viewmodel/feed_provider.dart';
import '../../records/ui/record_screen.dart';
import '../../profile/ui/my_profile_screen.dart';
import '../../profile/ui/user_profile_screen.dart';
import '../viewmodel/like_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FeedProvider>(context, listen: false).loadFeeds());
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);

    final screens = [
      _buildFeedBody(feedProvider),
      const RecordScreen(),
      const MyProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        // 홈 탭일 때만 앱 종료
        if (_selectedIndex == 0) return true;

        setState(() => _selectedIndex = 0);
        return false;
      },
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) async {
            if (i == 0) await feedProvider.loadFeeds();
            setState(() => _selectedIndex = i);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: "기록하기"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedBody(FeedProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MoodLog", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.feeds.isEmpty
          ? const Center(child: Text("아직 기록이 없어요 😶"))
          : ListView.builder(
        itemCount: provider.feeds.length,
        itemBuilder: (context, index) {
          final feed = provider.feeds[index];
          final recordId = feed["record_id"];

          return ChangeNotifierProvider(
            create: (_) => LikeProvider()..load(recordId),
            child: _FeedItem(feed: feed),
          );
        },
      ),
    );
  }
}

class _FeedItem extends StatelessWidget {
  final Map<String, dynamic> feed;

  const _FeedItem({required this.feed});

  @override
  Widget build(BuildContext context) {
    final likeProvider = Provider.of<LikeProvider>(context);

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Text(
          feed["emotion"] ?? "🙂",
          style: const TextStyle(fontSize: 30),
        ),

        //프로필 클릭 시 상대 프로필 이동
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(
                  userId: feed["user_id"],
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: feed["profile_image"] != null
                    ? NetworkImage(feed["profile_image"])
                    : null,
                child: feed["profile_image"] == null
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                feed["nickname"] ?? "사용자",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(feed["content"] ?? ""),
            const SizedBox(height: 6),
            Text(
              formatDate(feed["created_at"]),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            // 좋아요 버튼
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    likeProvider.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: likeProvider.isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    await likeProvider.toggle(feed["record_id"]);
                  },
                ),
                Text("${likeProvider.likeCount}"),
              ],
            ),

            const SizedBox(height: 6),

            // 댓글 버튼
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommentScreen(recordId: feed["record_id"]),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  "💬 댓글 보기",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
