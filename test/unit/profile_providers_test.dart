import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rydora/features/profile/application/profile_providers.dart';

void main() {
  test('profile update trims values', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(userProfileProvider.notifier)
        .update(name: '  Ali Khan ', phone: ' 03001234567 ');

    final profile = container.read(userProfileProvider);
    expect(profile.name, 'Ali Khan');
    expect(profile.phone, '03001234567');
  });

  test('theme mode defaults to system and can change', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);
    container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
