import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wissal_app/config/page_path.dart';
import 'package:wissal_app/config/thems.dart';
import 'package:wissal_app/pages/splash_page/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zglseyedydhcvtgxhpfl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpnbHNleWVkeWRoY3Z0Z3hocGZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY0NDY5MDQsImV4cCI6MjA2MjAyMjkwNH0.TQI_8DWncbgdLBaZJRREsR3ZWt5fOm_iyEbImpSjPcQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThem,
        darkTheme: darktThem,
        themeMode: ThemeMode.dark,
        getPages: pagePath,
        home: SplashPage());
  }
}
