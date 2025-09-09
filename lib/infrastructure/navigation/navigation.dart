import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  const EnvironmentsBadge({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.production
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.qas ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginControllerBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
      binding: ProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardControllerBinding(),
    ),
    GetPage(
      name: Routes.fingerprint,
      page: () => const FingerprintScreen(),
      binding: FingerprintControllerBinding(),
    ),
    GetPage(
      name: Routes.setup,
      page: () => const SetupScreen(),
      binding: SetupControllerBinding(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutScreen(),
      binding: AboutControllerBinding(),
    ),
    GetPage(
      name: Routes.sampletext,
      page: () => const SampletextScreen(),
      binding: SampletextControllerBinding(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const LanguageScreen(),
      binding: LanguageControllerBinding(),
    ),
    GetPage(
      name: Routes.help,
      page: () => const HelpScreen(),
      binding: HelpControllerBinding(),
    ),
    GetPage(
      name: Routes.theme,
      page: () => const ThemeScreen(),
      binding: ThemeControllerBinding(),
    ),
    GetPage(
      name: Routes.masterdata,
      page: () => MasterdataScreen(),
      binding: MasterdataControllerBinding(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      binding: SplashControllerBinding(),
    ),
    GetPage(
      name: Routes.template,
      page: () => TemplateScreen(),
      binding: TemplateControllerBinding(),
    ),
  ];
}
