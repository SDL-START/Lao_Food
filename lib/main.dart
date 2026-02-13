import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/utils/logger_utils.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/firestore_service.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/notification_service.dart';
import 'app/data/services/location_service.dart';
import 'app/data/services/chat_service.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Firebase ──
  await Firebase.initializeApp();
  Log.i('Firebase initialized');

  // ── System UI ──
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ── Services (permanent) ──
  await Get.putAsync(() async => AuthService()..onInit());
  Get.put(FirestoreService(), permanent: true);
  Get.put(StorageService(), permanent: true);
  Get.put(LocationService(), permanent: true);
  Get.put(ChatService(), permanent: true);
  Get.put(NotificationService(), permanent: true);

  Log.i('All services initialized');

  runApp(const LaoFoodApp());
}

class LaoFoodApp extends StatelessWidget {
  const LaoFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Lao Food',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),

          // ── Routes ──
          getPages: AppPages.pages,
          home: const SplashScreen(),
          unknownRoute: GetPage(
            name: '/not-found',
            page: () => Scaffold(
              appBar: AppBar(title: const Text('404')),
              body: const Center(
                child: Text('ບໍ່ພົບໜ້ານີ້', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        );
      },
    );
  }
}
