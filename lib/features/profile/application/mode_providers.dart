import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode { passenger, driver }

class AppModeNotifier extends Notifier<AppMode> {
  @override
  AppMode build() => AppMode.passenger;

  void setMode(AppMode mode) => state = mode;
}

final appModeProvider = NotifierProvider<AppModeNotifier, AppMode>(
  AppModeNotifier.new,
);
