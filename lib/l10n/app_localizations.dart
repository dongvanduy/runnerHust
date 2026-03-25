import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'history': 'History',
      'kilometer': 'Kilometer',
      'run': 'Run',
      'averagePace': 'Average Pace',
      'time': 'Time',
      'syncGoogleDrive': 'Sync Google Drive',
      'syncing': 'Syncing...',
      'start': 'START',
      'distanceKm': 'Distance (Km)',
      'duration': 'Duration',
      'calories': 'Calories',
      'avgPace': 'Avg Pace',
      'elevationGain': 'Elevation Gain',
      'endRunQuestion': 'End this run?',
      'endRunDesc': 'Do you want to stop and save this run to history?',
      'continueRun': 'Continue',
      'finish': 'Finish',
      'language': 'Language',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'lastActivities': 'Your Last 2 Activities',
      'syncSuccess': 'History synced to Google Drive successfully.',
      'syncFailed': 'Sync failed. Please try again.',
    },
    'vi': {
      'history': 'Lịch sử',
      'kilometer': 'Kilômét',
      'run': 'Buổi chạy',
      'averagePace': 'Pace trung bình',
      'time': 'Thời gian',
      'syncGoogleDrive': 'Đồng bộ Google Drive',
      'syncing': 'Đang đồng bộ...',
      'start': 'BẮT ĐẦU',
      'distanceKm': 'Quãng đường (Km)',
      'duration': 'Thời lượng',
      'calories': 'Calories',
      'avgPace': 'Pace TB',
      'elevationGain': 'Độ cao tích lũy',
      'endRunQuestion': 'Kết thúc buổi chạy?',
      'endRunDesc': 'Bạn có muốn dừng và lưu buổi chạy này vào lịch sử không?',
      'continueRun': 'Tiếp tục',
      'finish': 'Kết thúc',
      'language': 'Ngôn ngữ',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'lastActivities': '2 hoạt động gần nhất',
      'syncSuccess': 'Đồng bộ lịch sử lên Google Drive thành công.',
      'syncFailed': 'Đồng bộ thất bại. Vui lòng thử lại.',
    },
  };

  String t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((Locale l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
