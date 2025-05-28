import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:wissal_app/config/page_path.dart';
import 'package:wissal_app/config/thems.dart';
import 'package:wissal_app/pages/splash_page/splash_page.dart';
import 'package:wissal_app/pages/welcom_page/welcom_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initNotifications(); // ✅ تهيئة الإشعارات

  await Supabase.initialize(
    url: 'https://zglseyedydhcvtgxhpfl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpnbHNleWVkeWRoY3Z0Z3hocGZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY0NDY5MDQsImV4cCI6MjA2MjAyMjkwNH0.TQI_8DWncbgdLBaZJRREsR3ZWt5fOm_iyEbImpSjPcQ',
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('is_first_time') ?? true;
  final bool isLoggedIn = Supabase.instance.client.auth.currentUser != null;

  if (isFirstTime) {
    await prefs.setBool('is_first_time', false);
  }

  runApp(MyApp(
    isFirstTime: isFirstTime,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThem,
      darkTheme: darktThem,
      themeMode: ThemeMode.dark,
      getPages: pagePath,
      home: isFirstTime
          ? const WelcomPage()
          : isLoggedIn
              ? const SplashPage()
              : const WelcomPage(),
    );
  }
}
