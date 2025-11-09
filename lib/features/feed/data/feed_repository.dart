class FeedRepository {
  //임시 하ㅏ드코딩
  final List<Map<String, dynamic>> _dummyFeeds = [
    {
      "username": "동희",
      "mood": "😊 행복해요",
      "content": "오늘 날씨가 좋아서 기분이 좋아요!",
      "time": "2시간 전",
    },
    {
      "username": "동희2",
      "mood": "😢 슬퍼요",
      "content": "조금 외로운 하루였어요...",
      "time": "5시간 전",
    },
    {
      "username": "동희3",
      "mood": "😢 슬퍼요",
      "content": "조금 외로운 하루였어요...",
      "time": "5시간 전",
    },
    {
      "username": "동희4",
      "mood": "😢 슬퍼요",
      "content": "조금 외로운 하루였어요...",
      "time": "5시간 전",
    },



  ];

  // 피드 가져오기
  Future<List<Map<String, dynamic>>> fetchFeeds() async {

    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 시뮬레이션
    return _dummyFeeds;
  }
}
