import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/routes/app_pages.dart';
import 'package:food_recepi/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/controller/auth_serviece.dart';
import 'auth/views/verifi_code_screen.dart';
import 'bottom_nevigation/views/mobile_bottom.dart';
import 'firebase_options.dart';
import 'onboarding/views/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "",
           home: AuthService().auth.currentUser == null
            ? IntroScreen()
            : AuthService().auth.currentUser!.emailVerified
            ? CustomBottomNavBar()
            : VerifiCodeScreen(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
        );
      },
    ),
  );
}
