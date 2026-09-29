import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatRelative(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatFull(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMMM d, yyyy • h:mm a').format(date);
  }
}
