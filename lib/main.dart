import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/routes/app_router.dart';
import 'presentation/routes/route_names.dart';
import 'state/providers/app_settings_provider.dart';
import 'state/providers/plan_provider.dart';

import 'state/providers/brand_provider.dart';

import 'state/providers/tips_provider.dart';



import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartMarkApp());
}

class SmartMarkApp extends StatelessWidget {
  const SmartMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),

        ChangeNotifierProvider(create: (_) => BrandProvider()..loadBrand()),

        ChangeNotifierProvider(create: (_) => TipsProvider()..init()),


      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, _) {
         return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'SmartMark',
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: settings.themeMode,
  initialRoute: RouteNames.splash,
  onGenerateRoute: AppRouter.onGenerateRoute,

  // ✅ Arabic + RTL
  locale: const Locale('ar'),
  supportedLocales: const [Locale('ar')],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, child) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child ?? const SizedBox.shrink(),
    );
  },
);

        },
      ),
    );
  }
}
