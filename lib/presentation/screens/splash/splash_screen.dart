import 'package:flutter/material.dart';
import '../../../data/local/prefs/prefs_helper.dart';
import '../../routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNext();
  }

  Future<void> _decideNext() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final hasOnboarded = await PrefsHelper.getHasOnboarded();
    final username = await PrefsHelper.getUsername();

    if (!hasOnboarded) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.onboarding);
      return;
    }

    if (username == null || username.trim().isEmpty) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.userSetup);
      return;
    }

    if (!mounted) return;
   Navigator.pushReplacementNamed(context, RouteNames.main);

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'SmartMark',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
