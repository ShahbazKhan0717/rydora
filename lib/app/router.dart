import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../data/providers.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/register_screen.dart';
import '../features/driver/presentation/driver_home_screen.dart';
import '../features/driver/presentation/driver_setup_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/passenger/presentation/passenger_home_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/help_screen.dart';
import '../features/profile/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    // UI guard only. Firestore security rules are the real protection.
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null;
      final loggedIn = auth.value != null;
      final loc = state.matchedLocation;
      const authPages = {
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.onboarding,
      };
      final isPublic = authPages.contains(loc) || loc == AppRoutes.splash;
      if (!loggedIn && !isPublic) return AppRoutes.login;
      if (loggedIn && authPages.contains(loc)) return AppRoutes.passengerHome;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (c, s) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (c, s) => const OnboardingScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (c, s) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.passengerHome,
        builder: (c, s) => const PassengerHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.driverHome,
        builder: (c, s) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.driverSetup,
        builder: (c, s) => const DriverSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (c, s) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (c, s) => const SettingsScreen(),
      ),
      GoRoute(path: AppRoutes.help, builder: (c, s) => const HelpScreen()),
    ],
  );
});
