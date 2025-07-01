import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatCount(int count, String localeCode) {
    if (count < 1000) {
      return NumberFormat.decimalPattern(localeCode).format(count);
    }

    if (count < 1_000_000) {
      double value = count / 1000;
      bool hasExtra = count % 100 >= 50;
      String base = NumberFormat.compact(
        locale: localeCode,
      ).format(value * 1000 ~/ 1); // To force "1.2K" with locale
      return hasExtra ? '$base+' : base;
    }

    if (count < 1_000_000_000) {
      double value = count / 1_000_000;
      bool hasExtra = count % 100_000 >= 50_000;
      String base = NumberFormat.compact(
        locale: localeCode,
      ).format(value * 1_000_000 ~/ 1);
      return hasExtra ? '$base+' : base;
    }

    double value = count / 1_000_000_000;
    bool hasExtra = count % 100_000_000 >= 50_000_000;
    String base = NumberFormat.compact(
      locale: localeCode,
    ).format(value * 1_000_000_000 ~/ 1);
    return hasExtra ? '$base+' : base;
  }

  static String formatDuration(int seconds, String localeCode) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    final numberFormat = NumberFormat.decimalPattern(localeCode);

    final String hLabel = _localizedUnit('hour', hours, localeCode);
    final String mLabel = _localizedUnit('minute', minutes, localeCode);
    final String sLabel = _localizedUnit(
      'second',
      remainingSeconds,
      localeCode,
    );

    final String h = numberFormat.format(hours);
    final String m = numberFormat.format(minutes);
    final String s = numberFormat.format(remainingSeconds);

    if (hours > 0 && minutes > 0) {
      return '$h $hLabel $m $mLabel';
    } else if (hours > 0) {
      return '$h $hLabel';
    } else if (minutes > 0) {
      return '$m $mLabel';
    } else {
      return '$s $sLabel'; // show seconds if less than a minute
    }
  }

  static String _localizedUnit(String type, int count, String locale) {
    final isPlural = count != 1;

    final Map<String, Map<String, List<String>>> units = {
      'hour': {
        'en': ['hour', 'hours'],
        'bn': ['ঘন্টা', 'ঘন্টা'],
        'hi': ['घंटा', 'घंटे'],
      },
      'minute': {
        'en': ['minute', 'minutes'],
        'bn': ['মিনিট', 'মিনিট'],
        'hi': ['मिनट', 'मिनट'],
      },
      'second': {
        'en': ['second', 'seconds'],
        'bn': ['সেকেন্ড', 'সেকেন্ড'],
        'hi': ['सेकंड', 'सेकंड'],
      },
    };

    return units[type]?[locale]?[isPlural ? 1 : 0] ??
        units[type]?['en']?[isPlural ? 1 : 0] ??
        type;
  }
}
