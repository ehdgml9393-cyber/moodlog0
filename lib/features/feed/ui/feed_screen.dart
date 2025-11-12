import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../records/ui/record_screen.dart';
import '../../profile/ui/my_profile_screen.dart'; // 프로필 화면 import
import '../viewmodel/feed_provider.dart';

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

    // 3개의 화면
    final screens = [
      _buildFeedBody(feedProvider),
      const RecordScreen(),
      const MyProfileScreen(),
    ];

    return Scaffold(
      // 현재 선택된 화면
      body: screens[_selectedIndex],

      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == 0) await feedProvider.loadFeeds();
          setState(() => _selectedIndex = index);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "기록하기"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필"),
        ],
      ),
    );
  }

  // 피드 화면 내용
  Widget _buildFeedBody(FeedProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MoodLog",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.feeds.isEmpty
          ? const Center(child: Text("아직 기록이 없어요 😶"))
          : ListView.builder(
        itemCount: provider.feeds.length,
        itemBuilder: (context, index) {
          final feed = provider.feeds[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Text(
                feed["emotion"] ?? "🙂",
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(feed["content"] ?? ""),
              subtitle: Text(feed["created_at"] ?? ""),
            ),
          );
        },
      ),
    );
  }
}
