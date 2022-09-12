import 'package:cloud_firestore/cloud_firestore.dart';

class Calculators {
  final DateTime currentDate = DateTime.now();

  int getAge(DateTime birthDate) {
    int age = currentDate.year - birthDate.year;
    final int currentMonth = currentDate.month;
    final int birthMonth = birthDate.month;
    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      final int currentDay = currentDate.day;
      final int birthDay = birthDate.day;
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age;
  }

  Timestamp getPrevDate(int noOfYears) {
    final prevDate = DateTime(
      currentDate.year - noOfYears,
      currentDate.month,
      currentDate.day,
    );
    return Timestamp.fromDate(prevDate);
  }

  String convertToAgo(DateTime input) {
    String _processOneLetterValue(String val) {
      if (val.length == 1) {
        return '0$val';
      } else {
        return val;
      }
    }

    final day = _processOneLetterValue(input.day.toString());
    final month = _processOneLetterValue(input.month.toString());
    final year = _processOneLetterValue(input.year.toString());
    // final hour = input.hour.toString();
    // final minute = _processOneLetterValue(input.minute.toString());

    final Duration diff = DateTime.now().difference(input);
    if (diff.inDays >= 7) {
      return "$day/$month/$year";
    } else if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}s ago';
    } else {
      return 'just now';
    }
  }

  String convertToAgoOnline(DateTime input) {
    final Duration diff = DateTime.now().difference(input);
    if (diff.inDays >= 7) {
      return "Offline";
    } else if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}s ago';
    } else {
      return 'just now';
    }
  }
}
