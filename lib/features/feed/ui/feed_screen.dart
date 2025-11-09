import 'package:flutter/material.dart';
import '../data/feed_repository.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FeedRepository _repository = FeedRepository();
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _feeds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  Future<void> _loadFeeds() async {
    final data = await _repository.fetchFeeds();
    setState(() {
      _feeds = data;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodLog', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "오늘의 감정들",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _feeds.length,
                itemBuilder: (context, index) {
                  final feed = _feeds[index];
                  return _buildFeedCard(feed);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: '기록하기'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '프로필'),
        ],
      ),
    );
  }

  Widget _buildFeedCard(Map<String, dynamic> feed) {
    // 감정에 따라 색상 구분
    Color bgColor;
    if (feed["mood"].contains("행복")) {
      bgColor = Colors.yellow[100]!;
    } else if (feed["mood"].contains("슬퍼")) {
      bgColor = Colors.blue[100]!;
    } else {
      bgColor = Colors.orange[100]!;
    }

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(feed["mood"].split(' ')[0], style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(feed["username"], style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(feed["content"], style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            Text(feed["time"], style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

