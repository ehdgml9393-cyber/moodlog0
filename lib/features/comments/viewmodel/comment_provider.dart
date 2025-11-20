import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/comment_repositary.dart';

class CommentProvider extends ChangeNotifier {
  final CommentRepository _repo = CommentRepository();

  List<Map<String, dynamic>> comments = [];
  bool isLoading = false;

  // 댓글 불러오기
  Future<void> load(String recordId) async {
    isLoading = true;
    notifyListeners();

    comments = await _repo.getComments(recordId);

    isLoading = false;
    notifyListeners();
  }

  // 댓글 추가
  Future<void> addComment(String recordId, String content) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _repo.addComment(uid, recordId, content);
    await load(recordId);
  }

  // 댓글 삭제
  Future<void> deleteComment(String recordId, String commentId) async {
    await _repo.deleteComment(commentId);
    await load(recordId);
  }
}

