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

  /// ✅ New function for "last seen"
  static String formatLastSeen(Timestamp? timestamp) {
    if (timestamp == null) return "Unavailable";
    final dateTime = timestamp.toDate();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Only show time
      return DateFormat('hh:mm a').format(dateTime);
    } else if (messageDate == yesterday) {
      // Yesterday + time
      return "Yesterday, ${DateFormat('hh:mm a').format(dateTime)}";
    } else {
      // Full date + time
      return DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
    }
  }
}
