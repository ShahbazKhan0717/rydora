import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  const UserProfile({required this.name, this.phone = ''});

  final String name;
  final String phone;
}

/// In-memory demo only. Phase 4 moves this to Firestore.
class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => const UserProfile(name: 'Demo User');

  void update({required String name, required String phone}) {
    state = UserProfile(name: name.trim(), phone: phone.trim());
  }
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) => state = mode;
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
