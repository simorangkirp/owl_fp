import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/injection/dependency.injenction.dart';
import 'core/resources/app.translation.dart';
import 'data/dal/services/db.helper.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'presentation/theme/app.theme.dart';
import 'presentation/theme/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initialRoute = await Routes.initialRoute;

  log("Initialize SQL Lite");
  DatabaseHelper().database;

  log("Initialize Get Storage");
  await GetStorage.init();

  log("Initialize Dependency Injection");
  await DependecyInjection.init();

  await initializeDateFormatting('id_ID', null);

  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main(this.initialRoute, {super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildLightTheme(context),
          darkTheme: AppTheme.buildDarkTheme(context),
          themeMode: themeController.theme,
          initialRoute: initialRoute,
          getPages: Nav.routes,
          translations: AppTranslations(),
          locale: const Locale('id', 'ID'),
          fallbackLocale: const Locale('en', 'US'),
          unknownRoute: GetPage(
            name: '/404',
            page: () => Scaffold(
              body: Center(
                child: Text(
                  "Halaman tidak ditemukan",
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
