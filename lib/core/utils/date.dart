import 'package:intl/intl.dart';

String formatDate(String isoString) {
  try {
    final date = DateTime.parse(isoString).toLocal();
    return DateFormat('yyyy년 MM월 dd일 HH:mm').format(date);
  } catch (e) {
    return isoString;
  }
}
