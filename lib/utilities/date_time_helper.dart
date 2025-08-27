import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeHelper {
  static String formatTimestamp(DateTime timestamp) {
    final DateTime dateTime = timestamp;
    final DateTime now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat('EEEE').format(dateTime); // e.g., Monday
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime); // e.g., 22/08/2025
    }
  }
}
