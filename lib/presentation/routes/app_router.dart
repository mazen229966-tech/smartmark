import 'package:flutter/material.dart';
import 'route_names.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/user_setup_screen.dart';
import '../screens/home/home_screen.dart';

import '../screens/plan/create_plan_wizard_screen.dart';
import '../screens/plan/ai_processing_screen.dart';
import '../screens/plan/generated_plan_screen.dart';
import '../screens/plan/my_plans_screen.dart';
import '../screens/plan/plan_details_screen.dart';

import '../screens/brand/brand_kit_screen.dart';
import '../screens/tips/marketing_tips_screen.dart';
import '../screens/calendar/content_calendar_screen.dart';
import '../screens/settings/settings_screen.dart';

import '../screens/main/main_shell_screen.dart';


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case RouteNames.userSetup:
        return MaterialPageRoute(builder: (_) => const UserSetupScreen());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteNames.createPlan:
        return MaterialPageRoute(builder: (_) => const CreatePlanWizardScreen());

      case RouteNames.processing:
        return MaterialPageRoute(builder: (_) => const AiProcessingScreen());

      case RouteNames.generatedPlan:
        return MaterialPageRoute(builder: (_) => const GeneratedPlanScreen());

      case RouteNames.myPlans:
        return MaterialPageRoute(builder: (_) => const MyPlansScreen());

       case RouteNames.planDetails:
        // نحن نقرأ arguments من ModalRoute داخل الشاشة
        return MaterialPageRoute(
          builder: (_) => PlanDetailsScreen(), // بدون const
          settings: settings,                   // مهم: يمرر arguments
        );


      case RouteNames.brandKit:
        return MaterialPageRoute(builder: (_) => const BrandKitScreen());


      case RouteNames.tips:
        return MaterialPageRoute(builder: (_) => const MarketingTipsScreen());

      case RouteNames.calendar:
        return MaterialPageRoute(builder: (_) => const ContentCalendarScreen());

      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

     case RouteNames.main:
       final idx = (settings.arguments is int) ? settings.arguments as int : 0;
         return MaterialPageRoute(builder: (_) => MainShellScreen(initialIndex: idx));



      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
