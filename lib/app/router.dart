import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/register_screen.dart';
import '../features/driver/presentation/driver_home_screen.dart';
import '../features/driver/presentation/driver_setup_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/passenger/presentation/passenger_home_screen.dart';
import '../features/profile/application/mode_providers.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/help_screen.dart';
import '../features/profile/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.passengerHome,
        builder: (context, state) => const PassengerHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.driverHome,
        // UI guard only. Firestore rules enforce this for real later.
        redirect: (context, state) => ref.read(driverSetupProvider) == null
            ? AppRoutes.driverSetup
            : null,
        builder: (context, state) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.driverSetup,
        builder: (context, state) => const DriverSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) => const HelpScreen(),
      ),
    ],
  );
});
