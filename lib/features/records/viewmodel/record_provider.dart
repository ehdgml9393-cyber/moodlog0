import 'package:flutter/material.dart';
import '../data/record_repository.dart';

class RecordProvider extends ChangeNotifier {
  final RecordRepository _repo = RecordRepository();

  Future<void> addRecord({
    required String userId,
    required String emotion,
    required String content,
  }) async {
    try {
      await _repo.addRecord(
        userId: userId,
        emotion: emotion,
        content: content,
      );
    } catch (e) {
      print("기록 저장 실패: $e");
      rethrow;
    }
  }
}

