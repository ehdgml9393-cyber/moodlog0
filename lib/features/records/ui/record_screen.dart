import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../feed/ui/feed_screen.dart';
import '../viewmodel/record_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedEmotion = '😊 행복해요';

  final List<String> _emotions = [
    '😊 행복해요',
    '😢 슬퍼요',
    '😡 화나요',
    '😴 피곤해요',
    '😌 편안해요',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("기록하기")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("오늘의 감정 선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: _emotions.map((emotion) {
                final isSelected = _selectedEmotion == emotion;
                return ChoiceChip(
                  label: Text(emotion),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedEmotion = emotion),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text("오늘의 기록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "오늘 하루는 어땠나요?",
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final recordProvider = Provider.of<RecordProvider>(context, listen: false);
                  final user = firebase_auth.FirebaseAuth.instance.currentUser;


                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("로그인된 사용자가 없습니다.")),
                    );
                    return;
                  }

                  await recordProvider.addRecord(
                    userId: user.uid,
                    emotion: _selectedEmotion,
                    content: _contentController.text,
                  );

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("기록이 저장되었습니다.")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedScreen()),
                  );
                },
                child: const Text("저장하기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

