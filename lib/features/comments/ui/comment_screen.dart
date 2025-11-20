import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodel/comment_provider.dart';

class CommentScreen extends StatelessWidget {
  final String recordId;

  const CommentScreen({super.key, required this.recordId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommentProvider()..load(recordId),
      child: Scaffold(
        appBar: AppBar(title: const Text("댓글")),
        body: Column(
          children: [
            Expanded(
              child: Consumer<CommentProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.comments.isEmpty) {
                    return const Center(child: Text("댓글이 없습니다."));
                  }

                  return ListView.builder(
                    itemCount: provider.comments.length,
                    itemBuilder: (context, index) {
                      final c = provider.comments[index];
                      final isMyComment =
                          c["user_id"] ==
                              FirebaseAuth.instance.currentUser!.uid;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: c["users"]?["profile_image"] != null
                              ? NetworkImage(c["users"]["profile_image"])
                              : null,
                          child: c["users"]?["profile_image"] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(c["users"]?["nickname"] ?? "사용자"),
                        subtitle: Text(c["content"]),
                        trailing: isMyComment
                            ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await provider.deleteComment(
                                recordId, c["comment_id"]);
                          },
                        )
                            : null,
                      );
                    },
                  );
                },
              ),
            ),

            // 입력창
            _CommentInput(recordId: recordId),
          ],
        ),
      ),
    );
  }
}

class _CommentInput extends StatefulWidget {
  final String recordId;

  const _CommentInput({required this.recordId});

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "댓글을 입력하세요...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () async {
              if (_controller.text.trim().isEmpty) return;

              await provider.addComment(widget.recordId, _controller.text.trim());
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
